//
//  MyNotificationsListViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 17/03/26.
//

import Foundation

class MyNotificationsListViewModel {
    
    private var hostVC: MyNotificationsListViewController
   // var notificationSentList: [NotificationsList] = []
    
    init(hostVC: MyNotificationsListViewController) {
        self.hostVC = hostVC
    }
    
    func getMyNotificationsListRequest() {
//        WebService.shared.getMyNotificationsListService() { [weak self] response in
//            guard let self = self else { return }
//            notificationSentList = response
//            hostVC.listTableView.reloadData()
//            self.hostVC.noDataFoundLabel.isHidden = !self.notificationSentList.isEmpty
//        }
    }
    
    func markReadNotificationsRequest() {
//        let param: [String:Any] = ["notification_id": [hostVC.selectedNotificationId]]
//        WebService.shared.markReadNotificationsService() { [weak self] response in
//            guard let self = self else { return }
//            getMyNotificationsListRequest()
//        }
    }
}
