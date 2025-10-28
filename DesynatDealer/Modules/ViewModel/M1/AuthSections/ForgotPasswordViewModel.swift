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

}
