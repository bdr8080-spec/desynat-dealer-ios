//
//  SubDealerSideMenuViewController.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 24/04/26.
//

import UIKit

class SubDealerSideMenuViewController: UIViewController {
    
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userProfileImageView: CustomImageView!
    @IBOutlet weak var sideMenuHeightConstaint: NSLayoutConstraint!
    @IBOutlet weak var sideMenuTableView: UITableView! {
        didSet {
            sideMenuTableView.registerCellFromNib(cellID: "SideMenuTableViewCell")
        }
    }
    @IBOutlet weak var backDidTapped: UIButton!
    
    private lazy var viewModel = SubDealerSideMenuViewModel(hostVC: self)
    var isNeedToHideBackButton: Bool = false
    private var filteredPermissions: [RoleAction] {
        return viewModel.userProfile?.roleAction?
            .filter {
                let id = $0.sellermenu?.first?.id ?? 0
                return ![1, 2, 6, 8].contains(id)
            } ?? []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backDidTapped.isHidden = isNeedToHideBackButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getUserProfile()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTableHeight()
    }
    
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTapLogout(_ sender: UIButton) {
        self.showConfirmationAlert(msg: "Are you sure you want to logout?"){ [weak self] in
            guard let self = self else { return }
            self.viewModel.logoutAPI()
        }
    }
    
    @IBAction func viewProfileAction(_ sender: Any) {
        let nextVC = DelearProfileViewController.instantiate(fromAppStoryboard: .Profile)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func updateTableHeight() {
        DispatchQueue.main.async {
            self.sideMenuHeightConstaint.constant = self.sideMenuTableView.contentSize.height
        }
    }
    
    private func getActionPermission(at indexPath: IndexPath) -> Bool {
        return filteredPermissions[indexPath.row].canAction == 1
    }
}

extension SubDealerSideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPermissions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath) as! SideMenuTableViewCell
        let item = filteredPermissions[indexPath.row]
        cell.configSubDealerData(data: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = filteredPermissions[indexPath.row].menuID
        let hasPermission = filteredPermissions[indexPath.row].canAction == 1
        
        switch selectedItem {
        case "12": //Staff management
            let vc =  StaffManagementViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "10": //Subscription Plans
            let vc = MySubsciptionPlanViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "5": //Banner management
            let vc = BannerManagemntVC.instantiate(fromAppStoryboard: .BannerManagement)
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "9": //Live Coverage request
            let nextVC = LiveCoverageListViewController.instantiate(fromAppStoryboard: .Profile)
            nextVC.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        case "7": //Deals management
            let vc = DealListedViewController.instantiate(fromAppStoryboard: .OrderAndChat)
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "19": //Refund management
            let vc = RefundManagementViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: true)
            print("➡️ Navigate to Refund management")
            
        case "3": //Inventory management
            let nextVC = InventoryListViewController.instantiate(fromAppStoryboard: .InventoryAffilate)
            nextVC.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(nextVC, animated: true)
        case "4": //Affiliated Commission
            let nextVC = AffiliatedCommisionViewController.instantiate(fromAppStoryboard: .InventoryAffilate)
            nextVC.commissionValue = viewModel.userProfile?.affilateCommission
            nextVC.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        case "13": //Terms & Condition
            let vc =  CMSViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
            vc.comingReason = .termsAndConditions
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "16": //Return Policy
            let vc =  CMSViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
            vc.comingReason = .returnPolicy
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "14": //About Us
            let vc =  CMSViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
            vc.comingReason = .aboutUs
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "15": //FAQ’S
            let nextVC = FAQViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
            nextVC.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        case "Change Language":
            let vc = ChangeLanguageViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "18": //Cancellation Policy
            let vc =  CMSViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
            vc.comingReason = .cancellationPolicy
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "17": //Exchange Policy
            let vc =  CMSViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
            vc.comingReason = .exchangePolicy
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "11": //Support
            let vc = SupportViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: true)
            
        case "20": //Settings
            let vc = SettingViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            print("⚠️ Unknown option selected: \(selectedItem ?? "")")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
