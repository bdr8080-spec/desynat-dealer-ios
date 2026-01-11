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

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var forOpenFilePickerView = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LocationManager.sharedInstance.startUpdatingLocation()
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.isEnabled = true
        UNUserNotificationCenter.current().delegate = self
        GMSServices.provideAPIKey("AIzaSyBlCfJlRuxElolt6l-4erdJPR9ySUB8Jwk")
        GMSPlacesClient.provideAPIKey("AIzaSyAekJV3oxQlPy_OWHCxPYfFw5CnrD-Wzkg")
        FirebaseApp.configure()
        
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




extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Called when permission is granted and app successfully registers with APNs
        func application(_ application: UIApplication,
                         didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
            let token = tokenParts.joined()
            print("📱 Device Token: \(token)")
        }

        // Called if registration fails
        func application(_ application: UIApplication,
                         didFailToRegisterForRemoteNotificationsWithError error: Error) {
            print("❌ Failed to register for remote notifications: \(error.localizedDescription)")
        }

        // Handle notifications when app is in foreground
        func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    willPresent notification: UNNotification,
                                    withCompletionHandler completionHandler:
                                    @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.banner, .sound, .badge])
        }

        // Handle notification tap
        func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    didReceive response: UNNotificationResponse,
                                    withCompletionHandler completionHandler: @escaping () -> Void) {
            let userInfo = response.notification.request.content.userInfo
            print("🟢 Notification tapped with info: \(userInfo)")
            completionHandler()
        }
}


//com.Avora-User-ios
//com.Rakhi.DesynatDealer
