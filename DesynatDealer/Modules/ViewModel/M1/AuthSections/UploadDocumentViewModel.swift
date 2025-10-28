//
//  UploadDocumentViewModel.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 28/10/25.
//

import Foundation
import UIKit

class UploadDocumentViewModel: NSObject {
    private var hostVC: UploadDocumnetViewController
    
    init(hostVC: UploadDocumnetViewController) {
        self.hostVC = hostVC
    }
    
    func validFields() -> Bool {
        var errorMessage: AlertConstant = .none
        
        let iban = String.getString(hostVC.ibanTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        let swiftCode = String.getString(hostVC.swiftTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        let bankName = String.getString(hostVC.bankNameTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        let accountHolder = String.getString(hostVC.accountHolderTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        
        // MARK: - Validate Image Uploads
        if hostVC.selectedOwnerDoc1 == nil {
            errorMessage = .UploadOwnerDoc1
        } else if hostVC.selectedOwnerDoc2 == nil {
            errorMessage = .UploadOwnerDoc2
        } else if hostVC.selectedStoreDoc1 == nil {
            errorMessage = .UploadStoreDoc1
        } else if hostVC.selectedStoreDoc2 == nil {
            errorMessage = .UploadStoreDoc2
        } else if iban.isEmpty {
            errorMessage = .EnterIBAN
        } else if swiftCode.isEmpty {
            errorMessage = .EnterSWIFT
        } else if bankName.isEmpty {
            errorMessage = .EnterBankName
        } else if accountHolder.isEmpty {
            errorMessage = .EnterAccountHolder
        } else if hostVC.selectedAccountHolderDoc == nil {
            errorMessage = .UploadAccountHolderImage
        }
        
        // MARK: - Validate Account Selection
//        if errorMessage == .none {
//            if hostVC.personalAccountImage.image == nil && hostVC.businessAccountImage.image == nil {
//                errorMessage = .SelectAccountType
//            }
//        }

        // MARK: - Show Alert if Needed
        if errorMessage != .none {
            hostVC.showAlert(msg: errorMessage.rawValue)
        }
        
        hostVC.view.endEditing(true)
        return errorMessage == .none
    }
}
