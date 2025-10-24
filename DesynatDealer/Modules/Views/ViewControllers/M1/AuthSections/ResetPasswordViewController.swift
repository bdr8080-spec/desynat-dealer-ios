//
//  ResetPasswordViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var txtCreatePassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func doneDidTapped(_ sender: Any) {
        let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
        vc.comingReason = .passwordUpdated
        vc.callBackDismiss = {
            self.navigationController?.popToViewController(ofClass: LoginViewController.self, animated: true)
        }
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnTapCreatePasswordEye(_ sender: UIButton) {
        sender.isSelected.toggle()
        txtCreatePassword.isSecureTextEntry.toggle()
    }
    
    @IBAction func btnTapConfirmPasswordEye(_ sender: UIButton) {
        sender.isSelected.toggle()
        txtConfirmPassword.isSecureTextEntry.toggle()
    }
    
}
