//
//  SettingsViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 24/03/26.
//

import UIKit

class NotificationViewController: UIViewController {
    
    @IBOutlet weak var pushNotificationToggleImageView: UIImageView!
    @IBOutlet weak var inAppToggleImageView: UIImageView!
    
    
    var isAppNotification  : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func inappDidTapped(_ sender: Any) {
        
    }
    
    @IBAction func pushDidTapped(_ sender: Any) {
        
    }
    
    @IBAction func deleteAccountDidTapped(_ sender: Any) {
        let nextVC = DeleteAccountViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        nextVC.onYesTapped = { [weak self] in
            guard let self = self else { return }
            self.deleteAccountRequest()
        }
        self.navigationController?.present(nextVC, animated: true)
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func deleteAccountRequest(){
        //        WebService.sharedInstance.logoutService() { (response) in
        //            kSharedSceneDelegate.logoutUser()
        //            kSharedSceneDelegate.navigateToLoginVc()
        //            UserDefaults.standard.setValue("No", forKey:"isLogin")
        //        }
    }
    
}
