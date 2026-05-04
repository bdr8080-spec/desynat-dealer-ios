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
    
    private lazy var viewModel = SettingsViewModel(hostVC: self)
    var hasActionPermission: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteAccountView.isHidden = !hasActionPermission
        changePasswordView.isHidden = !hasActionPermission
    }
    
    // MARK: - Navigation
    @IBAction func deleteAccTapped(_ sender: Any) {
        let nextVC = DeleteAccountViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        nextVC.onYesTapped = { [weak self] in
            guard let self = self else { return }
            viewModel.deleteAccountApi()
        }
        self.navigationController?.present(nextVC, animated: true)
    }
    
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
