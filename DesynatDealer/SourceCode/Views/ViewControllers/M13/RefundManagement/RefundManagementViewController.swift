//
//  RefundManagementViewController.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 20/03/26.
//

import UIKit

class RefundManagementViewController: UIViewController {
    
    @IBOutlet weak var totalRevenueLabel: CustomLabelFont!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var ticketTableView: UITableView! {
        didSet {
            ticketTableView.delegate = self
            ticketTableView.dataSource = self
            ticketTableView.registerCellFromNib(cellID: "RefundManagementTableViewCell")
        }
    }
    
    private lazy var viewModel = RefundManagementViewModel(hostVC: self)
    private var searchWorkItem: DispatchWorkItem?
    var hasActionPermission: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTF.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.currentPage = 1
        viewModel.hasMoreData = true
        viewModel.getAllRefundManagementRequest()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterBtn(_ sender: Any) {
        let vc = RefundManagementFilterViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        
        vc.selectedFilter = viewModel.appliedFilter
        
        vc.onApplyFilter = { [weak self] filter in
            guard let self = self else { return }
            
            self.viewModel.appliedFilter = filter
            self.viewModel.currentPage = 1
            self.viewModel.hasMoreData = true
            self.viewModel.getAllRefundManagementRequest()
        }
        
        vc.onClearFilter = { [weak self] in
            guard let self = self else { return }
            
            self.viewModel.appliedFilter = RefundManagementFilterModel()
            self.viewModel.currentPage = 1
            self.viewModel.hasMoreData = true
            self.viewModel.getAllRefundManagementRequest()
        }
        navigationController?.present(vc, animated: false)
    }
    
    @IBAction func exportBtn(_ sender: Any) {
        var csv = "Order Date,Customer Name,Refund ID,Total Amount,Total Commission,Payment Mode,Requested On,Return Reason\n"
        for item in viewModel.refundRequestList {
            let orderDate = customizeChangeDateFormatZone(
                inputDate: item.createdAt ?? "",
                inputFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
                outputFormat: "dd/MM/yyyy 'at' hh:mm a"
            )
            let customerName = item.order?.deliveryDetails?.name ?? ""
            let refundId = "#\(item.id ?? 0)"
            let totalAmount = CommonUtils.formatPriceStringInput(item.order?.totalAmount)
            let affiliateCommission = Double(item.affiliateCommission ?? "0") ?? 0
            let adminCommission = Double(item.adminCommission ?? "0") ?? 0
            let totalCommission = CommonUtils.formatPrice(affiliateCommission + adminCommission)
            let paymentMethod = item.order?.paymentMethod ?? "1"
            let paymentMode: String
            switch paymentMethod {
            case "1":
                paymentMode = "Online"
            case "2":
                paymentMode = "Wallet"
            default:
                paymentMode = "Via COD"
            }
            let requestedOn = formatDateString(
                item.order?.updatedAt ?? "",
                returnFormat: "dd/MM/yyyy"
            )
            let reason = item.returnReason ?? item.cancelReason ?? item.cancelReason ?? ""
            let row = "\"\(orderDate)\",\"\(customerName)\",\"\(refundId)\",\"\(totalAmount)\",\"\(totalCommission)\",\"\(paymentMode)\",\"\(requestedOn)\",\"\(reason)\"\n"
            csv.append(row)
        }
        CSVExporter.exportCSV(fileName: "RefundManagement", csvString: csv, vc: self)
    }
    
    func formatDateString(_ dateString: String, returnFormat: String) -> String {
        let inputFormatter = ISO8601DateFormatter()
        inputFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = inputFormatter.date(from: dateString) else {
            return ""
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = returnFormat
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return outputFormatter.string(from: date)
    }
    
    func customizeChangeDateFormatZone(
        inputDate: String,
        inputFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'",
        outputFormat: String = "dd/MM/yyyy 'at' hh:mm a"
    ) -> String {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard let date = inputFormatter.date(from: inputDate) else {
            return ""
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        outputFormatter.timeZone = TimeZone(identifier: "Asia/Kuwait")
        
        return outputFormatter.string(from: date)
    }
}

// MARK: - TableView
extension RefundManagementViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.refundRequestList.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "RefundManagementTableViewCell",
            for: indexPath
        ) as! RefundManagementTableViewCell
        
        let data = viewModel.refundRequestList[indexPath.row]
        cell.configData(data: data)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard scrollView == ticketTableView else { return }
        guard !viewModel.isLoading else { return }
        guard viewModel.hasMoreData else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.height
        
        if offsetY > contentHeight - frameHeight - 100 {
            viewModel.currentPage += 1
            viewModel.getAllRefundManagementRequest()
        }
    }
}

// MARK: - Search
extension RefundManagementViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?
            .replacingCharacters(in: range, with: string) ?? ""
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            self.viewModel.currentPage = 1
            self.viewModel.hasMoreData = true
            self.viewModel.getAllRefundManagementRequest()
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5,execute: workItem)
        return true
    }
}
