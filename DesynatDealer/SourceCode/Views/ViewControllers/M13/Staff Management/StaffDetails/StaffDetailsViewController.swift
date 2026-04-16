//
//  StaffDetailsViewController.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 26/03/26.
//

import UIKit

class StaffDetailsViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var eyeBtn: UIButton!
    @IBOutlet weak var isActiveLbl: UILabel!
    @IBOutlet weak var profileImageView: CustomImageView!
    @IBOutlet weak var mobileNumberLbl: UILabel!
    @IBOutlet weak var designationLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var passwordLbl: UILabel!
    @IBOutlet weak var activeStatusbtn: UIButton!
    @IBOutlet weak var accessModuleTableView: UITableView!{
        didSet{
            accessModuleTableView.registerCellFromNib(cellID:
                                                        "AccessModuleTableViewCell")
        }
    }
    
    // MARK: - Variable
    var isActive: Bool = false
    var isSecureTextEntry: Bool = true
    var originalPassword: String = ""
    var selectedRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalPassword = passwordLbl.text ?? ""
        passwordLbl.setSecureText(originalPassword)
        eyeBtn.setImage(UIImage(named: "eyeClose"), for: .normal)
    }
    
    // MARK: - Navigation
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editProfileBtntapped(_ sender: Any) {
        let vc = AddNewStaffViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        vc.comingReason = .editStaff
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func activeStatusBtnTapped(_ sender: Any) {
        isActive.toggle()
        let imageName: String = isActive ? "toggle_on": "toggle_off"
        activeStatusbtn.setImage(UIImage(named: imageName), for: .normal)
    }
    
    @IBAction func eyebtntapped(_ sender: Any) {
        isSecureTextEntry.toggle()
        if isSecureTextEntry {
            eyeBtn.setImage(UIImage(named: "eyeClose"), for: .normal)
            passwordLbl.setSecureText(originalPassword)
        } else {
            eyeBtn.setImage(UIImage(named: "eye_open"), for: .normal)
            passwordLbl.text = originalPassword
        }
    }
}

extension StaffDetailsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccessModuleTableViewCell") as! AccessModuleTableViewCell
        if selectedRow == indexPath.row {
            cell.selectedIndex = -1
            cell.isOuterRowSelected = true
            cell.radioimageView.image = .radioSelected
            cell.collectionView.reloadData()
        } else {
            cell.selectedIndex = -1
            cell.isOuterRowSelected = false
            cell.radioimageView.image = .radioUnselected
            cell.collectionView.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        tableView.reloadData()
    }
}
