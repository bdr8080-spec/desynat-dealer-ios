//
//  ResetPasswordViewModel.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 28/10/25.
//

import Foundation
import UIKit

class ResetPasswordViewModel: NSObject {
    private var hostVC: ResetPasswordViewController
    
    init(hostVC: ResetPasswordViewController) {
        self.hostVC = hostVC
    }
    
    func validFields() -> Bool {
            var errorMessage: AlertConstant = .none
            
            let createPassword = String.getString(hostVC.txtCreatePassword.text)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            let confirmPassword = String.getString(hostVC.txtConfirmPassword.text)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Validate create password
            if createPassword.isEmpty {
                errorMessage = .EnterNewPassword
            } else if !createPassword.isValidPassword() {
                errorMessage = .InvalidPasswordFormat
            }
            // Validate confirm password
            else if confirmPassword.isEmpty {
                errorMessage = .EnterConfirmPassword
            } else if createPassword != confirmPassword {
                errorMessage = .PasswordNotMatched
            }
            
            if errorMessage != .none {
                hostVC.showAlert(msg: errorMessage.rawValue)
            }
            
        hostVC.view.endEditing(true)
            return errorMessage == .none
        }
    
    func ResetPassApi() {
        let params: [String: Any] = [
            APIKeys.userId: hostVC.id,
            APIKeys.password: hostVC.txtCreatePassword.text ?? "",
            APIKeys.confirmPassword:hostVC.txtConfirmPassword.text ?? ""
        ]
        
        WebService.sharedInstance.createPasswordService(withParams: params) { user in
            let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
            vc.comingReason = .passwordUpdated
            vc.callBackDismiss = {
                self.hostVC.navigationController?.popToViewController(ofClass: LoginViewController.self, animated: true)
            }
            self.hostVC.navigationController?.present(vc, animated: true)
        }
    }
}

extension ResetPasswordViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtCreatePassword || textField == txtConfirmPassword {
            let currentText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            if currentText.hasPrefix(" ") {
                return false
            }
            
            if currentText.count > 20 {
                return false
            }
        }
        return true
    }
}
