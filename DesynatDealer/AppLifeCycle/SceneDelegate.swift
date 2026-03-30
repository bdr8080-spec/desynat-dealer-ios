//
//  SceneDelegate.swift
//  DemoProject
//
//  Created by Rakhi Kumari on 22/09/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let islogin = UserDefaults.standard.string(forKey:"isLogin")
        if islogin == "Yes"{
            kSharedSceneDelegate.navigateToDealerHomeVc()
//            if let savedUser: User = kSharedUserDefaults.retrieveModelFor(key: .user, model: User.self) {
//                if savedUser.subcriptionPlanCheck == "1" {
//                    //UserDefaults.standard.setValue("Yes", forKey:"isLogin")
//                    kSharedSceneDelegate.navigateToDealerHomeVc()
//                } else {
//                    kSharedSceneDelegate.navigateToSubscriptionView(userId: "\(savedUser.id ?? 0)")
//                }
//            }
        } else {
            kSharedSceneDelegate.navigateToSelectLanguage()
        }
//        if let savedUser: User = kSharedUserDefaults.retrieveModelFor(key: .user, model: User.self) {
//            if savedUser.subcriptionPlanCheck == "1" {
//                UserDefaults.standard.setValue("Yes", forKey:"isLogin")
//                kSharedSceneDelegate.navigateToDealerHomeVc()
//            } else {
//                kSharedSceneDelegate.navigateToSubscriptionView(userId: "\(savedUser.id ?? 0)")
//            }
//        } else {
//
//        }
//        if islogin == "Yes"{
//            if savedUser.subcriptionPlanCheck == "1" {
//                UserDefaults.standard.setValue("Yes", forKey:"isLogin")
//                kSharedSceneDelegate.navigateToDealerHomeVc()
//            } else {
//                kSharedSceneDelegate.navigateToSubscriptionView(userId: "\(response.id ?? 0)")
//            }
////            kSharedSceneDelegate.navigateToDealerHomeVc()
//        }else{
//            kSharedSceneDelegate.navigateToSelectLanguage()
//        }
//
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
//        BadgeManager.shared.reset()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

