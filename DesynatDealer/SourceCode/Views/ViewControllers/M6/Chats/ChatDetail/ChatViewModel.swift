//
//  ChatViewModel.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 11/01/26.
//

//import Foundation
//
//class ChatViewModel {
//    
//    private var hostVC: ChatViewController
//    var chatDetailsUniqueId: String = ""
//    var chatDetails: [String: FirbaseChat]?
//    
//    init(hostVC: ChatViewController) {
//        self.hostVC = hostVC
//    }
//    
//    func singleChatDetailRequest() {
//        let param: [String: Any] = ["unique_id": chatDetailsUniqueId]
//        WebService.sharedInstance.singleChatDetails(param: param){ response in
//            DispatchQueue.main.async {
//                self.chatDetails = response.firbaseChat
//                self.hostVC.bindData()
//            }
//            
//        }
//    }
//    
//    
//    func sendMessageRequest(messageType: Int) { // type 0 text 1 image ,
//        var param: [String: Any] = ["unique_id": chatDetailsUniqueId,
//                                    "type": messageType,
//                                    "by":"seller"]
//        if messageType == 0 { // for text message
//            guard let message = hostVC.sendMessageTF.text?.trimmed(), !message.isEmpty else {
//                hostVC.showToast(msg: "Please enter message")
//                return
//            }
//            param["message"] = message
//        } else { // for image attachement message
//            guard let messageUrl = hostVC.sendAttachmentImageUrl, !messageUrl.isEmpty else {
//                hostVC.showToast(msg: "Please attach an image")
//                return
//            }
//            param["message"] = messageUrl
//        }
//        WebService.sharedInstance.sendMessageInChat(param: param){ response in
//            DispatchQueue.main.async {
//                // here need to append the sent message in the message list to show that message into chat list
//            }
//            
//        }
//    }
//    
//    
//}


import Foundation
import FirebaseFirestore
//import FirebaseFirestoreSwift

class ChatViewModel {
    
    weak var hostVC: ChatViewController?
    var chatDetailsUniqueId: String = ""
    
    // Your existing API data (for initial load + quotation)
    var apiChatDetails: ChatDetailsDataModel?
    
    // Real-time messages (start empty, listener will fill + update)
    var messages: [ChatMessage] = [] {
        didSet {
            hostVC?.bindData()  // Reload table
        }
    }
    
    private var listener: ListenerRegistration?
    private let db = Firestore.firestore()
    
    init(hostVC: ChatViewController) {
        self.hostVC = hostVC
    }
    
    // Start real-time listener (messages appear live)
    func startListeningForMessages() {
        guard !chatDetailsUniqueId.isEmpty else { return }
        
        let messagesRef = db.collection("chats")
            .document(chatDetailsUniqueId)
            .collection("messages")
            .order(by: "timestamp", descending: false)
        
        listener = messagesRef.addSnapshotListener { [weak self] snapshot, error in
            guard let self else { return }
            if let error {
                print("Error listening: \(error)")
                return
            }
            
            self.messages = snapshot?.documents.compactMap { doc in
                try? doc.data(as: ChatMessage.self)
            } ?? []
        }
    }
    
    func stopListening() {
        listener?.remove()
    }
    
    // Fetch initial chat from YOUR API (keep this!)
    func singleChatDetailRequest() {
        let param: [String: Any] = ["unique_id": chatDetailsUniqueId]
        WebService.sharedInstance.singleChatDetails(param: param) { [weak self] response in
            DispatchQueue.main.async {
                self?.apiChatDetails = response
                // Optional: Seed initial messages from API if not in Firestore yet
                if let firbaseChats = response.firbaseChat {
                    self?.messages = firbaseChats.values.map { oldMessage in
                        ChatMessage(
                            id: oldMessage.id,
                            by: oldMessage.by ?? "unknown",
                            message: oldMessage.message ?? "",
                            type: oldMessage.type ?? "0",
                            timestamp: nil,  // Add if you have times as Timestamp
                            userId: oldMessage.userID
                        )
                    }
                }
                self?.hostVC?.bindData()
            }
        }
    }
    
    // Send via YOUR API (keep original, no change!)
    func sendMessageRequest(messageType: Int) {
        var param: [String: Any] = ["unique_id": chatDetailsUniqueId,
                                    "type": messageType,
                                    "by": "seller"]
        if messageType == 0 {
            guard let message = hostVC?.sendMessageTF.text?.trimmed(), !message.isEmpty else {
                hostVC?.showToast(msg: "Please enter message")
                return
            }
            param["message"] = message
            hostVC?.sendMessageTF.text = ""
        } else {
            guard let messageUrl = hostVC?.sendAttachmentImageUrl, !messageUrl.isEmpty else {
                hostVC?.showToast(msg: "Please attach an image")
                return
            }
            param["message"] = messageUrl
            hostVC?.sendAttachmentImageUrl = ""
        }
        WebService.sharedInstance.sendMessageInChat(param: param) { response in
            DispatchQueue.main.async {
                // Do NOTHING here for appending — listener will catch the new message from backend sync
                print("Message sent via API — waiting for real-time update")
            }
        }
    }
}

