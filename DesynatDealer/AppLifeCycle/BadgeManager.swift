//
//  BadgeManager.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 30/03/26.
//


//import UIKit
//import UserNotifications
//
//class BadgeManager {
//    static let shared = BadgeManager()
//    private init() {}
//    
//    private(set) var currentCount: Int = 0
//    
//    /// Set exact badge count (best way)
//    func setCount(_ count: Int) {
//        let newCount = max(0, count)
//        currentCount = newCount
//        
//        DispatchQueue.main.async {
//            self.updateSystemBadge(to: newCount)
//        }
//    }
//    
//    func increment() {
//        setCount(currentCount + 1)
//    }
//    
//    func decrement() {
//        setCount(currentCount - 1)
//    }
//    
//    func reset() {
//        setCount(0)
//    }
//    
//    // Private helper - tries both old and new APIs for maximum compatibility
//    private func updateSystemBadge(to count: Int) {
//        // Modern way (iOS 16+)
//        if #available(iOS 16.0, *) {
//            UNUserNotificationCenter.current().setBadgeCount(count) { error in
//                if let error = error {
//                    print("Failed to set badge count: \(error.localizedDescription)")
//                }
//            }
//        }
//        
//        // Fallback for older iOS (still works on many devices)
//        UIApplication.shared.applicationIconBadgeNumber = count
//    }
//}
