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
    var switchOn: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func isSwitchOn(){
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
    

}

extension StaffManagementViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StaffManagementTableViewCell = tableView.dequeueReusableCell(withIdentifier: "StaffManagementTableViewCell", for: indexPath) as! StaffManagementTableViewCell
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = StaffDetailsViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
