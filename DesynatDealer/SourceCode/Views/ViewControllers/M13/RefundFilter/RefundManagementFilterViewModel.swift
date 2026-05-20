//
//  RefundManagementFilterViewModel.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 20/03/26.
//

import Foundation

class RefundManagementFilterViewModel{
    private var hostVC: RefundManagementFilterViewController?
    var searchText: String = ""
    var appliedFilter = OrderListFilterModel()
    var ordersListData: OrdersListDataModel?
    
    init(hostVC: RefundManagementFilterViewController? = nil) {
        self.hostVC = hostVC
    }
    
    func convertDateFormat(
        _ dateString: String,
        from inputFormat: String = "dd/MM/yyyy",
        to outputFormat: String = "yyyy-MM-dd"
    ) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = inputFormatter.date(from: dateString) else {
            return nil
        }
        return outputFormatter.string(from: date)
    }
    
}

//1 all 2 onging 3 Past Order
enum ReturnSelectedTabType: Int {
    case all = 1
    case ongoing = 2
    case past = 3
}

enum ReturnStatus: Int {
    case cancelled = 1
    case returned = 2
//    case exchange = 3
}


struct RefundManagementFilterModel {
    var refundStatus: ReturnStatus?
    var fromDate: String?
    var toDate: String?
    var countryName: String?
    
    var isEmpty: Bool {
        return refundStatus == nil && fromDate == nil && toDate == nil && countryName == nil
    }
}
