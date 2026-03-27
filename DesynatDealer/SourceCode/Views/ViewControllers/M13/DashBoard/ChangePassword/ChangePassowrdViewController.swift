//
//  ChangePassowrdViewController.swift
//  DesynatUser
//
//  Created by fluper on 06/11/25.
//

import UIKit

class ChangePassowrdViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var txtOldPassword: UITextField!
    @IBOutlet weak var txtNewPass: UITextField!
    @IBOutlet weak var txtConfirmPass: UITextField!
    
    // MARK: - Property Decalaration
    private lazy var viewModel = ChangePassowrdViewModel(hostVC:self)
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Button's Action
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changePasswordBtnAction(_ sender: Any) {
        guard let oldPassword = txtOldPassword.text, !oldPassword.isEmpty else {
            showAlert(msg: "Please enter old password")
            return
        }
        
        guard let newPassword = txtNewPass.text, !newPassword.isEmpty else {
            showAlert(msg: "Please enter new password")
            return
        }
        
        // Password format validation
        if !newPassword.isValidPassword() {
            showAlert(msg: "Password must be at least 8 characters long and contain letters and numbers")
            return
        }
        
        guard let confirmPassword = txtConfirmPass.text, !confirmPassword.isEmpty else {
            showAlert(msg: "Please enter confirm password")
            return
        }
        
        // Match new & confirm password
        if newPassword != confirmPassword {
            showAlert(msg: "Passwords do not match")
            return
        }
    }
    
    @IBAction func btnTapEyeOldPass(_ sender:UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true{
            txtOldPassword.isSecureTextEntry = false
        }else{
            txtOldPassword.isSecureTextEntry = true
        }
    }
    
    @IBAction func btnTapEyeNewPass(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true{
            txtNewPass.isSecureTextEntry = false
        } else{
            txtNewPass.isSecureTextEntry = true
        }
    }
    
    @IBAction func btnTapEyeConfirmPass(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true{
            txtConfirmPass.isSecureTextEntry = false
        }else{
            txtConfirmPass.isSecureTextEntry = true
        }
    }
    
}
