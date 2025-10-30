//
//  ForgotPasswordViewModel.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 28/10/25.
//

import Foundation
import UIKit

class ForgotPasswordViewModel: NSObject {
    private var hostVC: ForgotPasswordViewController
    
    init(hostVC: ForgotPasswordViewController) {
        self.hostVC = hostVC
    }
    
    
    func validFields(mobileIsSelected: Bool) -> Bool {
        var errorMessage: AlertConstant = .none
        if mobileIsSelected {
            let input = String.getString(hostVC.mobileTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
            if input.isEmpty {
                errorMessage = .EnterMobileNumber
            }else if !input.isValidPhoneNumber() {
                errorMessage = .validMobileNumber
            }
        } else {
            let input = String.getString(hostVC.emailAddressTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
            if input.isEmpty {
                errorMessage = .EnterEmail
            } else if !input.isValidEmail() {
                errorMessage = .EnterValidEmailAddress
            }
        }
        
        if errorMessage != .none {
            hostVC.showAlert(msg: errorMessage.rawValue)
        }
        
        hostVC.view.endEditing(true)
        return errorMessage == .none
    }
    
    //Mark:->ForgotPasswordApi
    func forgotPasswordApi(isMobileSelected:Bool){
        var param: [String:Any] = [:]
        
        if isMobileSelected {
            param = [
                APIKeys.type:hostVC.accountType,
                APIKeys.countryCode:hostVC.countryCode,
                APIKeys.mobile:hostVC.mobileTextField.text ?? "",
            ]
        }else {
            
            param = [
                APIKeys.type:hostVC.accountType,
                APIKeys.email:hostVC.emailAddressTextField.text ?? ""
            ]
        }
        
        WebService.sharedInstance.forgotPasswordService(withParams:param) { user in
            let vc = OTPViewController.instantiate(fromAppStoryboard: .Main)
            vc.comingReason = .forgotPassword
            vc.type = 1
            vc.userId = user.id ?? 0
            self.hostVC.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
