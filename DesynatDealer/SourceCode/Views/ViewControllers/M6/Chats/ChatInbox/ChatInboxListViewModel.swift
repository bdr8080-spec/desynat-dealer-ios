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
    
    init(hostVC: ChatInboxListViewController) {
        self.hostVC = hostVC
    }
    
    func getChatInboxRequest() {
        WebService.sharedInstance.getAllChatsList(){ response in
          DispatchQueue.main.async {
            self.chatList = response
            self.hostVC.bindData()
          }
        }
    }
}
