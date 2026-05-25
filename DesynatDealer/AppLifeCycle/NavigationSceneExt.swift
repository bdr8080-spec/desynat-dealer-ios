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
    
    public func navigateToWelcomeScreen() {
        let vc = WelcomeScreenViewController.instantiate(fromAppStoryboard: .Main)
        navigateTo(vc: vc)
    }
    
    public func navigateToSelectLanguage() {
        let vc = SelectLanguageViewController.instantiate(fromAppStoryboard:.Main)
        navigateTo(vc: vc)
    }
    
  // Navigate to Login Vc
    public func navigateToLoginVC() {
        navigateTo(vc: LoginViewController.instantiate(fromAppStoryboard: .Main))
    }
    
    public func navigateToViewDetailsVC(userId: String) {
        let vc = SummaryViewController.instantiate(fromAppStoryboard: .Main)
        vc.userId = userId
        navigateTo(vc: vc)
    }

    // Navigate to Home Vc
    public func navigateToDealerHomeVc(selectedIndex: Int = 0) {
        let vc = TabBarVC.instantiate(fromAppStoryboard: .Home)
        vc.initialTabIndex = selectedIndex
        navigateTo(vc: vc)
    }
    
    public func navigateToDashboardHomeVc() {
        let vc = HomeViewController.instantiate(fromAppStoryboard: .Home)
        navigateTo(vc: vc)
    }
    
    public func navigateToStoreInfo(userId: Int) {
        let vc = StoreInformationViewController.instantiate(fromAppStoryboard: .Main)
        vc.userId = userId
        self.navigateTo(vc: vc)
    }
    
    public func navigateToSideMenuVc() {
        let vc = SubDealerSideMenuViewController.instantiate(fromAppStoryboard: .Profile)
        vc.isNeedToHideBackButton = true
        navigateTo(vc: vc)
    }
    
    public func navigateToBankInfo(userId: String) {
        let vc = UploadDocumnetViewController.instantiate(fromAppStoryboard: .Main)
        vc.userId = userId
        self.navigateTo(vc: vc)
    }
    
    public func navigateToSubscriptionView(userId: String) {
        let vc = SubscriptionVC.instantiate(fromAppStoryboard: .Main)
        vc.userId = userId
        self.navigateTo(vc: vc)
    }

    func logoutUser() {
        kSharedUserDefaults.clearAllData(except: [.deviceToken,.userLocation,.selectedLanguage,.defaultLanguage,.language])
        Global.shared.user = nil
        self.navigateToLoginVC()
        UserDefaults.standard.setValue("true", forKey: "isOnBoardingChecked")
        UserDefaults.standard.set("no", forKey: "login")
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
