//
//  PaymentsViewController.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit

class PaymentsViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var allTransactionButton: CustomButton!
    @IBOutlet weak var allTrasnactionLabel: UILabel!
    @IBOutlet weak var myPayoutButton: CustomButton!
    @IBOutlet weak var myPayoutLabel: UILabel!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var totalRevenuwAmountLabel: CustomLabelFont!
    @IBOutlet weak var backButton: RTLButton!

    @IBOutlet weak var paymentHistoryTableview: UITableView! {

        didSet {

            paymentHistoryTableview.registerCellFromNib(
                cellID: "PaymentsHistoryTableViewCell"
            )

            paymentHistoryTableview.registerCellFromNib(
                cellID: "MyPayoutsTableViewCell"
            )
        }
    }

    // MARK: - Properties

    private lazy var viewModel = PaymentsViewModel(
        hostVC: self
    )

    var selectedPayments: SelectedTab = .allTrasanctions

    var hasActionPermission: Bool = true

    var comingFromTabbar: Bool = true

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        searchTF.delegate = self

        backButton.isHidden = comingFromTabbar

        noDataFoundLabel.isHidden = true

        setupInitialTab()

        viewModel.getAllTransactionList(reset: true)
    }

    // MARK: - Initial Tab

    private func setupInitialTab() {

        allTransactionButton.setImage(
            UIImage(named: "btnGradient"),
            for: .normal
        )

        allTrasnactionLabel.textColor = .white

        myPayoutButton.setImage(
            UIImage(named: ""),
            for: .normal
        )

        myPayoutLabel.textColor = .black
    }

    // MARK: - Back

    @IBAction func backDidTapped(_ sender: Any) {

        navigationController?.popViewController(
            animated: true
        )
    }

    // MARK: - All Transactions

    @IBAction func allTransactionButtonDidTapped(
        _ sender: Any
    ) {

        // Cancel previous search
        viewModel.searchWorkItem?.cancel()

        selectedPayments = .allTrasanctions

        // Clear search UI
        searchTF.text = ""

        // Clear only transaction search
        viewModel.transactionSearchText = ""

        totalRevenuwAmountLabel.text = viewModel.totalTransactionEarning

        // Button UI

        myPayoutButton.setImage(
            UIImage(named: ""),
            for: .normal
        )

        myPayoutLabel.textColor = .black

        allTransactionButton.setImage(
            UIImage(named: "btnGradient"),
            for: .normal
        )

        allTrasnactionLabel.textColor = .white

        paymentHistoryTableview.reloadData()

        // Show correct no-data state
        noDataFoundLabel.isHidden =
            !viewModel.transactionListData.isEmpty

        // Load only if needed
        if viewModel.transactionListData.isEmpty {

            viewModel.getAllTransactionList(
                reset: true
            )
        }
    }

    // MARK: - My Payouts

    @IBAction func myPayoutDidTapped(
        _ sender: Any
    ) {

        // Cancel previous search
        viewModel.searchWorkItem?.cancel()

        selectedPayments = .myPayouts

        // Clear search UI
        searchTF.text = ""

        // Clear only payout search
        viewModel.payoutSearchText = ""

        totalRevenuwAmountLabel.text = viewModel.totalMyPayoutEarning

        // Button UI

        allTransactionButton.setImage(
            UIImage(named: ""),
            for: .normal
        )

        allTrasnactionLabel.textColor = .black

        myPayoutButton.setImage(
            UIImage(named: "btnGradient"),
            for: .normal
        )

        myPayoutLabel.textColor = .white

        paymentHistoryTableview.reloadData()

        // Show correct no-data state
        noDataFoundLabel.isHidden =
            !viewModel.myPayoutListData.isEmpty

        // Load only if needed
        if viewModel.myPayoutListData.isEmpty {

            viewModel.getAllMyPayoutList(
                reset: true
            )
        }
    }

    // MARK: - Filter

    @IBAction func filterDidTapped(
        _ sender: Any
    ) {

        let vc = PaymentFilterViewController.instantiate(
            fromAppStoryboard: .Home
        )

        // Give filter of CURRENT tab only

        if selectedPayments == .allTrasanctions {

            vc.selectedFilter =
                viewModel.transactionFilter

        } else {

            vc.selectedFilter =
                viewModel.payoutFilter
        }

        // Apply Filter

        vc.onApplyFilter = { [weak self] filter in

            guard let self = self else {
                return
            }

            if self.selectedPayments == .allTrasanctions {

                self.viewModel.transactionFilter = filter

                self.viewModel.getAllTransactionList(
                    reset: true
                )

            } else {

                self.viewModel.payoutFilter = filter

                self.viewModel.getAllMyPayoutList(
                    reset: true
                )
            }
        }

        // Clear Filter

        vc.onClearFilter = { [weak self] in

            guard let self = self else {
                return
            }

            if self.selectedPayments == .allTrasanctions {

                self.viewModel.transactionFilter =
                    PayoutFilterModel()

                self.viewModel.getAllTransactionList(
                    reset: true
                )

            } else {

                self.viewModel.payoutFilter =
                    PayoutFilterModel()

                self.viewModel.getAllMyPayoutList(
                    reset: true
                )
            }
        }

        navigationController?.present(
            vc,
            animated: false
        )
    }

    // MARK: - Export

    @IBAction func exportTapped(
        _ sender: Any
    ) {

        if selectedPayments == .allTrasanctions {

            var csv =
                "Transaction ID, Date & Time, Order Id, Total Amount, Total Commission, Payment Mode\n"

            for data in viewModel.transactionListData {

                let transactionID =
                    data.transactionID ?? ""

                let transactionDate =
                    data.transactionDate ?? ""

                let orderID =
                    data.orderID ?? 0

                let amount =
                    data.amount ?? ""

                let totalCommission =
                    data.totalCommission ?? "0"

                let transactionLabel =
                    data.transactionLabel ?? "Card"

                let row =
                    "\(transactionID),\(transactionDate),\(orderID),\(amount),\(totalCommission),\(transactionLabel)\n"

                csv.append(row)
            }

            CSVExporter.exportCSV(
                fileName: "All Transactions",
                csvString: csv,
                vc: self
            )

        } else {

            var csv =
                "Transaction ID, Date & Time, From Date, To Date, Total Commission, Amount\n"

            for data in viewModel.myPayoutListData {

                let transactionID =
                    data.transactionID ?? ""

                let transactionDate =
                    data.payoutDate ?? ""

                let fromDate =
                    data.fromDate ?? ""

                let toDate =
                    data.toDate ?? ""

                let amount =
                    data.amount ?? "0"

                let totalCommission =
                    data.totalCommission ?? ""

                let row =
                    "\(transactionID),\(transactionDate),\(fromDate),\(toDate),\(totalCommission),\(amount)\n"

                csv.append(row)
            }

            CSVExporter.exportCSV(
                fileName: "My Payouts",
                csvString: csv,
                vc: self
            )
        }
    }

    // MARK: - Refresh

    @IBAction func refreshDidTapped(
        _ sender: Any
    ) {

        // Cancel search
        viewModel.searchWorkItem?.cancel()

        searchTF.text = ""

        if selectedPayments == .allTrasanctions {

            viewModel.transactionSearchText = ""

            viewModel.getAllTransactionList(
                reset: true
            )

        } else {

            viewModel.payoutSearchText = ""

            viewModel.getAllMyPayoutList(
                reset: true
            )
        }
    }
}

