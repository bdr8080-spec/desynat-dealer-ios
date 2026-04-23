//
//  StaffDetailsViewController.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 26/03/26.
//

import UIKit
import SDWebImage

class StaffDetailsViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var countryLabel: UILabel!
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
    
//    // MARK: - Variable
//    var isActive: Bool = false
//    var isSecureTextEntry: Bool = true
//    var originalPassword: String = ""
//    var selectedRow: Int?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        originalPassword = passwordLbl.text ?? ""
//        passwordLbl.setSecureText(originalPassword)
//        eyeBtn.setImage(UIImage(named: "eyeClose"), for: .normal)
//    }
//    
//    // MARK: - Navigation
//    @IBAction func backBtnTapped(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    @IBAction func editProfileBtntapped(_ sender: Any) {
//        let vc = AddNewStaffViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
//        vc.comingReason = .editStaff
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    @IBAction func activeStatusBtnTapped(_ sender: Any) {
//        isActive.toggle()
//        let imageName: String = isActive ? "toggle_on": "toggle_off"
//        activeStatusbtn.setImage(UIImage(named: imageName), for: .normal)
//    }
//    
//    @IBAction func eyebtntapped(_ sender: Any) {
//        isSecureTextEntry.toggle()
//        if isSecureTextEntry {
//            eyeBtn.setImage(UIImage(named: "eyeClose"), for: .normal)
//            passwordLbl.setSecureText(originalPassword)
//        } else {
//            eyeBtn.setImage(UIImage(named: "eye_open"), for: .normal)
//            passwordLbl.text = originalPassword
//        }
//    }
//}
//
//extension StaffDetailsViewController: UITableViewDataSource, UITableViewDelegate{
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "AccessModuleTableViewCell") as! AccessModuleTableViewCell
//        if selectedRow == indexPath.row {
//            cell.selectedIndex = -1
//            cell.isOuterRowSelected = true
//            cell.radioimageView.image = .radioSelected
//            cell.collectionView.reloadData()
//        } else {
//            cell.selectedIndex = -1
//            cell.isOuterRowSelected = false
//            cell.radioimageView.image = .radioUnselected
//            cell.collectionView.reloadData()
//        }
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedRow = indexPath.row
//        tableView.reloadData()
//    }
//}

    // MARK: - Variable
    private lazy var viewModel = StaffDetailsViewModel(hostVC: self)
    var isActive: Bool = false
    var isSecureTextEntry: Bool = true
    var originalPassword: String = ""
    var selectedRow: Int?
    var moduleSelctedData: [ModulSelctedData] = []
    var staffID: Int? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getStaffDetails()
    }
    
    // MARK: - Navigation
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editProfileBtntapped(_ sender: Any) {
        let vc = AddNewStaffViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        vc.comingReason = .editStaff
        vc.staffDetails = viewModel.staffDetails.first
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func activeStatusBtnTapped(_ sender: Any) {
        viewModel.upadteStaffStatus(param: ["id": staffID ?? 0],0)
    }
    
    @IBAction func deleteDidTapped(_ sender: Any) {
        self.showConfirmationAlert(msg: "Are you sure you want to delete this sub admin?"){ [weak self] in
            guard let self = self else { return }
            let param:[String:Any] = ["id": staffID ?? 0]
            viewModel.deleteStaffDetails(param: param)
        }
    }
    
    @IBAction func shareCredentialDidTapped(_ sender: Any) {
        viewModel.shareStaffDetails()
//        let email = viewModel.staffDetails?.email ?? ""
//        let password = viewModel.staffDetails?.unhashedPassword ?? ""
//        let name = viewModel.staffDetails?.fullName ?? ""
//
//        let body = """
//            Hello \(name),
//
//            Your login credentials:
//
//            Email: \(email)
//            Password: \(password)
//
//            Thanks
//            """
//
//        CommonUtils.sendEmail(
//            to: [email],
//            subject: "Your Login Credentials",
//            body: body,
//            from: self
//        )
    }
    
    func configUserData() {
        guard let data = viewModel.staffDetails.first else { return }
        nameLbl.text = data.firstName
        if let imageUrlString = data.profilePic,
           let url = URL(string: imageUrlString) {
            profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            profileImageView.sd_imageIndicator?.startAnimatingIndicator()
            profileImageView.sd_setImage(with: url, placeholderImage: .userProfile)
        } else {
            profileImageView.image = .userProfile
        }
        mobileNumberLbl.text = "\(data.countryCode ?? "")-\(data.mobile ?? "")"
        emailLbl.text = data.email
//        countryLabel.text = data.countryInfo?.name
        accessModuleTableView.reloadData()
    }
}

extension StaffDetailsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.staffDetails.first?.roleAction?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccessModuleTableViewCell",for: indexPath) as! AccessModuleTableViewCell
        //        let moduleId = indexPath.row + 1
        let permissionsDetails = viewModel.staffDetails.first?.roleAction?[indexPath.row]
        cell.titleView.text = permissionsDetails?.sellermenu?.first?.title
        //        cell.moduleId = moduleId
        cell.viewSelected = (permissionsDetails?.canView == 1) ? true : false
        cell.actionSelected = (permissionsDetails?.canAction == 1) ? true : false
        cell.isRowSelected = true
        cell.radioimageView.image = .radioSelected
        cell.collectionView.isUserInteractionEnabled = false
        //        if let data = moduleSelctedData.first(where: { $0.moduleId == moduleId }) {
        //            cell.isRowSelected = true
        //            cell.viewSelected = data.viewSelcted == 1
        //            cell.actionSelected = data.actionIsSelected == 1
        //            cell.radioimageView.image = .radioSelected
        //        }
        //        cell.selectionUpdated = { [weak self] moduleId, view, action in
        //            self?.updateSelection(moduleId: moduleId,viewSelected: view,actionSelected: action)
        //        }
        cell.collectionView.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        //        let moduleId = indexPath.row + 1
        //        if let index = moduleSelctedData.firstIndex(where: { $0.moduleId == moduleId }) {
        //            moduleSelctedData.remove(at: index)
        //        } else {
        //            let obj = ModulSelctedData(moduleId: moduleId,viewSelcted: 1,actionIsSelected: 0)
        //            moduleSelctedData.append(obj)
        //        }
        //        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    //    func updateSelection(moduleId: Int, viewSelected: Bool, actionSelected: Bool) {
    //        if let index = moduleSelctedData.firstIndex(where: { $0.moduleId == moduleId }) {
    //            if viewSelected == false && actionSelected == false {
    //                moduleSelctedData.remove(at: index)
    //            } else {
    //                moduleSelctedData[index].viewSelcted = viewSelected ? 1 : 0
    //                moduleSelctedData[index].actionIsSelected = actionSelected ? 1 : 0
    //            }
    //        } else {
    //            if viewSelected || actionSelected {
    //                let obj = ModulSelctedData(moduleId: moduleId,viewSelcted: viewSelected ? 1 : 0,actionIsSelected: actionSelected ? 1 : 0)
    //                moduleSelctedData.append(obj)
    //            }
    //        }
    //        let indexPath = IndexPath(row: moduleId - 1, section: 0)
    //        accessModuleTableView.reloadRows(at: [indexPath], with: .none)
    //    }
}

//extension StaffDetailsViewController: MFMailComposeViewControllerDelegate {
//
//    func mailComposeController(
//        _ controller: MFMailComposeViewController,
//        didFinishWith result: MFMailComposeResult,
//        error: Error?
//    ) {
//        controller.dismiss(animated: true)
//    }
//}
