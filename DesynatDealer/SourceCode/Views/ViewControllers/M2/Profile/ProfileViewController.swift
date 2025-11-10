//
//  ProfileViewController.swift
//  DesynatDealer
//
//  Created by fluper on 10/11/25.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userProfileImageView: CustomImageView!
    @IBOutlet weak var sideMenuHeightConstaint: NSLayoutConstraint!
    @IBOutlet weak var sideMenuTableView: UITableView! {
        didSet {
            sideMenuTableView.registerCellFromNib(cellID: "SideMenuTableViewCell")
        }
    }
    private var sideMenuData: [SideMenuModel] = [
        SideMenuModel(title: "Staff management", image: "staffMan"),
        SideMenuModel(title: "Subscription Plans", image: "subscriptionPlan"),
        SideMenuModel(title: "Banner management", image: "bannerMan"),
        SideMenuModel(title: "Live Coverage request", image: "liveCoverage"),
        SideMenuModel(title: "Deals management", image: "dealsMan"),
        SideMenuModel(title: "Refund management", image: "refundMan"),
        SideMenuModel(title: "Inventory management ", image: "inventory"),
        SideMenuModel(title: "Affiliated Commission", image: "affiliated"),
        SideMenuModel(title: "Terms & Condition", image: "termsCond"),
        SideMenuModel(title: "Return Policy", image: "returnPolicy"),
        SideMenuModel(title: "About Us", image: "aboutUS"),
        SideMenuModel(title: "FAQ’S", image: "faqs"),
        SideMenuModel(title: "Change Language", image: "chnageLangugae"),
        SideMenuModel(title: "Cancellation Policy", image: "cancellationPolicy"),
        SideMenuModel(title: "Exchange Policy", image: "exchnage"),
        SideMenuModel(title: "Support", image: "support"),
        SideMenuModel(title: "Settings", image: "settings")]
    
    private lazy var viewModel = ProfileViewModel(hostVC: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            case "My Wallet":
                print("✅ Selected: My Wallet")
                
            case "Terms & Condition":
                print("✅ Selected: Terms & Condition")
                
            case "Return Policy":
                print("✅ Selected: Return Policy")
                
            case "About Us":
                print("✅ Selected: About Us")
                
            case "FAQ's":
                print("✅ Selected: FAQ's")
                
            case "Change Language":
                print("✅ Selected: Change Language")
                
            case "Change Currency":
                print("✅ Selected: Change Currency")
                
            case "Change Country":
                print("✅ Selected: Change Country")
                
            case "Cancellation Policy":
                print("✅ Selected: Cancellation Policy")
                
            case "Exchange Policy":
                print("✅ Selected: Exchange Policy")
                
            case "Support":
                print("✅ Selected: Support")
                
            case "Become An Affiliate":
                print("✅ Selected: Become An Affiliate")
                
            case "Settings":
                print("✅ Selected: Settings")
                
            default:
                print("⚠️ Unknown option selected: \(selectedItem)")
            }
            
            // Deselect the row
            tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


