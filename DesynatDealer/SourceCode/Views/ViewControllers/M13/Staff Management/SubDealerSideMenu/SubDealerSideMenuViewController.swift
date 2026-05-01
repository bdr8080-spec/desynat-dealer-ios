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
//                return ![1, 2, 6, 8].contains(id)
                return ![1].contains(id)
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
        self.showConfirmationAlert(msg: "Are you sure you want to logout?".localiz()){ [weak self] in
            guard let self = self else { return }
            self.viewModel.logoutAPI()
        }
    }
    
    @IBAction func viewProfileAction(_ sender: Any) {
        let nextVC = StaffDetailsViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        nextVC.staffID = viewModel.userProfile?.id
        nextVC.comingForSelfProfileUpdate = true
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
//        case 2: //Payment management (Done)
//            let vc =  PaymentsViewController.instantiate(fromAppStoryboard: .Home)
//            vc.hasActionPermission = hasPermission
//            vc.comingFromTabbar = false
//            self.navigationController?.pushViewController(vc, animated: true)
        case 2: //Products management (Done)
            let vc =  ProductsViewController.instantiate(fromAppStoryboard: .Home)
            vc.hasActionPermission = hasPermission
            vc.comingFromTabbar = false
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 6: // Order management
            let vc =  OrdersViewController.instantiate(fromAppStoryboard: .Home)
            vc.hasActionPermission = hasPermission
            vc.comingFromTabbar = false
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 8: // Live management
            let vc =  ShowsViewController.instantiate(fromAppStoryboard: .Home)
            vc.hasActionPermission = hasPermission
            vc.comingFromTabbar = false
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 12: //Staff management (Done)
            let vc =  StaffManagementViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 10: //Subscription Plans (Done)
            let vc = MySubsciptionPlanViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 5: //Banner management (Done)
            let vc = BannerManagemntVC.instantiate(fromAppStoryboard: .BannerManagement)
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 9: //Live Coverage request (Done)
            let nextVC = LiveCoverageListViewController.instantiate(fromAppStoryboard: .Profile)
            nextVC.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        case 7: //Deals management (Done)
            let vc = DealListedViewController.instantiate(fromAppStoryboard: .OrderAndChat)
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 19: //Refund management (Done)
            let vc = RefundManagementViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: true)
            print("➡️ Navigate to Refund management")
            
        case 3: //Inventory management (Done)
            let nextVC = InventoryListViewController.instantiate(fromAppStoryboard: .InventoryAffilate)
            nextVC.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        case 4: //Affiliated Commission (Done)
            let nextVC = AffiliatedCommisionViewController.instantiate(fromAppStoryboard: .InventoryAffilate)
            nextVC.commissionValue = viewModel.userProfile?.affilateCommission
            nextVC.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        case 13: //Terms & Condition (Done)
            let vc =  CMSViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
            vc.comingReason = .termsAndConditions
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 16: //Return Policy (Done)
            let vc =  CMSViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
            vc.comingReason = .returnPolicy
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 14: //About Us (Done)
            let vc =  CMSViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
            vc.comingReason = .aboutUs
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 15: //FAQ’S (Done)
            let nextVC = FAQViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
            nextVC.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        case 21: //"Change Language":
            let vc = ChangeLanguageViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 18: //Cancellation Policy (Done)
            let vc =  CMSViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
            vc.comingReason = .cancellationPolicy
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 17: //Exchange Policy (Done)
            let vc =  CMSViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
            vc.comingReason = .exchangePolicy
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 11: //Support (Done)
            let vc = SupportViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 20: //Settings
            let vc = SettingViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
            vc.hasActionPermission = hasPermission
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            print("⚠️ Unknown option selected: \(selectedItem ?? 0)")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
