//
//  ChatInboxListViewModel.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 11/01/26.
//

import Foundation

class ChatInboxListViewModel {
    
    private var hostVC: ChatInboxListViewController
    var chatList: [ChatInboxListModel]?
    var searchText: String = ""
    var appliedFilter = ChatInboxListFilterModel()
    
    init(hostVC: ChatInboxListViewController) {
        self.hostVC = hostVC
    }
    
    func getChatInboxRequest() {
        var param: [String: Any] = [:]
        if !searchText.isEmpty {
            param["search"] = searchText
        }
        if let status = appliedFilter.orderDeliveryStatus { //// 1 all 2 wating 3 quataion recived 4 accpeed
            param["filters"] = status + 1
        }
        WebService.sharedInstance.getAllChatsList(param: param){ response in
            DispatchQueue.main.async {
                self.chatList = response
                self.hostVC.bindData()
                let chat = self.chatList ?? []
                self.hostVC.noChatFoundLabel.isHidden = !chat.isEmpty
            }
        }
    }
}
