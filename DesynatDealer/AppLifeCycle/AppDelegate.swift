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

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var forOpenFilePickerView = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LocationManager.sharedInstance.startUpdatingLocation()
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.isEnabled = true
        UNUserNotificationCenter.current().delegate = self
        GMSServices.provideAPIKey("AIzaSyBlCfJlRuxElolt6l-4erdJPR9ySUB8Jwk")    // Our google map API
        GMSPlacesClient.provideAPIKey("AIzaSyAekJV3oxQlPy_OWHCxPYfFw5CnrD-Wzkg")
        
        // Desynat - LIVE TOKEN
        MFSettings.shared.configure(token: "aV9kzygsb4NfXt2Y-Fral3t4v6PWme_gswcB3z65VgKnaTg4h2GlguqD5PxddzvFltWDIrc0sWWN5YN42j1_eaFGDdfxslV-YA--csgC1s2A0QYKWcIKK-yznWZWcmHWwmiXZjFHR5cNmcV7nd3jOgg6E5fXPTy6Fuvz4CZ6USLe6QpiyuzzpKpTg-FQAxMc0NaFrPN__S1crNcKSlEDG4qYiPZCaIIGQShjNUirTomBowOBRxGl6SCZS9KWFrvTYx-7T9dc7f7HJ2-juvqI4I0EzYSHrF1YsYDZhNBiRjpa96elFLqpa4HJPMLgBzkW3YQp1B3k_TlsxM3zAyFw7xnx0_5TRtyafr7iMC5aVnCsqKQGoanF6l4ZxMWmEllsXG6SJAFIEDup7r-Z_kw27Suofl2WIMgQG7cqnaCZT7icrtdmopzwsAtxkztkmcMUJWfQGm8K7VyBb4j-_DmyD5n3rD1qBoK7_XGhxnlixiy4tKearr5BChJJriYIG63xYsJKqvrxMMhSGfePAQcNMlxNmla0txkZilO1OXu6T8U09gYmbfeEfEVgnIfzvFpx9dRHvT_XxfrJX11c-xpf7O2eJ3w_VGGgCv0mQNG3qZgVkVZOOr5IieyJPm1d0v64ri4aR--y_jKO_gth7ZPoPKPbTUQCm-hAbAAiUNCFwLmU8ymO", country: .kuwait, environment: MFEnvironment.live
        )
        
//        // AVORA - TESTING TOKEN
//        MFSettings.shared.configure(token: "rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL", country: .kuwait, environment: MFEnvironment.test
//        )
        
        // AVORA - TOKEN
//        MFSettings.shared.configure(token: "hjwN8fTAsBPH3f6Sq8huJH4o0JAa52Fv1SGD7JVvqUlylU72JnCKnTTF974Eq_eeQSJVjCiHG4ndx7cQAwwHX9c3ohdak53eTVc0r-N1aBIC13C8erZGrvISvYVFoVRtdn59h3vDBfPH5qL-fzIvhxCKfbmESgO-IvhcusQJsAxRUjMJ9PRiNc5vJYYo26LXVUxiilwBaO7wbOiMk08_n19lLgQLgN1_hfWl0Mi5uQABnpQUo0LLx8vNLyGV4YQ0TajJ7yPY5SuLzwBFbzCWnKPGKnNj9XgSs6T-rUn5RDOl0h8nYyiJcYs-LKP5gPzLZYF-7yoZuCs5NtAFpWjfcVRO83k1WkpcfVzGd6nEkFQfFskxSDw93dYkIjgNk4b2yRZGp4ny08sbeFSOFX6fxBAlqvtrZ_RPuxxfapL7eePswToOXWRxdXORMKwBCmBLryvOl7XFU3DNPQVgPuvsTSYQ525Idh20uXzTPV5wqSqbUhbuEbGJoQz9P6K1edsCaevhhMXZuBuf1gSzTIoIW1n_ZEeav1z09XccJfLwYNFidMqmjCpqXvou07Q-vNvgdcMCu6SKZGOKq9thX8pvn9vG2Jilt-5VlPY1QE1ZeuSyZTLSSK4Vige5c1ULlEKVUsikLjHmAD6yhT0xTkMm2vA_uwWV_qwAKIdvw8zQaUAiGiF8",country: .unitedArabEmirates, environment: .live
//        )
        
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
