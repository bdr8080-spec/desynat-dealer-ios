//
//  PaymentsViewModel.swift
//  DesynatDealer
//
//  Created by fluper_mac2 on 29/04/26.
//

import Foundation

class PaymentsViewModel {

    // MARK: - Properties

    private weak var hostVC: PaymentsViewController?
    var totalTransactionEarning: String?
    var totalMyPayoutEarning: String?
    let limit = 10

    // MARK: - All Transactions

    var transactionListData: [TransactionsPayoutList] = []
    private(set) var transactionPage: Int = 1
    private(set) var transactionIsLoading: Bool = false
    private(set) var transactionHasMoreData: Bool = true
    private var transactionRequestID = 0   // responses from older requests are ignored
    var transactionFilter = PayoutFilterModel()
    var transactionSearchText: String = ""

    // MARK: - My Payouts

    var myPayoutListData: [MyPayoutDataList] = []
    private(set) var payoutPage: Int = 1
    private(set) var payoutIsLoading: Bool = false
    private(set) var payoutHasMoreData: Bool = true
    private var payoutRequestID = 0
    var payoutFilter = PayoutFilterModel()
    var payoutSearchText: String = ""

    // MARK: - Search

    var searchWorkItem: DispatchWorkItem?

    // MARK: - Init

    init(hostVC: PaymentsViewController) {
        self.hostVC = hostVC
    }

    // MARK: - Helpers

    func formatDateString(_ dateString: String,
                          from inputFormat: String = "dd/MM/yyyy",
                          to outputFormat: String = "yyyy-MM-dd") -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.dateFormat = inputFormat
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        outputFormatter.dateFormat = outputFormat
        guard let date = inputFormatter.date(from: dateString) else { return nil }
        return outputFormatter.string(from: date)
    }

    /// transaction_type: 1 = online, 2 = wallet, 3 = cash on delivery
    private func buildParams(page: Int, search: String, filter: PayoutFilterModel) -> [String: Any] {
        var params: [String: Any] = ["page": page, "limit": limit]

        let trimmed = search.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty { params["search"] = trimmed }

        // Date filter only when BOTH dates are selected
        if let from = filter.fromDate, let to = filter.toDate, !from.isEmpty, !to.isEmpty {
            params["from_date"] = formatDateString(from) ?? from
            params["to_date"] = formatDateString(to) ?? to
        }

//        if let status = filter.statusId { params["transaction_type"] = status }
        if let status = filter.statusId { params["payment_mode"] = status }
        return params
    }

    // MARK: - Clear Search

    func clearSearch() {
        searchWorkItem?.cancel()
        searchWorkItem = nil
        transactionSearchText = ""
        payoutSearchText = ""
    }

    // MARK: - Reset

    func resetTransactionPagination() {
        transactionRequestID += 1
        transactionPage = 1
        transactionHasMoreData = true
        transactionIsLoading = false
        transactionListData.removeAll()
    }

    func resetPayoutPagination() {
        payoutRequestID += 1
        payoutPage = 1
        payoutHasMoreData = true
        payoutIsLoading = false
        myPayoutListData.removeAll()
    }

    // MARK: - Get All Transactions

    func getAllTransactionList(reset: Bool = false) {
        if reset {
            resetTransactionPagination()   // a new search/filter must never be blocked by an old request
            if hostVC?.selectedPayments == .allTrasanctions {
                hostVC?.paymentHistoryTableview.reloadData()
                hostVC?.noDataFoundLabel.isHidden = true
            }
        }
        guard !transactionIsLoading, transactionHasMoreData else { return }
        transactionIsLoading = true

        let requestID = transactionRequestID
        let page = transactionPage
        let params = buildParams(page: page, search: transactionSearchText, filter: transactionFilter)

        WebService.sharedInstance.getAllTransactionsServices(param: params) { [weak self] data in
            let newData = data.transactions?.data ?? []
            DispatchQueue.main.async {
                guard let self, requestID == self.transactionRequestID else { return }   // stale response
                self.transactionIsLoading = false

                self.totalTransactionEarning = CommonUtils.formatPriceStringInput(data.totalRevenue)
                self.transactionListData.append(contentsOf: newData)
                self.transactionHasMoreData = newData.count == self.limit
                if self.transactionHasMoreData { self.transactionPage = page + 1 }

                // data is always stored; the screen updates only if this tab is visible
                guard self.hostVC?.selectedPayments == .allTrasanctions else { return }
                self.hostVC?.totalRevenuwAmountLabel.text = self.totalTransactionEarning
                self.hostVC?.paymentHistoryTableview.reloadData()
                self.hostVC?.noDataFoundLabel.isHidden = !self.transactionListData.isEmpty
            }
        }
    }

    // MARK: - Get My Payouts

    func getAllMyPayoutList(reset: Bool = false) {
        if reset {
            resetPayoutPagination()
            if hostVC?.selectedPayments == .myPayouts {
                hostVC?.paymentHistoryTableview.reloadData()
                hostVC?.noDataFoundLabel.isHidden = true
            }
        }
        guard !payoutIsLoading, payoutHasMoreData else { return }
        payoutIsLoading = true

        let requestID = payoutRequestID
        let page = payoutPage
        let params = buildParams(page: page, search: payoutSearchText, filter: payoutFilter)

        WebService.sharedInstance.getAllMyPayoutsServices(param: params) { [weak self] data in
            let newData = data.payouts?.data ?? []
            DispatchQueue.main.async {
                guard let self, requestID == self.payoutRequestID else { return }   // stale response
                self.payoutIsLoading = false

                self.totalMyPayoutEarning = CommonUtils.formatPriceStringInput(data.totalEarning)
                self.myPayoutListData.append(contentsOf: newData)
                self.payoutHasMoreData = newData.count == self.limit
                if self.payoutHasMoreData { self.payoutPage = page + 1 }

                guard self.hostVC?.selectedPayments == .myPayouts else { return }
                self.hostVC?.totalRevenuwAmountLabel.text = self.totalMyPayoutEarning
                self.hostVC?.paymentHistoryTableview.reloadData()
                self.hostVC?.noDataFoundLabel.isHidden = !self.myPayoutListData.isEmpty
            }
        }
    }
}

struct PayoutFilterModel {
    var fromDate: String?
    var toDate: String?
    var statusId: Int?

    init(fromDate: String? = nil, toDate: String? = nil, statusId: Int? = nil) {
        self.fromDate = fromDate
        self.toDate = toDate
        self.statusId = statusId
    }
}
