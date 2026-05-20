//
//  RefundManagementViewModel.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 24/04/26.
//

import Foundation

class RefundManagementViewModel {
    
    private var hostVC: RefundManagementViewController
    var searchText: String = ""
    var currentPage: Int = 1
    var isLoading = false
    var hasMoreData = true
    let limit = 10
    var refundRequestList: [RefundManagementList] = []
    var appliedFilter = RefundManagementFilterModel()
    
    init(hostVC: RefundManagementViewController) {
        self.hostVC = hostVC
    }
    
    func getAllRefundManagementRequest() {
        
        if isLoading || !hasMoreData { return }
        isLoading = true
        
        let filter = appliedFilter
        var params: [String: Any] = [:]
        
        params["page"] = currentPage
        params["limit"] = limit
        
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        
        if let fromDate = filter.fromDate,
           !fromDate.isEmpty,
           let formatted = convertDateFormat(fromDate) {
            params["from_date"] = formatted
        }
        
        if let toDate = filter.toDate,
           !toDate.isEmpty,
           let formatted = convertDateFormat(toDate) {
            params["to_date"] = formatted
        }
        
        if let status = filter.refundStatus,
           status.rawValue > -1 {
            params["filter"] = status.rawValue
        }
        
        WebService.sharedInstance.getRefundManagementRequest(param: params) { data in
            
            let newData = data.orders?.data ?? []
            
            if self.currentPage == 1 {
                self.refundRequestList = newData
            } else {
                self.refundRequestList.append(contentsOf: newData)
            }
            
            // IMPORTANT FIX
            // if returned data count < limit means last page
            self.hasMoreData = newData.count == self.limit
            
            self.isLoading = false
            
            DispatchQueue.main.async {
                self.hostVC.ticketTableView.reloadData()
                self.hostVC.noDataFoundLabel.isHidden = !self.refundRequestList.isEmpty
                self.hostVC.totalRevenueLabel.text = CommonUtils.formatPrice(data.totalRefunds)
            }
        }
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