extension PaymentsViewController:
    UITableViewDataSource,
    UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        if selectedPayments == .allTrasanctions {

            return viewModel.transactionListData.count

        } else {

            return viewModel.myPayoutListData.count
        }
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        switch selectedPayments {

        case .allTrasanctions:

            let cell =
                tableView.dequeueReusableCell(
                    withIdentifier: "PaymentsHistoryTableViewCell",
                    for: indexPath
                ) as! PaymentsHistoryTableViewCell

            let data =
                viewModel.transactionListData[indexPath.row]

            cell.configAllTransactionData(
                data: data
            )

            return cell

        case .myPayouts:

            let cell =
                tableView.dequeueReusableCell(
                    withIdentifier: "MyPayoutsTableViewCell",
                    for: indexPath
                ) as! MyPayoutsTableViewCell

            let data =
                viewModel.myPayoutListData[indexPath.row]

            cell.configMyPayoutData(
                data: data
            )

            return cell
        }
    }

    // MARK: - Pagination

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {

        if selectedPayments == .allTrasanctions {

            let count =
                viewModel.transactionListData.count

            guard count > 0 else {
                return
            }

            if indexPath.row == count - 1 {

                viewModel.getAllTransactionList()
            }

        } else {

            let count =
                viewModel.myPayoutListData.count

            guard count > 0 else {
                return
            }

            if indexPath.row == count - 1 {

                viewModel.getAllMyPayoutList()
            }
        }
    }
}

extension PaymentsViewController: UITextFieldDelegate {

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {

        let currentText =
            (textField.text as NSString?)?
            .replacingCharacters(
                in: range,
                with: string
            ) ?? ""

        // Cancel previous search request
        viewModel.searchWorkItem?.cancel()

        let workItem = DispatchWorkItem { [weak self] in

            guard let self = self else {
                return
            }

            if self.selectedPayments == .allTrasanctions {

                self.viewModel.transactionSearchText =
                    currentText

                self.viewModel.getAllTransactionList(
                    reset: true
                )

            } else {

                self.viewModel.payoutSearchText =
                    currentText

                self.viewModel.getAllMyPayoutList(
                    reset: true
                )
            }
        }

        viewModel.searchWorkItem = workItem

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.5,
            execute: workItem
        )

        return true
    }
}


enum SelectedTab {
    case allTrasanctions
    case myPayouts
}
