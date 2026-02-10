//
//  ChatViewModel.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 11/01/26.
//

import Foundation
import Firebase

class ChatEnquiryViewModel {
    
    var chatDetailsUniqueId: String = ""
    var quotationData: Record?
    var callBackRefresh: (() -> Void)?
    private var existingKeys = Set<String>()
    public var delegate:ChatViewModelDelegate?
    private var hostVC: ChatViewController?
    private var chatDB = Database.database().reference().child("chats")
    private var chatReference:DatabaseReference?
    
    init(hostVC: ChatViewController) {
        self.hostVC = hostVC
    }
    
    func singleChatDetailRequest() {
        let param: [String: Any] = ["unique_id": chatDetailsUniqueId]
        WebService.sharedInstance.singleChatDetails(param: param) { [weak self] response in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                quotationData = response.record
                self.callBackRefresh?()
            }
        }
    }
    
    func checkForEnquiryChat() {
        let ref = self.chatDB.child(chatDetailsUniqueId)
        self.chatReference = ref
        self.getAllChatHistory()
    }
    
    func getAllChatHistory() {
        guard let ref = self.chatReference else { return }
        
        ref.observeSingleEvent(of: .value) { snap in
            var fetchedChats: [Chat] = []
            
            if snap.exists(), let value = snap.value {
                let messages = CommonUtils.getDictionary(value).map { $0.value }
                
                CommonUtils.getModelFromAny(model: [Chat].self, data: messages) { list in
                    // Sort messages by timestamp
                    let sortedList = list.sorted { chatOne, chatTwo in
                        return (chatOne.getCreatedOn() ?? Date()) < (chatTwo.getCreatedOn() ?? Date())
                    }
                    
                    // Add unique keys to prevent duplication
                    for chat in sortedList {
                        let key = (chat.senderId ?? "") + (chat.times ?? "")
                        self.existingKeys.insert(key)
                    }
                    
                    fetchedChats = sortedList
                    self.delegate?.getAllMsg(list: fetchedChats)
                    
                    // Start listening for new messages after loading existing ones
                    self.getNewChat()
                }
            } else {
                // No chat exists
                self.delegate?.getAllMsg(list: [])
                self.getNewChat()
            }
        }
    }
    
    func getNewChat() {
        self.chatReference?.observe(.childAdded, with: { snap in
            guard let value = snap.value else { return }
            
            CommonUtils.getModelFromAny(model: Chat.self, data: value) { message in
                // Generate unique key safely
                let key = (message.senderId ?? "") + (message.times ?? "")
                
                // Only append new messages
                if !self.existingKeys.contains(key) {
                    self.existingKeys.insert(key)
                    self.hostVC?.getNewMsgHanlder(msg: message)
                }
            }
        })
    }
    
    public func sendMsg(msg: String, type: String, by: String = "seller") {
        guard let detail = Global.shared.user,
              let id = detail.id,
              let ref = self.chatReference else { return }
        
        TranslationService.translateToArabic(msg) { arabicText in
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            let isoDate = formatter.string(from: Date())
            let chat = Chat(
                uniqueId: self.chatDetailsUniqueId,
                senderId: String(id),
                type: type,
                message: msg,
                messageAr: arabicText,
                by: by,
                read: 0,
                times: isoDate)
            
            ref.childByAutoId()
                .updateChildValues(chat.toBackendDictionary(uniqueId: self.chatDetailsUniqueId))
        }
        
    }
    
    func buildFullAddress(from details: DeliveryDetails?) -> String {
        guard let details = details else { return "" }
        
        var addressParts: [String] = []
        
        // Base address (if API already provides)
        if let baseAddress = details.address?.trimmingCharacters(in: .whitespacesAndNewlines),
           !baseAddress.isEmpty {
            addressParts.append(baseAddress)
        }
        
        let additionalParts = [
            details.houseNo,
            details.streetNo,
            details.landmark,
            details.city,
            details.state,
            details.countryName,
            details.postalCode,
        ]
        
        for part in additionalParts {
            guard let value = part?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !value.isEmpty else { continue }
            
            if !addressParts.joined(separator: " ").localizedCaseInsensitiveContains(value) {
                addressParts.append(value)
            }
        }
        
        return addressParts.joined(separator: ", ")
    }
}

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

protocol ChatViewModelDelegate {
    func getAllMsg(list:[Chat])
    //  func getNewMsg(msg:Chat)
}
