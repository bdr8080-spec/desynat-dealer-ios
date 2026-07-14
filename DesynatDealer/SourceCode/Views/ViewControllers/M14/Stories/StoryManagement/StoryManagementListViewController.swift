//
//  StoryManagementListViewController.swift
//  DesynatDealer
//
//  Created by fluper_mac2 on 14/07/26.
//

import UIKit

import UIKit

class StoryManagementListViewController: UIViewController {

    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var storiesTableView: UITableView! {
        didSet {
            storiesTableView.registerCellFromNib(cellID: "StoryManagementTableViewCell")
        }
    }
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    
    lazy private var viewModel = StoryManagementListViewModel(hostVC: self)
    private var searchWorkItem: DispatchWorkItem?
    var bannerData: [BannerModel] = []
    var hasActionPermission: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSearch.delegate = self
        plusButton.isHidden  = !hasActionPermission
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.getAllStories()
  }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnFilter(_ sender: Any) {
        let vc = BannerFilterVC.instantiate(fromAppStoryboard: .BannerManagement)
        vc.delegate = self
        vc.appliedFilter = viewModel.appliedFilter
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func btnAddStory(_ sender: Any) {
        let vc = AddNewStoryViewController.instantiate(fromAppStoryboard: .Profile)
        vc.comingReason = .fromStoryManagement
        vc.onStoryAdded = {
            self.viewModel.getAllStories()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension StoryManagementListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bannerData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoryManagementTableViewCell", for: indexPath) as! StoryManagementTableViewCell
        let banner = bannerData[indexPath.row]
        cell.configure(with: banner, hasActionPermission: hasActionPermission)
        cell.onPayTap = {
            let vc = PaymentMethodVC.instantiate(fromAppStoryboard: .Main)
            vc.paymentFrom = .storyManagementPayment
            vc.transactionIds = banner.orderID ?? ""
            vc.payAmount = Double(banner.price ?? "") ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = StoryDetailsViewController.instantiate(fromAppStoryboard: .BannerManagement)
        vc.banners = bannerData[indexPath.row]
        vc.hasActionPermission  = hasActionPermission
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension StoryManagementListViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            viewModel.getAllStories()
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}

extension StoryManagementListViewController: BannerFilterDelegate {
    func didApplyFilter(_ filter: BannerFilterModel) {
        viewModel.appliedFilter = filter
        viewModel.getAllStories()
    }

    func didClearFilter() {
        viewModel.appliedFilter = nil
        viewModel.getAllStories()
    }
}
