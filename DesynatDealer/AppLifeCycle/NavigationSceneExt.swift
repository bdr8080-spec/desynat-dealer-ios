////
////  NavigationSceneExt.swift
////  ChorApp
////
////  Created by Developer on 18/12/23.
////
//
import Foundation
import UIKit                 

extension SceneDelegate {
   
//    /// Navigate to Login Vc
    public func navigateToLoginVC() {
        navigateTo(vc: LoginViewController.instantiate(fromAppStoryboard: .Main))
    }

    // Navigate to Home Vc
    public func navigateToDealerHomeVc() {
        let vc = TabBarVC.instantiate(fromAppStoryboard: .Home)
        navigateTo(vc: vc)
    }

    func logoutUser() {
        kSharedUserDefaults.clearAllData(except: [.deviceToken,.userLocation,.selectedLanguage,.defaultLanguge,.language])
        //UserDefaults.standard.setValue("Yes", forKey: "isAppInstalled")
        Global.shared.user = nil
        self.navigateToLoginVC()
    }

//    ///Pass custom vc to make it root controller
    public func navigateTo(vc:UIViewController) {
        let nc = UINavigationController(rootViewController: vc)
        nc.isNavigationBarHidden = true
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        sceneDelegate.window!.rootViewController = nc
        sceneDelegate.window!.makeKeyAndVisible()
    }
}
