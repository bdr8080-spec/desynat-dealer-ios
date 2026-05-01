//
//  SignupViewModel.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 28/10/25.
//

import Foundation
import UIKit

class SignupViewModel: NSObject {
    private var hostVC: SignupViewController
    var countryList:[CountryModel] = []
    
    init(hostVC: SignupViewController) {
        self.hostVC = hostVC
    }
    
    func validFields() -> Bool {
        var errorMessage: AlertConstant = .none
        
        if hostVC.selectedImage == nil {
            errorMessage = .SelectProfileImage
        }
        
        let fullName = String.getString(hostVC.firstNameTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if fullName.isEmpty {
                errorMessage = .EnterFirstName
            }
        }
        
        let lastName = String.getString(hostVC.lastNameTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if lastName.isEmpty {
                errorMessage = .EnterLastName
            }
        }
        let mobile = String.getString(hostVC.mobileTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if mobile.isEmpty {
                errorMessage = .EnterMobileNumber
            } else if !mobile.isValidPhoneNumber() {
                errorMessage = .validMobileNumber
            }
        }
        
        
        let email = String.getString(hostVC.emailTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if email.isEmpty {
                errorMessage = .EnterEmail
            } else if !email.isValidEmail() {
                errorMessage = .EnterValidEmailAddress
            }
        }
        
        
        let password = String.getString(hostVC.txtCreatePassword.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if password.isEmpty {
                errorMessage = .EnterPassword
            }else if !password.isValidPassword() {
                errorMessage = .InvalidPasswordFormat
            }
        }
        
        let confirmPassword = String.getString(hostVC.txtConfirmPassword.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if confirmPassword.isEmpty {
                errorMessage = .EnterConfirmPassword
            } else if confirmPassword != password {
                errorMessage = .PasswordNotMatched
            }
        }
        
        if errorMessage == .none {
            if !hostVC.isTermsAccepted {
                errorMessage = .AcceptTermsAndConditions
            }
        }
        
        if errorMessage != .none {
            hostVC.showAlert(msg: errorMessage.rawValue.localiz())
        }
        
        hostVC.view.endEditing(true)
        return errorMessage == .none
    }
    
    //Mark:->SignUpAPi
    func signUpApi(){
        let params:[String:Any] = [
            APIKeys.profilePic:hostVC.profileImage,
            APIKeys.firstName:hostVC.firstNameTextField.text ?? "",
            APIKeys.countryCode:hostVC.countryCode,
            APIKeys.lastName:hostVC.lastNameTextField.text ?? "",
            APIKeys.mobile:hostVC.mobileTextField.text ?? "",
            APIKeys.email:hostVC.emailTextField.text ?? "",
            APIKeys.password:hostVC.txtCreatePassword.text ?? "",
            APIKeys.confirmPassword:hostVC.txtConfirmPassword.text ?? "",
            APIKeys.acceptTerms:"1",
            APIKeys.deviceType:"1",
            APIKeys.deviceToken:""
        ]
        
        WebService.sharedInstance.signUpService(withParams:params) { user in
            let vc = OTPViewController.instantiate(fromAppStoryboard: .Main)
            vc.comingReason = .signup
            vc.userId = user.id ?? 0
            vc.type = 0
            vc.email = user.email ?? ""
            vc.emailMobileType = 1
            self.hostVC.navigationController?.pushViewController(vc, animated: true)

        }
    }
    

    func countryListApi(){
        WebService.sharedInstance.countryListService { list in
            self.countryList = list
        }
    }
}
