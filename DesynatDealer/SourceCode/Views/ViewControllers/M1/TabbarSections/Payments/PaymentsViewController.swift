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
        viewModel.getWalletHistory()
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
//        myPlanTableView.isHidden = true
//        noDataFoundLabel.isHidden = true
    }
    
    @IBAction func myPayoutDidTapped(_ sender: Any) {
        allTransactionButton.setImage(UIImage(named: ""), for: .normal)
        allTrasnactionLabel.textColor = UIColor.black
        myPayoutButton.setImage(UIImage(named: "btnGradient"), for: .normal)
        myPayoutLabel.textColor = UIColor.white
        selectedPayments = .myPayouts
        paymentHistoryTableview.reloadData()
//        myPlanTableView.isHidden = false
//        noDataFoundLabel.isHidden = false
//        viewModel.resetAndFetchMyPlans()
    }
    
    @IBAction func filterDidTapped(_ sender: Any) {
        let vc = PaymentFilterViewController.instantiate(fromAppStoryboard: .Home)
//        vc.selectedFilter = viewModel.appliedFilter
//        vc.onApplyFilter = { [weak self] filter in
//            guard let self = self else { return }
//            self.viewModel.appliedFilter = filter
//            self.viewModel.currentPage = 1
//            self.viewModel.hasMoreData = true
//            self.viewModel.getAllRefundManagementRequest()
//        }
//        vc.onClearFilter = { [weak self] in
//            guard let self = self else { return }
//            self.viewModel.appliedFilter = RefundManagementFilterModel()
//            self.viewModel.currentPage = 1
//            self.viewModel.hasMoreData = true
//            self.viewModel.getAllRefundManagementRequest()
//        }
        navigationController?.present(vc, animated: false)
    }
    
    @IBAction func exportTapped(_ sender: Any) {
        var csv = "Name,Email,Phone,Country,Joined On,Wallet Balance,Status\n"
//                for user in viewModel.usersListData {
//                    let name = user.fullName ?? ""
//                    let email = user.email ?? ""
//                    let phone = "\(user.countryCode ?? "")-\(user.mobile ?? "")"
//                    let country = user.countryInfo?.name ?? ""
//                    let joined = user.createdAt ?? ""
//                    let wallet = user.walletInfo?.amount ?? "0"
//                    let status = user.status == "1" ? "Active" : "Blocked"
//                    let row = "\(name),\(email),\(phone),\(country),\(joined),\(wallet),\(status)\n"
//                    csv.append(row)
//                }
                CSVExporter.exportCSV(fileName: "User Management", csvString: csv, vc: self)
         
    }
    
    @IBAction func refreshDidTapped(_ sender: Any) {
        viewModel.getWalletHistory()
    }
}

// MARK: - TABLE VIEW METHODS
extension PaymentsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5//viewModel.paymentListData?.orders?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch selectedPayments {
        case .allTrasanctions:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentsHistoryTableViewCell", for: indexPath) as! PaymentsHistoryTableViewCell
//            let data = viewModel.paymentListData?.orders?.data?[indexPath.row]
            cell.configData()
            return cell
        case .myPayouts:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyPayoutsTableViewCell", for: indexPath) as! MyPayoutsTableViewCell
//            let data = viewModel.paymentListData?.orders?.data?[indexPath.row]
//            cell.configData(data: data)
            cell.configData()
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
            viewModel.getWalletHistory()
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
