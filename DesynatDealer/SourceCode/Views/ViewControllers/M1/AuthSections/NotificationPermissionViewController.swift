//
//  NotificationPermissionViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit
import UserNotifications

class NotificationPermissionViewController: UIViewController {
    
    var onPermissionCompletion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func allowDidTapped(_ sender: Any) {
        requestNotificationPermission()
    }
    
    @IBAction func denyDidTapped(_ sender: Any) {
        self.dismiss(animated: true) { [weak self] in
            self?.onPermissionCompletion?()
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if granted {
//                    print("Permission granted")
                    UIApplication.shared.registerForRemoteNotifications()
                }
                self.navigateBack()
            }
        }
    }
    
    func navigateBack() {
        self.dismiss(animated: true) { [weak self] in
            self?.onPermissionCompletion?()
        }
    }
    
}
