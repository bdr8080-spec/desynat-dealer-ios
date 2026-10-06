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

    var transactionFilter = PayoutFilterModel()
    var transactionSearchText: String = ""

    // MARK: - My Payouts

    var myPayoutListData: [MyPayoutDataList] = []

    private(set) var payoutPage: Int = 1
    private(set) var payoutIsLoading: Bool = false
    private(set) var payoutHasMoreData: Bool = true

    var payoutFilter = PayoutFilterModel()
    var payoutSearchText: String = ""

    // MARK: - Search

    var searchWorkItem: DispatchWorkItem?

    // MARK: - Init

    init(hostVC: PaymentsViewController) {
        self.hostVC = hostVC
    }

    // MARK: - Date Formatter

    func formatDateString(
        _ dateString: String,
        from inputFormat: String = "dd/MM/yyyy",
        to outputFormat: String = "yyyy-MM-dd"
    ) -> String? {

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat

        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }

        return nil
    }

    // MARK: - Clear Search

    func clearSearch() {

        searchWorkItem?.cancel()
        searchWorkItem = nil

        transactionSearchText = ""
        payoutSearchText = ""
    }

    // MARK: - Reset All Transactions

    func resetTransactionPagination() {

        transactionPage = 1
        transactionHasMoreData = true
        transactionIsLoading = false

        transactionListData.removeAll()
    }

    // MARK: - Reset My Payouts

    func resetPayoutPagination() {

        payoutPage = 1
        payoutHasMoreData = true
        payoutIsLoading = false

        myPayoutListData.removeAll()
    }

    // MARK: - Get All Transactions

    func getAllTransactionList(reset: Bool = false) {

        guard !transactionIsLoading else {
            return
        }

        if reset {

            transactionPage = 1
            transactionHasMoreData = true
            transactionListData.removeAll()
        }

        guard transactionHasMoreData else {
            return
        }

        transactionIsLoading = true

        let filter = transactionFilter

        var params: [String: Any] = [:]

        params["page"] = transactionPage
        params["limit"] = limit

        if !transactionSearchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {

            params["search"] = transactionSearchText.trimmingCharacters(
                in: .whitespacesAndNewlines
            )
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

        WebService.sharedInstance.getAllTransactionsServices(
            param: params
        ) { [weak self] data in

            guard let self = self else {
                return
            }

            let newData = data.transactions?.data ?? []

            DispatchQueue.main.async {

                // If user changed tab while API was loading,
                // don't update the current tab UI.
                guard self.hostVC?.selectedPayments == .allTrasanctions else {

                    self.transactionIsLoading = false
                    return
                }

                self.hostVC?.totalRevenuwAmountLabel.text =
                    CommonUtils.formatPriceStringInput(
                        data.totalRevenue
                    )
                self.totalTransactionEarning = CommonUtils.formatPriceStringInput(
                    data.totalRevenue
                )

                self.transactionListData.append(contentsOf: newData)

                self.transactionHasMoreData =
                    newData.count == self.limit

                if self.transactionHasMoreData {

                    self.transactionPage += 1
                }

                self.transactionIsLoading = false

                self.hostVC?.paymentHistoryTableview.reloadData()

                self.hostVC?.noDataFoundLabel.isHidden =
                    !self.transactionListData.isEmpty
            }
        }
    }

    // MARK: - Get My Payouts

    func getAllMyPayoutList(reset: Bool = false) {

        guard !payoutIsLoading else {
            return
        }

        if reset {

            payoutPage = 1
            payoutHasMoreData = true
            myPayoutListData.removeAll()
        }

        guard payoutHasMoreData else {
            return
        }

        payoutIsLoading = true

        let filter = payoutFilter

        var params: [String: Any] = [:]

        params["page"] = payoutPage
        params["limit"] = limit

        if !payoutSearchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {

            params["search"] = payoutSearchText.trimmingCharacters(
                in: .whitespacesAndNewlines
            )
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

        WebService.sharedInstance.getAllMyPayoutsServices(
            param: params
        ) { [weak self] data in

            guard let self = self else {
                return
            }

            let newData = data.payouts?.data ?? []

            DispatchQueue.main.async {

                // If user changed tab while API was loading,
                // don't update the current tab UI.
                guard self.hostVC?.selectedPayments == .myPayouts else {

                    self.payoutIsLoading = false
                    return
                }

                self.hostVC?.totalRevenuwAmountLabel.text =
                    CommonUtils.formatPriceStringInput(
                        data.totalEarning
                    )
                
                self.totalMyPayoutEarning = CommonUtils.formatPriceStringInput(
                    data.totalEarning
                )

                self.myPayoutListData.append(contentsOf: newData)

                self.payoutHasMoreData =
                    newData.count == self.limit

                if self.payoutHasMoreData {

                    self.payoutPage += 1
                }

                self.payoutIsLoading = false

                self.hostVC?.paymentHistoryTableview.reloadData()

                self.hostVC?.noDataFoundLabel.isHidden =
                    !self.myPayoutListData.isEmpty
            }
        }
    }
}

struct PayoutFilterModel {

    var fromDate: String?
    var toDate: String?
    var statusId: Int?

    init(
        fromDate: String? = nil,
        toDate: String? = nil,
        statusId: Int? = nil
    ) {
        self.fromDate = fromDate
        self.toDate = toDate
        self.statusId = statusId
    }
}
