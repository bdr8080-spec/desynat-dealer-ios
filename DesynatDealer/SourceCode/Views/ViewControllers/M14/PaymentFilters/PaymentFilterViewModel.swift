//
//  PaymentFilterViewModel.swift
//  DesynatDealer
//
//  Created by fluper_mac2 on 29/04/26.
//

import Foundation


enum TransactionType: Int {
    case InWallet = 1
    case Online  = 2
    case COD    = 3
}


struct PaymentManagementFilterModel {
    var refundStatus: TransactionType?
    var fromDate: String?
    var toDate: String?
    var countryName: String?
    
    var isEmpty: Bool {
        return refundStatus == nil && fromDate == nil && toDate == nil && countryName == nil
    }
}
