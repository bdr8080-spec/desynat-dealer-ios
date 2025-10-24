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
   
    /// Initialize Application (Reset Application)
//    public func initializeApplication() {
//        navigateTo(vc: ProfileSelectionVC.instantiate(fromAppStoryboard: .Main))
//    }
//    
//    /// Navigate to Login Vc
//    public func navigateToGuestLoginVc() {
//        navigateTo(vc: GuestLogInVC.instantiate(fromAppStoryboard: .Main))
//    }
//    public func navigateToLandLordLoginVc() {
//        navigateTo(vc: LandlordLoginVC.instantiate(fromAppStoryboard: .Main))
//    }
//    public func navigateToAgentLoginVc() {
//        navigateTo(vc: AgentLoginVC.instantiate(fromAppStoryboard: .Main))
//    }
//    public func navigateToSideMenuVc() {
//        navigateTo(vc: SideMenuVC.instantiate(fromAppStoryboard: .Home))
//    }
    // Navigate to Home Vc
    public func navigateToDealerHomeVc() {
        let vc = TabBarVC.instantiate(fromAppStoryboard: .Home)
        navigateTo(vc: vc)
    }
//    public func navigateToAgentHomeVc() {
//        let vc = TabBarVC.instantiate(fromAppStoryboard: .Guest)
//        vc.selectedProfile = .agent
//        navigateTo(vc: vc)
//    }
//    public func navigateToLanlordHomeVc() {
//        let vc = TabBarVC.instantiate(fromAppStoryboard: .Guest)
//        vc.selectedProfile = .landlord
//        navigateTo(vc: vc)
//    }
    
//    public func navigateToProfileSelectScreen() {
//        navigateTo(vc: ProfileSelectionVC.instantiate(fromAppStoryboard: .Main))
//    }
//

//    /// Logout current user and navigate to loginVc
    func logoutUser() {
//        let roleName = Global.shared.user?.role?.name?.lowercased()
//        Global.shared.user = nil
//        kSharedUserDefaults.clearAllData(except: [.deviceToken,.selectedLanguage,.defaultLanguage,.language, .userId])
//        UserDefaults.standard.set("no", forKey: "login")
//        switch roleName{
//            case "landlord":
//            navigateToLandLordLoginVc()
//        case "agent":
//            navigateToAgentLoginVc()
//        default:
//            self.navigateToGuestLoginVc()
//        }
        
    }
//    
//    ///Pass custom vc to make it root controller
    public func navigateTo(vc:UIViewController) {
        let nc = UINavigationController(rootViewController: vc)
        nc.isNavigationBarHidden = true
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        sceneDelegate.window!.rootViewController = nc
        sceneDelegate.window!.makeKeyAndVisible()
    }
}
