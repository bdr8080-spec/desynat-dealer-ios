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
            paymentHistoryTableview.registerCellFromNib(cellID: "PaymentsHistoryTableViewCell")
            paymentHistoryTableview.registerCellFromNib(cellID: "MyPayoutsTableViewCell")
        }
    }

    // MARK: - Properties

    private lazy var viewModel = PaymentsViewModel(hostVC: self)
    var selectedPayments: SelectedTab = .allTrasanctions
    var hasActionPermission: Bool = true
    var comingFromTabbar: Bool = true

    private var isTransactionsTab: Bool { selectedPayments == .allTrasanctions }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        searchTF.delegate = self
        searchTF.returnKeyType = .search
        searchTF.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        paymentHistoryTableview.keyboardDismissMode = .onDrag
        backButton.isHidden = comingFromTabbar
        noDataFoundLabel.isHidden = true
        updateTabUI()
        viewModel.getAllTransactionList(reset: true)
    }

    // MARK: - Tabs

    private func updateTabUI() {
        let t = isTransactionsTab
        allTransactionButton.setImage(t ? UIImage(named: "btnGradient") : nil, for: .normal)
        allTrasnactionLabel.textColor = t ? .white : .black
        myPayoutButton.setImage(t ? nil : UIImage(named: "btnGradient"), for: .normal)
        myPayoutLabel.textColor = t ? .black : .white
        totalRevenuwAmountLabel.text = t ? viewModel.totalTransactionEarning : viewModel.totalMyPayoutEarning
    }

    private func switchTab(to tab: SelectedTab) {
        viewModel.searchWorkItem?.cancel()
        selectedPayments = tab
        // each tab keeps its own search text, so the visible list always matches the field
        searchTF.text = isTransactionsTab ? viewModel.transactionSearchText : viewModel.payoutSearchText
        updateTabUI()
        paymentHistoryTableview.reloadData()
        let isEmpty = isTransactionsTab ? viewModel.transactionListData.isEmpty : viewModel.myPayoutListData.isEmpty
        noDataFoundLabel.isHidden = !isEmpty
        if isEmpty { reloadCurrentTab() }
    }

    private func reloadCurrentTab() {
        if isTransactionsTab {
            viewModel.getAllTransactionList(reset: true)
        } else {
            viewModel.getAllMyPayoutList(reset: true)
        }
    }

    // MARK: - Actions

    @IBAction func backDidTapped(_ sender: Any) {
        viewModel.searchWorkItem?.cancel()
        navigationController?.popViewController(animated: true)
    }

    @IBAction func allTransactionButtonDidTapped(_ sender: Any) {
        guard !isTransactionsTab else { return }
        switchTab(to: .allTrasanctions)
    }

    @IBAction func myPayoutDidTapped(_ sender: Any) {
        guard isTransactionsTab else { return }
        switchTab(to: .myPayouts)
    }

    // MARK: - Search

    @objc private func searchTextChanged() {
        viewModel.searchWorkItem?.cancel()
        let text = (searchTF.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let isTransactions = isTransactionsTab
        let current = isTransactions ? viewModel.transactionSearchText : viewModel.payoutSearchText
        guard text != current else { return }   // nothing changed, no API call

        let workItem = DispatchWorkItem { [weak self] in
            guard let self else { return }
            if isTransactions {
                self.viewModel.transactionSearchText = text
                self.viewModel.getAllTransactionList(reset: true)
            } else {
                self.viewModel.payoutSearchText = text
                self.viewModel.getAllMyPayoutList(reset: true)
            }
        }
        viewModel.searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    }

    // MARK: - Filter

    @IBAction func filterDidTapped(_ sender: Any) {
        let vc = PaymentFilterViewController.instantiate(fromAppStoryboard: .Home)
        // give the filter of the CURRENT tab only
        vc.selectedPayments = selectedPayments
        vc.selectedFilter = isTransactionsTab ? viewModel.transactionFilter : viewModel.payoutFilter
        vc.onApplyFilter = { [weak self] filter in self?.applyFilter(filter) }
        vc.onClearFilter = { [weak self] in self?.applyFilter(PayoutFilterModel()) }
        navigationController?.present(vc, animated: false)
    }

    private func applyFilter(_ filter: PayoutFilterModel) {
        viewModel.searchWorkItem?.cancel()
        if isTransactionsTab {
            viewModel.transactionFilter = filter
            viewModel.getAllTransactionList(reset: true)
        } else {
            viewModel.payoutFilter = filter
            viewModel.getAllMyPayoutList(reset: true)
        }
    }

    // MARK: - Export

    @IBAction func exportTapped(_ sender: Any) {
        if isTransactionsTab {
            var csv = "Transaction ID, Date & Time, Order Id, Total Amount, Total Commission, Payment Mode\n"
            for data in viewModel.transactionListData {
                csv.append("\(data.transactionID ?? ""),\(data.transactionDate ?? ""),\(data.orderID ?? 0),\(data.amount ?? ""),\(data.totalCommission ?? "0"),\(data.transactionLabel ?? "Card")\n")
            }
            CSVExporter.exportCSV(fileName: "All Transactions", csvString: csv, vc: self)
        } else {
            var csv = "Transaction ID, Date & Time, From Date, To Date, Total Commission, Amount\n"
            for data in viewModel.myPayoutListData {
                csv.append("\(data.transactionID ?? ""),\(data.payoutDate ?? ""),\(data.fromDate ?? ""),\(data.toDate ?? ""),\(data.totalCommission ?? ""),\(data.amount ?? "0")\n")
            }
            CSVExporter.exportCSV(fileName: "My Payouts", csvString: csv, vc: self)
        }
    }

    // MARK: - Refresh

    @IBAction func refreshDidTapped(_ sender: Any) {
        viewModel.searchWorkItem?.cancel()
        searchTF.text = ""
        if isTransactionsTab {
            viewModel.transactionSearchText = ""
        } else {
            viewModel.payoutSearchText = ""
        }
        reloadCurrentTab()
    }
}

// MARK: - Table

extension PaymentsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isTransactionsTab ? viewModel.transactionListData.count : viewModel.myPayoutListData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch selectedPayments {
        case .allTrasanctions:
            guard viewModel.transactionListData.indices.contains(indexPath.row),
                  let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentsHistoryTableViewCell", for: indexPath) as? PaymentsHistoryTableViewCell else {
                return UITableViewCell()
            }
            cell.configAllTransactionData(data: viewModel.transactionListData[indexPath.row])
            return cell

        case .myPayouts:
            guard viewModel.myPayoutListData.indices.contains(indexPath.row),
                  let cell = tableView.dequeueReusableCell(withIdentifier: "MyPayoutsTableViewCell", for: indexPath) as? MyPayoutsTableViewCell else {
                return UITableViewCell()
            }
            cell.configMyPayoutData(data: viewModel.myPayoutListData[indexPath.row])
            return cell
        }
    }

    // MARK: - Pagination

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = isTransactionsTab ? viewModel.transactionListData.count : viewModel.myPayoutListData.count
        guard count > 0, indexPath.row >= count - 3 else { return }
        if isTransactionsTab {
            viewModel.getAllTransactionList()
        } else {
            viewModel.getAllMyPayoutList()
        }
    }
}

// MARK: - Text field

extension PaymentsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

enum SelectedTab {
    case allTrasanctions
    case myPayouts
}
