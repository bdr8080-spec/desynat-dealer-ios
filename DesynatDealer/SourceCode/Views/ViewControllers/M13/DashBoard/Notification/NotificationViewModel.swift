//
//  SettingsViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 24/03/26.
//

import Foundation
class NotificationViewModel{
    private var hostVC: NotificationViewController
    
    init(hostVC: NotificationViewController) {
        self.hostVC = hostVC
    }
    
    func updatePushNotificationSettingRequest() {
        WebService.sharedInstance.updatePushNotificationSettingService() { [weak self] response in
            guard let self = self else { return }
            self.hostVC.isPushNotification = (response.notification == 0) ? false : true
            self.hostVC.updatePushNotificationUI()
        }
    }
    
    func updateInAppNotificationSettingRequest() {
        WebService.sharedInstance.updateInAppNotificationSettingService() { [weak self] response in
            guard let self = self else { return }
            self.hostVC.isAppNotification = (response.appNotification == 0) ? false : true
            self.hostVC.updateAppNotificationUI()
        }
    }

    
    func getProfile() {
            WebService.sharedInstance.getUserProfile { [weak self] response in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.hostVC.isPushNotification = (response.notification == 0) ? false : true
                    self.hostVC.isAppNotification = (response.appNotification == 0) ? false : true
                    self.hostVC.updatePushNotificationUI()
                    self.hostVC.updateAppNotificationUI()
                }
            }
        }
    
    func deleteAccountApi(){
        WebService.sharedInstance.deleteAccountService() { user in
            kSharedSceneDelegate.logoutUser()
            kSharedSceneDelegate.navigateToLoginVC()
            UserDefaults.standard.setValue("No", forKey:"isLogin")
        }
    }
    
}
