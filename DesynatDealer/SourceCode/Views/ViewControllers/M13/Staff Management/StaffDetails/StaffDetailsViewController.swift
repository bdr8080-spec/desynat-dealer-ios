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
    private lazy var viewModel = StaffDetailsViewModel(hostVC: self)
    var isActive: Bool = false
    var isSecureTextEntry: Bool = true
    var originalPassword: String = ""
    var selectedRow: Int?
    var moduleSelctedData: [ModulSelctedData] = []
    var staffID: Int? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPasswordUI()
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
        vc.staffDetails = viewModel.staffDetails
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func activeStatusBtnTapped(_ sender: Any) {
        let params: [String: Any] = ["id": staffID ?? 0]
        viewModel.upadteStaffStatus(param: params) { [weak self] success in
            guard let self = self else { return }
            if success {
                let current = self.viewModel.staffDetails?.isBlock ?? 0
                self.viewModel.staffDetails?.isBlock = current == 0 ? 1 : 0
                DispatchQueue.main.async {
                    self.updateStatusUI()
                }
            }
        }
    }
    
    @IBAction func eyebtntapped(_ sender: Any) {
        isSecureTextEntry.toggle()
        updatePasswordUI()
    }
    
    func configUserData() {
        
        guard let data = viewModel.staffDetails else { return }
        
        nameLbl.text = data.firstName
        designationLbl.text = data.sellerCategory?.nameEn
        emailLbl.text = data.email
        mobileNumberLbl.text = "\(data.countryCode ?? "")-\(data.mobile ?? "")"
        
        // Image
        if let imageUrl = data.profilePic,
           let url = URL(string: imageUrl) {
            
            profileImageView.sd_imageIndicator =
            SDWebImageActivityIndicator.gray
            
            profileImageView.sd_setImage(
                with: url,
                placeholderImage: .userProfile
            )
        } else {
            profileImageView.image = .userProfile
        }
        
        // Password
        originalPassword = data.unhashedPassword ?? ""
        updatePasswordUI()
        
        // Status
        updateStatusUI()
        
        accessModuleTableView.reloadData()
    }
    
    
    private func setupPasswordUI() {
        isSecureTextEntry = true
        updatePasswordUI()
    }
    
    private func updatePasswordUI() {
        
        if isSecureTextEntry {
            eyeBtn.setImage(UIImage(named: "eyeClose"), for: .normal)
            passwordLbl.setSecureText(originalPassword)
        } else {
            eyeBtn.setImage(UIImage(named: "eye_open"), for: .normal)
            passwordLbl.text = originalPassword
        }
    }
    
    private func updateStatusUI() {
        let isBlocked = (viewModel.staffDetails?.isBlock ?? 0) == 1
        isActiveLbl.text = isBlocked ? "Inactive" : "Active"
        activeStatusbtn.setImage(isBlocked ? .toggleOff : .toggleOn, for: .normal)
    }
}

extension StaffDetailsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.staffDetails?.roleAction?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccessModuleTableViewCell",for: indexPath) as! AccessModuleTableViewCell
        //        let moduleId = indexPath.row + 1
        let permissionsDetails = viewModel.staffDetails?.roleAction?[indexPath.row]
        cell.titleView.text = permissionsDetails?.sellermenu?.first?.title
        //        cell.moduleId = moduleId
        cell.viewSelected = (permissionsDetails?.canView == 1) ? true : false
        cell.actionSelected = (permissionsDetails?.canAction == 1) ? true : false
        cell.isRowSelected = true
        cell.radioimageView.image = .radioSelected
        cell.collectionView.isUserInteractionEnabled = false
        cell.collectionView.reloadData()
        return cell
    }
}
