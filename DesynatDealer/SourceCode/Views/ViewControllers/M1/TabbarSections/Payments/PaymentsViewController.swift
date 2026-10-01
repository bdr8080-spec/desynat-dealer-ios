//
//  PaymentsViewController.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit

class PaymentsViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var allTransactionButton: CustomButton!
    @IBOutlet weak var allTrasnactionLabel: UILabel!
    @IBOutlet weak var myPayoutButton: CustomButton!
    @IBOutlet weak var myPayoutLabel: UILabel!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var totalRevenuwAmountLabel: CustomLabelFont!
    @IBOutlet weak var paymentHistoryTableview: UITableView! {
        didSet {
            paymentHistoryTableview.registerCellFromNib(cellID: "PaymentsHistoryTableViewCell")
            paymentHistoryTableview.registerCellFromNib(cellID: "MyPayoutsTableViewCell")
        }
    }
    @IBOutlet weak var backButton: RTLButton!
    
    // MARK: - Property Decalaration
    private lazy var viewModel = PaymentsViewModel(hostVC: self)
    var selectedPayments: SelectedTab = .allTrasanctions
    var hasActionPermission: Bool = true
    var comingFromTabbar: Bool = true
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTF.delegate = self
        viewModel.getAllTransactionList()
        backButton.isHidden = comingFromTabbar
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Button's Action
    @IBAction func allTransactionButtonDidTapped(_ sender: Any) {
        myPayoutButton.setImage(UIImage(named: ""), for: .normal)
        myPayoutLabel.textColor = UIColor.black
        allTransactionButton.setImage(UIImage(named: "btnGradient"), for: .normal)
        allTrasnactionLabel.textColor = UIColor.white
        selectedPayments = .allTrasanctions
        paymentHistoryTableview.reloadData()
        noDataFoundLabel.isHidden = true
        viewModel.getAllTransactionList()
    }
    
    @IBAction func myPayoutDidTapped(_ sender: Any) {
        allTransactionButton.setImage(UIImage(named: ""), for: .normal)
        allTrasnactionLabel.textColor = UIColor.black
        myPayoutButton.setImage(UIImage(named: "btnGradient"), for: .normal)
        myPayoutLabel.textColor = UIColor.white
        selectedPayments = .myPayouts
        paymentHistoryTableview.reloadData()
        noDataFoundLabel.isHidden = false
        viewModel.getAllMyPayoutList()
    }
    
    @IBAction func filterDidTapped(_ sender: Any) {
        let vc = PaymentFilterViewController.instantiate(fromAppStoryboard: .Home)
        vc.selectedFilter = viewModel.appliedFilter
        vc.onApplyFilter = { [weak self] filter in
            guard let self = self else { return }
            self.viewModel.appliedFilter = filter
            self.viewModel.currentPage = 1
            self.viewModel.hasMoreData = true
            if selectedPayments == .allTrasanctions {
                self.viewModel.getAllTransactionList()
            } else {
                self.viewModel.getAllMyPayoutList()
            }
        }
        vc.onClearFilter = { [weak self] in
            guard let self = self else { return }
            self.viewModel.appliedFilter = PayoutFilterModel()
            self.viewModel.currentPage = 1
            self.viewModel.hasMoreData = true
            if selectedPayments == .allTrasanctions {
                self.viewModel.getAllTransactionList()
            } else {
                self.viewModel.getAllMyPayoutList()
            }
        }
        navigationController?.present(vc, animated: false)
    }
    
    @IBAction func exportTapped(_ sender: Any) {
        if selectedPayments == .allTrasanctions {
            var csv = "Transaction ID, Date & Time, Order Id, Total Amount, Total Commission, Payment Mode\n"
            for data in viewModel.transactionListData {
                let transactionID = data.transactionID ?? ""
                let transactionDate = data.transactionDate ?? ""
//                let customerName = data.customerName ?? ""
                let orderID = data.orderID ?? 0
                let amount = data.amount ?? ""
                let totalCommission = data.totalCommission ?? "0"
                let transactionLabel = data.transactionLabel ?? "Card"
                let row = "\(transactionID),\(transactionDate),\(orderID),\(amount),\(totalCommission),\(transactionLabel)\n"
                csv.append(row)
            }
            CSVExporter.exportCSV(fileName: "All Transactions", csvString: csv, vc: self)
        } else {
            var csv = "Transaction ID, Date & Time, From Date, To Date, Total Commission, Amount\n"
            for data in viewModel.myPayoutListData {
                let transactionID = data.transactionID ?? ""
                let transactionDate = data.payoutDate ?? ""
                let fromDate = data.fromDate ?? ""
                let toDate = data.toDate ?? ""
                let amount = data.amount ?? "0"
                let totalCommission = data.totalCommission ?? ""
                let row = "\(transactionID),\(transactionDate),\(fromDate),\(toDate),\(amount),\(totalCommission)\n"
                csv.append(row)
            }
            CSVExporter.exportCSV(fileName: "My Payouts", csvString: csv, vc: self)
        }
    }
    
    @IBAction func refreshDidTapped(_ sender: Any) {
        if selectedPayments == .allTrasanctions {
            viewModel.getAllTransactionList()
        } else {
            viewModel.getAllMyPayoutList()
        }
    }
}

// MARK: - TABLE VIEW METHODS
extension PaymentsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedPayments == .allTrasanctions {
            return viewModel.transactionListData.count
        } else {
            return viewModel.myPayoutListData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch selectedPayments {
        case .allTrasanctions:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentsHistoryTableViewCell", for: indexPath) as! PaymentsHistoryTableViewCell
            let data = viewModel.transactionListData[indexPath.row]
            cell.configAllTransactionData(data: data)
            return cell
        case .myPayouts:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyPayoutsTableViewCell", for: indexPath) as! MyPayoutsTableViewCell
            let data = viewModel.myPayoutListData[indexPath.row]
            cell.configMyPayoutData(data: data)
            return cell
        }
        
    }
}

// MARK: - UITextField Delegate METHODS
extension PaymentsViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        viewModel.searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            if selectedPayments == .allTrasanctions {
                viewModel.getAllTransactionList()
            } else {
                viewModel.getAllMyPayoutList()
            }
        }
        viewModel.searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}

enum SelectedTab {
    case allTrasanctions
    case myPayouts
}
