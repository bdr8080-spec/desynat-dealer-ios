//
//  ProfileViewModel.swift
//  DesynatDealer
//
//  Created by fluper on 10/11/25.
//


import Foundation
import UIKit

class ProfileViewModel {
    
    private var hostVC: ProfileViewController
    
    init(hostVC: ProfileViewController) {
        self.hostVC = hostVC
    }
    
    func logoutAPI(){
        WebService.sharedInstance.logoutService() { (response) in
            kSharedSceneDelegate.logoutUser()
            kSharedSceneDelegate.navigateToLoginVC()
            UserDefaults.standard.setValue("No", forKey:"isLogin")
        }
    }

}
