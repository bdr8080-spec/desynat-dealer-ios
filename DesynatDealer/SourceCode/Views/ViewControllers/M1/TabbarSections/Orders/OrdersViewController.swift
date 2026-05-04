//
//  OrdersViewController.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit

class OrdersViewController: UIViewController {
    
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var allLabel: UILabel!
    @IBOutlet weak var allBottomLabel: UILabel!
    @IBOutlet weak var ongoingBottomLabel: UILabel!
    @IBOutlet weak var ongoingLabel: UILabel!
    @IBOutlet weak var pastBottomLabel: UILabel!
    @IBOutlet weak var pastLabel: UILabel!
    //  @IBOutlet weak var customizedButtonOutlet: CustomButton!
    //  @IBOutlet weak var normalButtonOutlet: CustomButton!
    @IBOutlet weak var customizedLabel: UILabel!
    @IBOutlet weak var normalLabel: UILabel!
    @IBOutlet weak var ordersTableView: UITableView! {
        didSet {
            ordersTableView.registerCellFromNib(cellID: "OrdersListTableViewCell")
        }
    }
    @IBOutlet weak var backButton: RTLButton!

    private var searchWorkItem: DispatchWorkItem?
    var selectedTab: OrderSelectedTabType = .all
    private lazy var viewModel = OrdersViewModel(hostVC: self)
    var hasActionPermission: Bool = true
    var comingFromTabbar: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTF.delegate = self
        backButton.isHidden = comingFromTabbar
        viewModel.readNewOrderCountApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAllOrders()
    }
    
    //  @IBAction func normalDidTapped(_ sender: Any) {
    //    normalButtonOutlet.setImage(UIImage(named: "btnGradient"), for: .normal)
    //    normalLabel.textColor = UIColor.white
    //    customizedButtonOutlet.setImage(UIImage(named: ""), for: .normal)
    //    customizedLabel.textColor = UIColor.black
    //    orderCategoryType = .normalOrders
    //    viewModel.getAllOrders()
    //  }
    //
    //  @IBAction func customizedDidTapped(_ sender: Any) {
    //    normalButtonOutlet.setImage(UIImage(named: ""), for: .normal)
    //    normalLabel.textColor = UIColor.black
    //    customizedButtonOutlet.setImage(UIImage(named: "btnGradient"), for: .normal)
    //    customizedLabel.textColor = UIColor.white
    //    orderCategoryType = .customizedOrders
    //    viewModel.getAllOrders()
    //  }
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterDidTapped(_ sender: Any) {
        let vc = OrdersfilterViewController.instantiate(fromAppStoryboard: .OrderAndChat)
        vc.selectedFilter = viewModel.appliedFilter
        vc.onApplyFilter = { [weak self] filter in
            guard let self = self else { return }
            self.viewModel.appliedFilter = filter
            //        self.viewModel.currentPage = 1
            self.viewModel.getAllOrders()
        }
        vc.onClearFilter = { [weak self] in
            guard let self = self else { return }
            self.viewModel.appliedFilter = OrderListFilterModel()
            //        self.viewModel.currentPage = 1
            self.viewModel.getAllOrders()
        }
        self.navigationController?.present(vc, animated: false)
    }
    
    
    @IBAction func allDidTapped(_ sender: Any) {
        selectedTab = .all
        updateTabUI()
        viewModel.getAllOrders()
    }
    
    @IBAction func ongoingDidTapped(_ sender: Any) {
        selectedTab = .ongoing
        updateTabUI()
        viewModel.getAllOrders()
    }
    
    
    @IBAction func pastDidTapped(_ sender: Any) {
        selectedTab = .past
        updateTabUI()
        viewModel.getAllOrders()
    }
    
    func updateTabUI() {
        allLabel.textColor = selectedTab == .all ? .darkBrown : UIColor(named: "#B3B3B3")
        allBottomLabel.backgroundColor = selectedTab == .all ? .darkBrown : UIColor(named: "#B3B3B3")
        
        ongoingLabel.textColor = selectedTab == .ongoing ? .darkBrown : UIColor(named: "#B3B3B3")
        ongoingBottomLabel.backgroundColor = selectedTab == .ongoing ? .darkBrown : UIColor(named: "#B3B3B3")
        
        pastLabel.textColor = selectedTab == .past ? .darkBrown : UIColor(named: "#B3B3B3")
        pastBottomLabel.backgroundColor = selectedTab == .past ? .darkBrown : UIColor(named: "#B3B3B3")
    }
    
    func updateProductCounts() {
        let allCount = viewModel.ordersListData?.allOrder?.count ?? 0
        let activeCount = viewModel.ordersListData?.ongoingOrder?.count ?? 0
        let inactiveCount = viewModel.ordersListData?.pastOrder?.count ?? 0
        let text1 = "All".localiz()
        let text2 = "Ongoing".localiz()
        let text3 = "Past".localiz()
        allLabel.text = "\(text1) (\(allCount))"
        ongoingLabel.text = "\(text2) (\(activeCount))"
        pastLabel.text = "\(text3) (\(inactiveCount))"
    }
    
}

extension OrdersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedTab {
        case .all:
            return viewModel.ordersListData?.allOrder?.count ?? 0
        case .ongoing:
            return viewModel.ordersListData?.ongoingOrder?.count ?? 0
        case .past:
            return viewModel.ordersListData?.pastOrder?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersListTableViewCell", for: indexPath) as! OrdersListTableViewCell
        switch selectedTab {
        case .all:
            let data = viewModel.ordersListData?.allOrder?[indexPath.row]
            cell.configData(data: data)
        case .ongoing:
            let data = viewModel.ordersListData?.ongoingOrder?[indexPath.row]
            cell.configData(data: data)
        case .past:
            let data = viewModel.ordersListData?.pastOrder?[indexPath.row]
            cell.configData(data: data)
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = OrderDetailsViewController.instantiate(fromAppStoryboard: .OrderAndChat)
        nextVC.hasActionPermission = hasActionPermission
        switch selectedTab {
        case .all:
            nextVC.orderId = viewModel.ordersListData?.allOrder?[indexPath.row].id ?? 0
            if viewModel.ordersListData?.allOrder?[indexPath.row].orderType == "1" {
                nextVC.orderCategoryType = .normalOrders
            } else {
                nextVC.orderCategoryType = .customizedOrders
            }
        case .ongoing:
            nextVC.orderId = viewModel.ordersListData?.ongoingOrder?[indexPath.row].id ?? 0
            if viewModel.ordersListData?.ongoingOrder?[indexPath.row].orderType == "1" {
                nextVC.orderCategoryType = .normalOrders
            } else {
                nextVC.orderCategoryType = .customizedOrders
            }
        case .past:
            nextVC.orderId = viewModel.ordersListData?.pastOrder?[indexPath.row].id ?? 0
            if viewModel.ordersListData?.pastOrder?[indexPath.row].orderType == "1" {
                nextVC.orderCategoryType = .normalOrders
            } else {
                nextVC.orderCategoryType = .customizedOrders
            }
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

extension OrdersViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            viewModel.getAllOrders()
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}


