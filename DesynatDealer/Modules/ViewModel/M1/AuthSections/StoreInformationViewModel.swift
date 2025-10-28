//
//  StoreInformationViewModel.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 28/10/25.
//

import Foundation
import UIKit

class StoreInformationViewModel: NSObject {
    private var hostVC: StoreInformationViewController
    
    init(hostVC: StoreInformationViewController) {
        self.hostVC = hostVC
    }
    
    func validFields() -> Bool {
            var errorMessage: AlertConstant = .none
            
            let storeName = String.getString(hostVC.storeNameTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
            let storeAddress = String.getString(hostVC.storeAddressTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
            let addressLine1 = String.getString(hostVC.addressLineOneTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
            let addressLine2 = String.getString(hostVC.addressLineTwoTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
            let phone = String.getString(hostVC.storePhoneNumberTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
            let email = String.getString(hostVC.storeMailIDTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
            let bio = String.getString(hostVC.bioTextView.text).trimmingCharacters(in: .whitespacesAndNewlines)
            
            // MARK: - Validations
            if storeName.isEmpty {
                errorMessage = .EnterStoreName
            } else if storeAddress.isEmpty {
                errorMessage = .EnterStoreAddress
            } else if addressLine1.isEmpty {
                errorMessage = .EnterAddressLine1
            } else if addressLine2.isEmpty {
                errorMessage = .EnterAddressLine2
            } else if phone.isEmpty {
                errorMessage = .EnterPhoneNumber
            } else if !phone.isValidPhoneNumber() {
                errorMessage = .EnterValidStoreMobileNumber
            } else if email.isEmpty {
                errorMessage = .EnterStoreEmail
            } else if !email.isValidEmail() {
                errorMessage = .EnterValidStoreEmailAddress
            } else if bio.isEmpty {
                errorMessage = .EnterBio
            } else if hostVC.selectedStoreInformationImage == nil {
                errorMessage = .UploadStoreImage
            }
            
            if errorMessage != .none {
                hostVC.showAlert(msg: errorMessage.rawValue)
            }
            
            hostVC.view.endEditing(true)
            return errorMessage == .none
        }
}
