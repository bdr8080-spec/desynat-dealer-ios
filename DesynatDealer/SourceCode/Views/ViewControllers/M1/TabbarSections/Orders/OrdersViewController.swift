//
//  OrdersViewController.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit

class OrdersViewController: UIViewController {
  
  @IBOutlet weak var searchTF: UITextField!
  @IBOutlet weak var allLabel: UILabel!
  @IBOutlet weak var allBottomLabel: UILabel!
  @IBOutlet weak var ongoingBottomLabel: UILabel!
  @IBOutlet weak var ongoingLabel: UILabel!
  @IBOutlet weak var pastBottomLabel: UILabel!
  @IBOutlet weak var pastLabel: UILabel!
  @IBOutlet weak var customizedButtonOutlet: CustomButton!
  @IBOutlet weak var normalButtonOutlet: CustomButton!
  @IBOutlet weak var customizedLabel: UILabel!
  @IBOutlet weak var normalLabel: UILabel!
  @IBOutlet weak var ordersTableView: UITableView! {
    didSet {
      ordersTableView.registerCellFromNib(cellID: "OrdersListTableViewCell")
    }
  }
  
  private var orderCategoryType: OrderCategoryType = .normalOrders
  private var searchWorkItem: DispatchWorkItem?
  private var selectedTab: OrderSelectedTabType = .all
  private lazy var viewModel = OrdersViewModel(hostVC: self)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchTF.delegate = self
  }
  
  @IBAction func normalDidTapped(_ sender: Any) {
    normalButtonOutlet.setImage(UIImage(named: "btnGradient"), for: .normal)
    normalLabel.textColor = UIColor.white
    customizedButtonOutlet.setImage(UIImage(named: ""), for: .normal)
    customizedLabel.textColor = UIColor.black
    orderCategoryType = .normalOrders
    viewModel.getAllOrders()
  }
  
  @IBAction func customizedDidTapped(_ sender: Any) {
    normalButtonOutlet.setImage(UIImage(named: ""), for: .normal)
    normalLabel.textColor = UIColor.black
    customizedButtonOutlet.setImage(UIImage(named: "btnGradient"), for: .normal)
    customizedLabel.textColor = UIColor.white
    orderCategoryType = .customizedOrders
    viewModel.getAllOrders()
  }
  
  @IBAction func filterDidTapped(_ sender: Any) {
    let vc = OrdersfilterViewController.instantiate(fromAppStoryboard: .OrderAndChat)
    vc.selectedFilter = viewModel.appliedFilter
    vc.onApplyFilter = { [weak self] filter in
        guard let self = self else { return }
        self.viewModel.appliedFilter = filter
//        self.viewModel.currentPage = 1
//        self.viewModel.getAllDeliveryBoy()
    }
    vc.onClearFilter = { [weak self] in
        guard let self = self else { return }
//        self.viewModel.appliedFilter = DriverFilterModel()
//        self.viewModel.currentPage = 1
//        self.viewModel.getAllDeliveryBoy()
    }
    self.navigationController?.present(vc, animated: false)
  }
  
  
  @IBAction func allDidTapped(_ sender: Any) {
    selectedTab = .all
    updateTabUI()
//    viewModel.getAllProducts()
  }
  
  @IBAction func ongoingDidTapped(_ sender: Any) {
    selectedTab = .ongoing
    updateTabUI()
//    viewModel.getAllProducts()
  }
  
  
  @IBAction func pastDidTapped(_ sender: Any) {
    selectedTab = .past
    updateTabUI()
//    viewModel.getAllProducts()
  }
  
  func updateTabUI() {
    allLabel.textColor = selectedTab == .all ? .darkBrown : UIColor(named: "#B3B3B3")
    allBottomLabel.backgroundColor = selectedTab == .all ? .darkBrown : UIColor(named: "#B3B3B3")
    
    ongoingLabel.textColor = selectedTab == .ongoing ? .darkBrown : UIColor(named: "#B3B3B3")
    ongoingBottomLabel.backgroundColor = selectedTab == .ongoing ? .darkBrown : UIColor(named: "#B3B3B3")
    
    pastLabel.textColor = selectedTab == .past ? .darkBrown : UIColor(named: "#B3B3B3")
    pastBottomLabel.backgroundColor = selectedTab == .past ? .darkBrown : UIColor(named: "#B3B3B3")
  }
  
}

extension OrdersViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersListTableViewCell", for: indexPath) as! OrdersListTableViewCell
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let nextVC = OrderDetailsViewController.instantiate(fromAppStoryboard: .OrderAndChat)
    self.navigationController?.pushViewController(nextVC, animated: true)
  }
  
  
}

extension OrdersViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
    searchWorkItem?.cancel()
    let workItem = DispatchWorkItem { [weak self] in
      guard let self = self else { return }
//      self.viewModel.searchText = currentText
//      viewModel.getAllProducts(type: selectedTab.rawValue)
    }
    searchWorkItem = workItem
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    return true
  }
}


