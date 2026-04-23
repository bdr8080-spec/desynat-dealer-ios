//
//  StaffManagementViewController.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 23/03/26.
//

import UIKit

class StaffManagementViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.registerCellFromNib(cellID: "StaffManagementTableViewCell")
        }
    }
    
    private lazy var viewModel = StaffManagementViewModel(hostVC: self)
    var staffList: [StaffDetails] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.getAllStaffList { response in
            self.staffList = response
            self.tableView.reloadData()
        }
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
        var staff = viewModel.staffList[indexPath.row]
//        let newStatus = staff.isBlock == "1" ? "0" : "1"
        let params: [String: Any] = ["id": staff.id ?? 0]
        viewModel.updateActiveStatus(param: params) { [weak self] success in
            guard let self = self else { return }
            if success {
                self.viewModel.getAllStaffList { response in
                    self.staffList = response
                    self.tableView.reloadData()
                }
                if let status = staff.isBlock {
                    if status == 0 {
                        CommonUtils.showToast(message: "Staff has been unblocked Successfully")
                    } else {
                        CommonUtils.showToast(message: "Staff has been blocked Successfully")
                    }
                }
            }
        }
    }
}

extension StaffManagementViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.staffList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StaffManagementTableViewCell = tableView.dequeueReusableCell(withIdentifier: "StaffManagementTableViewCell", for: indexPath) as! StaffManagementTableViewCell
        cell.isStatusToggled = { [weak self] in
            guard let self = self else { return }
            self.toggleReasonStatus(at: indexPath)
        }
        cell.isEditTapped = { [weak self] in
            guard let self = self else { return }
            let vc = StaffDetailsViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
            vc.staffID = self.staffList[indexPath.row].id
            self.navigationController?.pushViewController(vc, animated: true)
        }
        cell.isDeleteTapped = { [weak self] in
            guard let self = self else { return }
            self.showConfirmationAlert(msg: "Are you sure you want to delete this reel?") { [weak self] in
                guard let self = self else { return }
                let params: [String: Any] = ["id": self.staffList[indexPath.row].id ?? 0]
                self.viewModel.deleteStaff(param: params) { check in
                    self.viewModel.getAllStaffList { response in
                        self.staffList = response
                        self.tableView.reloadData()
                    }
                }
            }
        }
        cell.cellSetup(self.staffList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}
