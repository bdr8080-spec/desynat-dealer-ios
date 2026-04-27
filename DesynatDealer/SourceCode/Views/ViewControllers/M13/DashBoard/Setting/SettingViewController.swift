//
//  SettingViewController.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 26/03/26.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var changePasswordView: UIView!
    @IBOutlet weak var deleteAccountView: CustomView!
    
    var hasActionPermission: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteAccountView.isHidden = !hasActionPermission
        changePasswordView.isHidden = !hasActionPermission
    }
    // MARK: - Navigation
    
    @IBAction func NotificationBtnTapped(_ sender: Any) {
        let vc = NotificationViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        vc.hasActionPermission = hasActionPermission
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changePasswordBtnTapped(_ sender: Any) {
        let vc = ChangePassowrdViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        vc.hasActionPermission = hasActionPermission
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
