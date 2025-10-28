//
//  LoginViewModel.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 28/10/25.
//

import Foundation
import UIKit

class LoginViewModel: NSObject {
    
    private var loginHostVC: LoginViewController
    
    init(loginHostVC: LoginViewController) {
        self.loginHostVC = loginHostVC
    }
    
    func validFields() -> Bool {
        var errorMessage: AlertConstant = .none
        let input = String.getString(loginHostVC.emailTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        
        if input.isEmpty {
            errorMessage = .EnterEmailOrMobileNumber
        } else if input.isEmail() {
            if !input.isValidEmail() {
                errorMessage = .EnterValidEmailAddress
            }
        } else if input.isPhoneNumber() {
            if !input.isValidPhoneNumber() {
                errorMessage = .validMobileNumber
            }
        } else {
            errorMessage = .EnterValidEmailorMobile
        }
        
        let password = String.getString(loginHostVC.txtPassword.text).trimmingCharacters(in: .whitespacesAndNewlines)
        
        if errorMessage == .none {
            if password.isEmpty {
                errorMessage = .EnterPassword
            } else if !password.isValidPassword() {
                errorMessage = .InvalidPasswordFormat
            }
        }
        
        if errorMessage != .none {
            loginHostVC.showAlert(msg: errorMessage.rawValue)
        }
        
        loginHostVC.view.endEditing(true)
        return errorMessage == .none
    }
    
    func loginApi() {
        //        let params: [String:Any] = [
        //            APIKeys.countryCode: loginHostVC.lblCountryCode.text ?? "+91",
        //            APIKeys.emailMobileNo: loginHostVC.txtEmailMobile.text ?? " ",
        //            APIKeys.password: loginHostVC.txtPassword.text ?? "",
        //            APIKeys.roleId: kSharedUserDefaults.getStringFor(key: .userId) ?? ""
        //        ]
        //        WebService.sharedInstance.loginWithEmailMobileService(withParams: params) { (response) in
        //        kSharedSceneDelegate.navigateToDealerHomeVc()
        //        }
    }
}

