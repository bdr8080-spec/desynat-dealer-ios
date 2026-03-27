//
//  AppDelegate.swift
//  DemoProject
//
//  Created by Rakhi Kumari on 22/09/25.
//

import UIKit
import GoogleMaps
import IQKeyboardManagerSwift
import GooglePlaces
import UserNotifications
import DropDown
import MFSDK
import FirebaseCore
import UserNotifications
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
    
    var forOpenFilePickerView = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LocationManager.sharedInstance.startUpdatingLocation()
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.isEnabled = true
        UNUserNotificationCenter.current().delegate = self
        GMSServices.provideAPIKey("AIzaSyBlCfJlRuxElolt6l-4erdJPR9ySUB8Jwk")
        GMSPlacesClient.provideAPIKey("AIzaSyAekJV3oxQlPy_OWHCxPYfFw5CnrD-Wzkg")
        UNUserNotificationCenter.current().delegate = self
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        confrigNotification(application: application)
        // Desynat - LIVE TOKEN
        //        MFSettings.shared.configure(token: "aV9kzygsb4NfXt2Y-Fral3t4v6PWme_gswcB3z65VgKnaTg4h2GlguqD5PxddzvFltWDIrc0sWWN5YN42j1_eaFGDdfxslV-YA--csgC1s2A0QYKWcIKK-yznWZWcmHWwmiXZjFHR5cNmcV7nd3jOgg6E5fXPTy6Fuvz4CZ6USLe6QpiyuzzpKpTg-FQAxMc0NaFrPN__S1crNcKSlEDG4qYiPZCaIIGQShjNUirTomBowOBRxGl6SCZS9KWFrvTYx-7T9dc7f7HJ2-juvqI4I0EzYSHrF1YsYDZhNBiRjpa96elFLqpa4HJPMLgBzkW3YQp1B3k_TlsxM3zAyFw7xnx0_5TRtyafr7iMC5aVnCsqKQGoanF6l4ZxMWmEllsXG6SJAFIEDup7r-Z_kw27Suofl2WIMgQG7cqnaCZT7icrtdmopzwsAtxkztkmcMUJWfQGm8K7VyBb4j-_DmyD5n3rD1qBoK7_XGhxnlixiy4tKearr5BChJJriYIG63xYsJKqvrxMMhSGfePAQcNMlxNmla0txkZilO1OXu6T8U09gYmbfeEfEVgnIfzvFpx9dRHvT_XxfrJX11c-xpf7O2eJ3w_VGGgCv0mQNG3qZgVkVZOOr5IieyJPm1d0v64ri4aR--y_jKO_gth7ZPoPKPbTUQCm-hAbAAiUNCFwLmU8ymO", country: .kuwait, environment: MFEnvironment.test
        //        )
        
        // My Fahtoorah Payment Gateway
        MFSettings.shared.configure(token: "SK_KWT_vVZlnnAqu8jRByOWaRPNId4ShzEDNt256dvnjebuyzo52dXjAfRx2ixW5umjWSUx", country: .kuwait, environment: MFEnvironment.test)
        let them = MFTheme(navigationTintColor: .white, navigationBarTintColor: .lightGray, navigationTitle: "Payment", cancelButtonTitle: "Cancel")
        MFSettings.shared.setTheme(theme: them)
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func dropDown(dataSource:[String] , anchorView:UIView , completion: @escaping (  _ index: Int ,  _ item: String) -> ()) -> Void {
        let dropDown = DropDown()
        dropDown.anchorView = anchorView
        dropDown.dataSource = dataSource
        dropDown.backgroundColor = UIColor.white
        dropDown.textColor = .black
        dropDown.direction = .bottom
        dropDown.selectionBackgroundColor = UIColor.white
        dropDown.selectedTextColor = .black
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dismissMode = .automatic
        dropDown.show()
        dropDown.selectionAction = {(index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            completion(index,item)
            
        }
    }
    
}

// MARK: - Permissions
extension AppDelegate:UNUserNotificationCenterDelegate {
    
    func confrigNotification(application:UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            guard granted else { return }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()  // only once
            }
        }
    }
    
    private func registerForPushNotification(_ application: UIApplication) {
        let current = UNUserNotificationCenter.current()
        current.delegate = self
        current.requestAuthorization(options: [.alert, .badge, .sound]) { (flag, error) in
            if error == nil {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().setAPNSToken(deviceToken,type: .unknown)
        fetchFirebaseToken()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        kSharedUserDefaults.saveValue(Key: .deviceToken, value: fcmToken)
    }
    
    fileprivate func fetchFirebaseToken() {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = token {
                print("Remote instance ID token: \(result)")
                kSharedUserDefaults.saveModelFor(key: .deviceToken, value: token)
            }
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {}
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let payload = notification.request.content.userInfo
                    
                    // Convert payload to JSON text
                    if let jsonText = payload.toPrettyString() {
                        showShareAlert(withText: jsonText)
                    }
                    
                    if #available(iOS 14.0, *) {
                        completionHandler([.banner, .badge, .sound])
                    } else {
                        completionHandler([.alert, .badge, .sound])
                    }
         
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let payload = response.notification.request.content.userInfo
        if let jsonText = payload.toPrettyString() {
                        showShareAlert(withText: jsonText)
                    }
         
                    // Later you use payload to navigate screens
                    // handleDeepLinks(payload)
         
                    completionHandler()
    }
    
    
    func showShareAlert(withText text: String) {
        // Get the top-most view controller
        guard let topVC = topViewController() else { return }
        
        // Create alert
        let alert = UIAlertController(title: "Debug / Share", message: text, preferredStyle: .alert)
        
        // Add Share button
        let shareAction = UIAlertAction(title: "Share", style: .default) { _ in
            let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = topVC.view // for iPad
            topVC.present(activityVC, animated: true, completion: nil)
        }
        
        // Add Copy button (optional, handy for debugging)
        let copyAction = UIAlertAction(title: "Copy", style: .default) { _ in
            UIPasteboard.general.string = text
        }
        
        // Add Cancel button
        let cancelAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        
        alert.addAction(shareAction)
        alert.addAction(copyAction)
        alert.addAction(cancelAction)
        
        // Present alert
        topVC.present(alert, animated: true, completion: nil)
    }
 
    
    func topViewController(base: UIViewController? = UIApplication.shared.connectedScenes
                                    .compactMap { $0 as? UIWindowScene }
                                    .flatMap { $0.windows }
                                    .first { $0.isKeyWindow }?
                                    .rootViewController) -> UIViewController? {
     
            if let nav = base as? UINavigationController {
                return topViewController(base: nav.visibleViewController)
            }
            if let tab = base as? UITabBarController {
                return topViewController(base: tab.selectedViewController)
            }
            if let presented = base?.presentedViewController {
                return topViewController(base: presented)
            }
            return base
        }
    
}
extension Dictionary {
    func toPrettyString() -> String? {
        if JSONSerialization.isValidJSONObject(self),
           let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted),
           let text = String(data: data, encoding: .utf8) {
            return text
        }
        return nil
    }
}
