//
//  MyNotificationsListViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 17/03/26.
//

import Foundation

class MyNotificationsListViewModel {
    
    private var hostVC: MyNotificationsListViewController
    var notificationSentList: [NotificationsList] = []
    private var currentPage = 1
    private var lastPage = 1
    private var isFetching = false
    private var hasMorePages = true
    
    init(hostVC: MyNotificationsListViewController) {
        self.hostVC = hostVC
    }
    
    func getMyNotificationsListRequest(reset: Bool = false) {
        
        guard !isFetching, hasMorePages else { return }
        
        isFetching = true
        
        if reset {
            currentPage = 1
            lastPage = 1
            hasMorePages = true
            notificationSentList.removeAll()
            self.hostVC.noDataFoundLabel.isHidden = false
            self.hostVC.readAllButtonOutlet.isHidden = true
        }
        
        let params: [String: Any] = [
            "page": currentPage,
            "limit": 10]
        WebService.sharedInstance.getNotificationListService(param: params) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isFetching = false
                guard let data = response.data else { return }
                // Append only once
                self.notificationSentList.append(contentsOf: data)
                self.lastPage = response.lastPage ?? 1
                // Decide if more pages exist
                if self.currentPage >= self.lastPage {
                    self.hasMorePages = false
                } else {
                    self.currentPage += 1
                }
                self.hostVC.listTableView.reloadData()
                self.hostVC.noDataFoundLabel.isHidden = !self.notificationSentList.isEmpty
                self.hostVC.readAllButtonOutlet.isHidden = self.notificationSentList.isEmpty
            }
        }
    }
    
    func resetAndFetchStories() {
        currentPage = 1
        lastPage = 1
        isFetching = false
        hasMorePages = true
        notificationSentList.removeAll()
        getMyNotificationsListRequest()
    }
    
    func markReadNotificationsRequest() {
        let param: [String:Any] = ["notification_id": [hostVC.selectedNotificationId]]
        WebService.sharedInstance.markReadNotificationsService(param: param) { [weak self] response in
            guard let self = self else { return }
            resetAndFetchStories()
        }
    }
    
    func markAllReadNotificationsRequest() {
        let param: [String:Any] = ["receiver_type": 1]
        WebService.sharedInstance.markAllReadNotificationsService(param: param) { [weak self] response in
            guard let self = self else { return }
            resetAndFetchStories()
        }
    }
}
