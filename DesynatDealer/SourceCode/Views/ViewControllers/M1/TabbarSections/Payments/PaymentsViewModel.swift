//
//  PaymentsViewModel.swift
//  DesynatDealer
//
//  Created by fluper_mac2 on 29/04/26.
//

import Foundation

class PaymentsViewModel {
    
    private var hostVC: PaymentsViewController!
    var paymentListData: OrderSellersPaymentDataModel?
    var searchWorkItem: DispatchWorkItem?
    var searchText: String = ""
//    var appliedFilter = WithdrawalFilterModel()
    
    init(hostVC: PaymentsViewController!) {
        self.hostVC = hostVC
    }
    
    func formatDateString(_ dateString: String,
                          from inputFormat: String = "dd/MM/yyyy",
                          to outputFormat: String = "yyyy-MM-dd") -> String? {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        
        return nil
    }
    
    func getWalletHistory() {
        var param: [String:Any]  = [:] //0-pending/upcoming,1-approved/credited
        if !searchText.isEmpty { param["search"] = searchText }
//        if let fromDate = appliedFilter.fromDate,
//           let formattedFromDate = formatDateString(fromDate) {
//            param["start_date"] = formattedFromDate
//        }
//
//        if let toDate = appliedFilter.toDate,
//           let formattedToDate = formatDateString(toDate) {
//            param["end_date"] = formattedToDate
//        }
//        
//        if let status = appliedFilter.status {
//          param["filter"] = status.rawValue
//        }
        
//        WebService.sharedInstance.getAffilatePaymentHistoryService(withParams: param) { data in
//            DispatchQueue.main.async {
//                self.paymentListData = data
//                self.hostVC.totalRevenuwAmountLabel.text = CommonUtils.formatPrice(data.totalEarning)
//                self.hostVC.paymentHistoryTableview.reloadData()
//                self.hostVC.noDataFoundLabel.isHidden = !(self.paymentListData?.orders?.data?.isEmpty ?? true)
//            }
//        }
    }
}
