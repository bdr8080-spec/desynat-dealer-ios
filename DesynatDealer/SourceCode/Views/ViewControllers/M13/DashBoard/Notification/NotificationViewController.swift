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
    @IBOutlet weak var appnotificationbtn: UIButton!
    @IBOutlet weak var pushnotification: UIButton!
    
    var isAppNotification = false
    var isPushNotification = true
    private lazy var viewModel =  NotificationViewModel(hostVC: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getProfile()
    }
    
    @IBAction func inappDidTapped(_ sender: Any) {
        viewModel.updateInAppNotificationSettingRequest()
    }
    
    @IBAction func pushDidTapped(_ sender: Any) {
        viewModel.updatePushNotificationSettingRequest()
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
    
    func populateData() {
        
    }
    
    // MARK: - UI Update
    
    func updateAppNotificationUI() {
            let imageName = isAppNotification ? "toggle_on" : "toggle_off"
        inAppToggleImageView.image = UIImage(named: imageName)
        }
        
        func updatePushNotificationUI() {
            let imageName = isPushNotification ? "toggle_on" : "toggle_off"
            pushNotificationToggleImageView.image = UIImage(named: imageName)
        }
    
}
