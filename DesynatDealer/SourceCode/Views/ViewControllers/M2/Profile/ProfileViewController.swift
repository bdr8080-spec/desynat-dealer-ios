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
  @IBOutlet weak var lblAppVersion: UILabel!
  
  private var sideMenuData: [SideMenuModel] = [
    SideMenuModel(title: "Staff management", image: "staffMan"),
    SideMenuModel(title: "Subscription Plans", image: "subscriptionPlan"),
    SideMenuModel(title: "Story management", image: "bannerMan"),
    SideMenuModel(title: "Banner management", image: "bannerMan"),
    SideMenuModel(title: "Live Coverage request", image: "liveCoverage"),
    SideMenuModel(title: "Deals management", image: "dealsMan"),
    SideMenuModel(title: "Refund management", image: "refundMan"),
    SideMenuModel(title: "Inventory management", image: "inventory"),
    SideMenuModel(title: "Affiliated Commission", image: "affiliated"),
    SideMenuModel(title: "Terms & Condition", image: "termsCond"),
    SideMenuModel(title: "Return Policy", image: "returnPolicy"),
    SideMenuModel(title: "About Us", image: "aboutUS"),
    SideMenuModel(title: "FAQ’S", image: "faqs"),
    SideMenuModel(title: "Change Language", image: "chnageLangugae"),
    SideMenuModel(title: "Cancellation Policy", image: "cancellationPolicy"),
    SideMenuModel(title: "Exchange Policy", image: "exchnage"),
    SideMenuModel(title: "Support", image: "support"),
    SideMenuModel(title: "Settings", image: "settings")
  ]
    
  
  private lazy var viewModel = ProfileViewModel(hostVC: self)
  
  override func viewDidLoad() {
    super.viewDidLoad()
      
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.getUserProfile()
      let text = "App Version".localiz()
      let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
      lblAppVersion.text = "\(text) \(appVersion ?? "")"
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
      let selectedItem = sideMenuData[indexPath.row].title.localiz()
    switch selectedItem {
      
    case "Staff management".localiz():
        let vc =  StaffManagementViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        vc.hasActionPermission = true
        self.navigationController?.pushViewController(vc, animated: true)
//      print("➡️ Navigate to Staff management")
      
    case "Subscription Plans".localiz():
        let vc = MySubsciptionPlanViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        vc.hasActionPermission = true
        self.navigationController?.pushViewController(vc, animated: true)
//      print("➡️ Navigate to Subscription Plans")
        
    case "Story management".localiz():
        let vc = StoryManagementListViewController.instantiate(fromAppStoryboard: .BannerManagement)
        vc.hasActionPermission = true
        self.navigationController?.pushViewController(vc, animated: true)
      
    case "Banner management".localiz():
        let vc = BannerManagemntVC.instantiate(fromAppStoryboard: .BannerManagement)
        vc.hasActionPermission = true
        self.navigationController?.pushViewController(vc, animated: true)
      
    case "Live Coverage request".localiz():
        let nextVC = LiveCoverageListViewController.instantiate(fromAppStoryboard: .Profile)
        nextVC.hasActionPermission = true
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    case "Deals management".localiz():
        let vc = DealListedViewController.instantiate(fromAppStoryboard: .OrderAndChat)
        vc.hasActionPermission = true
        self.navigationController?.pushViewController(vc, animated: true)
      
    case "Refund management".localiz():
        let vc = RefundManagementViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        vc.hasActionPermission = true
        self.navigationController?.pushViewController(vc, animated: true)
//      print("➡️ Navigate to Refund management")
      
    case "Inventory management".localiz():
      let nextVC = InventoryListViewController.instantiate(fromAppStoryboard: .InventoryAffilate)
        nextVC.hasActionPermission = true
      self.navigationController?.pushViewController(nextVC, animated: true)
        
    case "Affiliated Commission".localiz():
      let nextVC = AffiliatedCommisionViewController.instantiate(fromAppStoryboard: .InventoryAffilate)
        nextVC.hasActionPermission = true
      nextVC.commissionValue = viewModel.userProfile?.affilateCommission
      self.navigationController?.pushViewController(nextVC, animated: true)
      
    case "Terms & Condition".localiz():
        let vc =  CMSViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        vc.comingReason = .termsAndConditions
        vc.hasActionPermission = true
        self.navigationController?.pushViewController(vc, animated: true)
      //print("➡️ Navigate to Terms & Condition")
      
    case "Return Policy".localiz():
        
        let vc =  CMSViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        vc.comingReason = .returnPolicy
        vc.hasActionPermission = true
        self.navigationController?.pushViewController(vc, animated: true)
        
      //print("➡️ Navigate to Return Policy")
      
    case "About Us".localiz():
        let vc =  CMSViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        vc.comingReason = .aboutUs
        vc.hasActionPermission = true
        self.navigationController?.pushViewController(vc, animated: true)
//      print("➡️ Navigate to About Us")
      
    case "FAQ’S".localiz():
      let nexVC = FAQViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        nexVC.hasActionPermission = true
        self.navigationController?.pushViewController(nexVC, animated: true)
      
    case "Change Language".localiz():
        let vc = ChangeLanguageViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        vc.hasActionPermission = true
        self.navigationController?.pushViewController(vc, animated: true)
//      print("➡️ Navigate to Change Language")
      
    case "Cancellation Policy".localiz():
        let vc =  CMSViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        vc.comingReason = .cancellationPolicy
        vc.hasActionPermission = true
        self.navigationController?.pushViewController(vc, animated: true)
//      print("➡️ Navigate to Cancellation Policy")
      
    case "Exchange Policy".localiz():
        let vc =  CMSViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        vc.comingReason = .exchangePolicy
        vc.hasActionPermission = true
        self.navigationController?.pushViewController(vc, animated: true)
//      print("➡️ Navigate to Exchange Policy")
      
    case "Support".localiz():
        let vc = SupportViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        vc.hasActionPermission = true
        self.navigationController?.pushViewController(vc, animated: true)
//      print("➡️ Navigate to Support")
      
    case "Settings".localiz():
        let vc = SettingViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        vc.hasActionPermission = true
        self.navigationController?.pushViewController(vc, animated: true)
//      print("➡️ Navigate to Settings")
      
    default:
      print("⚠️ Unknown option selected: \(selectedItem)")
    }
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
