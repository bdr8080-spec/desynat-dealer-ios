//
//  SettingsViewModel.swift
//  DesynatDealer
//
//  Created by Fluper New Mac1 on 04/05/26.
//

import Foundation
import UIKit

class SettingsViewModel:NSObject{
    private var hostVC:SettingViewController
    
    init(hostVC: SettingViewController) {
        self.hostVC = hostVC
    }
    
    func deleteAccountApi(){
        WebService.sharedInstance.deleteAccountService() { user in
            kSharedSceneDelegate.logoutUser()
            kSharedSceneDelegate.navigateToLoginVC()
            UserDefaults.standard.setValue("No", forKey:"isLogin")
        }
    }
}
