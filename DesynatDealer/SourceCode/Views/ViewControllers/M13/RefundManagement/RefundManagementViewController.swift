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
