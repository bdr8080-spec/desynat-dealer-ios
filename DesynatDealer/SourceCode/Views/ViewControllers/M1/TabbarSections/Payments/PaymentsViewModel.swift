//
//  PaymentsViewModel.swift
//  DesynatDealer
//
//  Created by fluper_mac2 on 29/04/26.
//

import Foundation

class PaymentsViewModel {
    
    private var hostVC: PaymentsViewController!
    var transactionListData: [TransactionsPayoutList] = []
    var myPayoutListData: [MyPayoutDataList] = []
    var searchWorkItem: DispatchWorkItem?
    var searchText: String = ""
    var currentPage: Int = 1
    var isLoading = false
    var hasMoreData = true
    let limit = 10
    var appliedFilter = PayoutFilterModel()
    
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
    
    func getAllTransactionList() {
        guard !isLoading else { return }
        guard hasMoreData else { return}
        isLoading = true
        let filter = appliedFilter
        var params: [String: Any] = [:]
        params["page"] = currentPage
        params["limit"] = limit
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        if let fromDate = filter.fromDate,
           !fromDate.isEmpty {
            params["from_date"] = fromDate
        }
        if let toDate = filter.toDate,
           !toDate.isEmpty {
            params["to_date"] = toDate
        }
        if let status = filter.statusId {
            params["transaction_type"] = status
        }

        WebService.sharedInstance.getAllTransactionsServices(param: params) { [weak self] data in
            guard let self = self else { return }
            let newData = data.transactions?.data ?? []
            hostVC.totalRevenuwAmountLabel.text = CommonUtils.formatPriceStringInput(data.totalRevenue)
            if self.currentPage == 1 {
                self.transactionListData = newData
            } else {
                self.transactionListData.append(contentsOf: newData)
            }
            self.hasMoreData = newData.count == self.limit
            if self.hasMoreData {
                self.currentPage += 1
            }
            self.isLoading = false
            DispatchQueue.main.async {
                self.hostVC.paymentHistoryTableview.reloadData()
                self.hostVC.noDataFoundLabel.isHidden = !self.transactionListData.isEmpty
            }
        }
    }
    
    func getAllMyPayoutList() {
        guard !isLoading else { return }
        guard hasMoreData else { return}
        isLoading = true
        let filter = appliedFilter
        var params: [String: Any] = [:]
        params["page"] = currentPage
        params["limit"] = limit
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        if let fromDate = filter.fromDate,
           !fromDate.isEmpty {
            params["from_date"] = fromDate
        }
        if let toDate = filter.toDate,
           !toDate.isEmpty {
            params["to_date"] = toDate
        }
        if let status = filter.statusId {
            params["transaction_type"] = status
        }

        WebService.sharedInstance.getAllMyPayoutsServices(param: params) { [weak self] data in
            guard let self = self else { return }
            let newData = data.payouts?.data ?? []
            hostVC.totalRevenuwAmountLabel.text = CommonUtils.formatPriceStringInput(data.totalRevenue)
            if self.currentPage == 1 {
                self.myPayoutListData = newData
            } else {
                self.myPayoutListData.append(contentsOf: newData)
            }
            self.hasMoreData = newData.count == self.limit
            if self.hasMoreData {
                self.currentPage += 1
            }
            self.isLoading = false
            DispatchQueue.main.async {
                self.hostVC.paymentHistoryTableview.reloadData()
                self.hostVC.noDataFoundLabel.isHidden = !self.myPayoutListData.isEmpty
            }
        }
    }
    
    func resetPagination() {
        currentPage = 1
        hasMoreData = true
        isLoading = false
        transactionListData.removeAll()
    }
}

struct PayoutFilterModel {
    var fromDate: String?
    var toDate: String?
    var statusId: Int?
}
