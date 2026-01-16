//
//  SendQuotationViewModel.swift
//  DesynatDealer
//
//  Created by fluper on 06/01/26.
//

import Foundation
import UIKit

class SendQuotationViewModel {
    
    private var hostVC: SendQuotationViewController
    var quotationData: SendQuotationDataModel?
    var chatDetailsUniqueId: String = ""
    var itemQuantity: String = "1"
    
    init(hostVC: SendQuotationViewController) {
        self.hostVC = hostVC
    }
    
    func validateQuotationFields() -> Bool {
        
        let fields: [(UITextField?, String)] = [
            (hostVC.itemPriceTF, "Item price"),
            (hostVC.taxTF, "Tax"),
            (hostVC.shippingFeesTF, "Shipping fees"),
            (hostVC.totalAmountTF, "Total amount")
        ]
        
        for (field, name) in fields {
            guard let text = field?.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                hostVC.showAlert(msg: "Please enter \(name)")
                field?.becomeFirstResponder()
                return false
            }
        }
        
        return true
    }

    
    func modifyQuotationRequest() {
        let param: [String: Any] = ["unique_id": chatDetailsUniqueId,
                                    "price": hostVC.itemPriceTF.text?.trimmed() ?? "",
                                    "quantity": itemQuantity,
                                    "shipping": hostVC.shippingFeesTF.text?.trimmed() ?? "",
                                    "tax": hostVC.taxTF.text?.trimmed() ?? "",
                                    "total_amount": hostVC.totalAmountTF.text?.trimmed() ?? ""]
        WebService.sharedInstance.sendQuotatioRequest(param: param){ response in
            DispatchQueue.main.async {
                self.quotationData = response
                self.hostVC.handleNavigationAfterSuccess()
            }
            
        }
    }
    
}

