//
//  StaffManagementViewController.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 23/03/26.
//

import UIKit

class StaffManagementViewController: UIViewController {
    
    @IBOutlet weak var serachTF: UITextField!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.registerCellFromNib(cellID: "StaffManagementTableViewCell")
        }
    }
    
    private lazy var viewModel = StaffManagementViewModel(hostVC: self)
    private var searchWorkItem: DispatchWorkItem?
    var hasActionPermission: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.currentPage = 1
        viewModel.hasMoreData = true
        viewModel.getAllStaffList()
        serachTF.delegate = self
    }
    
    // MARK: - Navigation
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addNewStaffBtnTapped(_ sender: Any) {
        let vc = AddNewStaffViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        vc.comingReason = .addNewStaff
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func toggleReasonStatus(at indexPath: IndexPath) {
            
            let selectedStaff = viewModel.staffList[indexPath.row]
            let params: [String: Any] = ["id": selectedStaff.id ?? 0]
            
            viewModel.updateActiveStatus(param: params) { [weak self] success in
                guard let self = self else { return }
                
                if success {
                    
                    // Update main array data source
                    let currentStatus = self.viewModel.staffList[indexPath.row].isBlock ?? 0
                    self.viewModel.staffList[indexPath.row].isBlock = currentStatus == 0 ? 1 : 0
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadRows(at: [indexPath], with: .none)
                        
                        let updatedStatus = self.viewModel.staffList[indexPath.row].isBlock ?? 0
                        
                        let msg = updatedStatus == 0
                        ? "Staff has been unblocked successfully"
                        : "Staff has been blocked successfully"
                        
                        CommonUtils.showToast(message: msg)
                    }
                }
            }
        }}

extension StaffManagementViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.staffList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StaffManagementTableViewCell = tableView.dequeueReusableCell(withIdentifier: "StaffManagementTableViewCell", for: indexPath) as! StaffManagementTableViewCell
        cell.cellSetup(viewModel.staffList[indexPath.row])
        cell.isStatusToggled = { [weak self] in
                    self?.toggleReasonStatus(at: indexPath)
                }
        cell.isEditTapped = { [weak self] in
            guard let self = self else { return }
            let vc = StaffDetailsViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
            vc.staffID = viewModel.staffList[indexPath.row].id
            self.navigationController?.pushViewController(vc, animated: true)
        }
        cell.isDeleteTapped = { [weak self] in
            guard let self = self else { return }
            self.showConfirmationAlert(msg: "Are you sure you want to delete this staff?") { [weak self] in
                guard let self = self else { return }
                let indexPath = indexPath
                let staffToDelete = self.viewModel.staffList[indexPath.row]
                let params: [String: Any] = ["id": staffToDelete.id ?? 0]
                self.viewModel.deleteStaff(param: params) { success in
                    if success {
                        self.viewModel.staffList.remove(at: indexPath.row)
                        DispatchQueue.main.async {
                            self.tableView.deleteRows(at: [indexPath], with: .automatic)
                            self.noDataFoundLabel.isHidden = !self.viewModel.staffList.isEmpty
                            CommonUtils.showToast(message: "Staff deleted successfully")
                        }
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard scrollView == tableView else { return }
        guard !viewModel.isLoading else { return }
        guard viewModel.hasMoreData else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.height
        
        if offsetY > contentHeight - frameHeight - 100 {
            viewModel.currentPage += 1
            viewModel.getAllStaffList()
        }
    }
}

// MARK: - Search
extension StaffManagementViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?
            .replacingCharacters(in: range, with: string) ?? ""
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            self.viewModel.currentPage = 1
            self.viewModel.hasMoreData = true
            self.viewModel.getAllStaffList()
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5,execute: workItem)
        return true
    }
}
