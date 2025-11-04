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
    var countryList:[CountryModel] = []
    
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
        let params: [String:Any] = [
            APIKeys.countryCode:loginHostVC.countryCode,
            APIKeys.emailMobile:loginHostVC.emailTextField.text ?? "",
            APIKeys.password: loginHostVC.txtPassword.text ?? "",
            APIKeys.type:loginHostVC.type
        ]
        WebService.sharedInstance.loginService(withParams: params) { (response) in
            if response.storeInformation == "0" {
                kSharedSceneDelegate.navigateToStoreInfo(userId: response.id ?? 0)
                return
            } else if response.bankInformation == "0" {
                kSharedSceneDelegate.navigateToBankInfo(userId: "\(response.id ?? 0)")
            } else if response.adminVerify == "0" {
                kSharedSceneDelegate.navigateToViewDetailsVC(userId: "\(response.id ?? 0)")
            } else if response.adminVerify == "1" {
                kSharedSceneDelegate.navigateToLoginVC()
                CommonUtils.showToast(message: "Your account registration is under review")
            } else if response.adminVerify == "2" {
                UserDefaults.standard.setValue("Yes", forKey:"isLogin")
                kSharedSceneDelegate.navigateToDealerHomeVc()
            }
        }
    }
    
    
    func countryListApi(){
        WebService.sharedInstance.countryListService { list in
            self.countryList = list
        }
    }
}

