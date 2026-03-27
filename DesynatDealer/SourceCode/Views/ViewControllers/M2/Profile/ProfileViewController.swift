//
//  ProfileViewController.swift
//  DesynatDealer
//
//  Created by fluper on 10/11/25.
//

import UIKit

class ProfileViewController: UIViewController {
  
  @IBOutlet weak var userEmailLabel: UILabel!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var userProfileImageView: CustomImageView!
  @IBOutlet weak var sideMenuHeightConstaint: NSLayoutConstraint!
  @IBOutlet weak var sideMenuTableView: UITableView! {
    didSet {
      sideMenuTableView.registerCellFromNib(cellID: "SideMenuTableViewCell")
    }
  }
  
  private var sideMenuData: [SideMenuModel] = [
    SideMenuModel(title: "Inventory management ", image: "inventory"),
    SideMenuModel(title: "Affiliated Commission", image: "affiliated"),
    SideMenuModel(title: "Banner management", image: "bannerMan"),
    SideMenuModel(title: "Deals management", image: "dealsMan"),
    SideMenuModel(title: "Live Coverage request", image: "liveCoverage"),
    SideMenuModel(title: "Support", image: "support"),
    SideMenuModel(title: "Refund management", image: "refundMan"),
    
    SideMenuModel(title: "Staff management", image: "staffMan"),
    SideMenuModel(title: "Subscription Plans", image: "subscriptionPlan"),
    SideMenuModel(title: "Terms & Condition", image: "termsCond"),
    SideMenuModel(title: "Return Policy", image: "returnPolicy"),
    SideMenuModel(title: "About Us", image: "aboutUS"),
    SideMenuModel(title: "FAQ’S", image: "faqs"),
    SideMenuModel(title: "Change Language", image: "chnageLangugae"),
    SideMenuModel(title: "Cancellation Policy", image: "cancellationPolicy"),
    SideMenuModel(title: "Exchange Policy", image: "exchnage"),
    SideMenuModel(title: "Settings", image: "settings")]
  
  private lazy var viewModel = ProfileViewModel(hostVC: self)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
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
  
  private func updateTableHeight() {
    DispatchQueue.main.async {
      self.sideMenuHeightConstaint.constant = self.sideMenuTableView.contentSize.height
    }
  }
  
  
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sideMenuData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath) as! SideMenuTableViewCell
    let item = sideMenuData[indexPath.row]
    cell.configData(data: item)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedItem = sideMenuData[indexPath.row].title
    switch selectedItem {
      
    case "Staff management":
        let vc =  StaffManagementViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        self.navigationController?.pushViewController(vc, animated: true)
      print("➡️ Navigate to Staff management")
      
    case "Subscription Plans":
        let vc = MySubsciptionPlanViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        self.navigationController?.pushViewController(vc, animated: true)
      print("➡️ Navigate to Subscription Plans")
      
    case "Banner management":
        let vc = BannerManagemntVC.instantiate(fromAppStoryboard: .BannerManagement)
        self.navigationController?.pushViewController(vc, animated: true)
      
    case "Live Coverage request":
        let nextVC = LiveCoverageListViewController.instantiate(fromAppStoryboard: .Profile)
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    case "Deals management":
        let vc = DealListedViewController.instantiate(fromAppStoryboard: .OrderAndChat)
        self.navigationController?.pushViewController(vc, animated: true)
      
    case "Refund management":
        let vc = RefundManagementViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        self.navigationController?.pushViewController(vc, animated: true)
      print("➡️ Navigate to Refund management")
      
    case "Inventory management ":
      let nextVC = InventoryListViewController.instantiate(fromAppStoryboard: .InventoryAffilate)
      self.navigationController?.pushViewController(nextVC, animated: true)
    case "Affiliated Commission":
      let nextVC = AffiliatedCommisionViewController.instantiate(fromAppStoryboard: .InventoryAffilate)
      nextVC.commissionValue = viewModel.userProfile?.affilateCommission
      self.navigationController?.pushViewController(nextVC, animated: true)
      
    case "Terms & Condition":
        let vc =  CMSViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        vc.comingReason = .termsAndConditions
        self.navigationController?.pushViewController(vc, animated: true)
      //print("➡️ Navigate to Terms & Condition")
      
    case "Return Policy":
        
        let vc =  CMSViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        vc.comingReason = .returnPolicy
        self.navigationController?.pushViewController(vc, animated: true)
        
      //print("➡️ Navigate to Return Policy")
      
    case "About Us":
        let vc =  CMSViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        vc.comingReason = .aboutUs
        self.navigationController?.pushViewController(vc, animated: true)
      print("➡️ Navigate to About Us")
      
    case "FAQ’S":
      let nexVC = FAQViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        self.navigationController?.pushViewController(nexVC, animated: true)
      
    case "Change Language":
        let vc = ChangeLanguageViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        self.navigationController?.pushViewController(vc, animated: true)
      print("➡️ Navigate to Change Language")
      
    case "Cancellation Policy":
        let vc =  CMSViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        vc.comingReason = .cancellationPolicy
        self.navigationController?.pushViewController(vc, animated: true)
      print("➡️ Navigate to Cancellation Policy")
      
    case "Exchange Policy":
        let vc =  CMSViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        vc.comingReason = .exchangePolicy
        self.navigationController?.pushViewController(vc, animated: true)
      print("➡️ Navigate to Exchange Policy")
      
    case "Support":
        let vc = SupportViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        self.navigationController?.pushViewController(vc, animated: true)
      print("➡️ Navigate to Support")
      
    case "Settings":
        let vc = SettingViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        self.navigationController?.pushViewController(vc, animated: true)
      print("➡️ Navigate to Settings")
      
    default:
      print("⚠️ Unknown option selected: \(selectedItem)")
    }
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
}


