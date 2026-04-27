//
//  InventoryListViewController.swift
//  DesynatDealer
//
//  Created by fluper on 05/12/25.
//

import UIKit

class InventoryListViewController: UIViewController {
    
    @IBOutlet weak var menButton: CustomButton!
    @IBOutlet weak var menLabel: UILabel!
    @IBOutlet weak var womenButton: CustomButton!
    @IBOutlet weak var womenLabel: UILabel!
    @IBOutlet weak var childrenLabel: UILabel!
    @IBOutlet weak var childrenButton: CustomButton!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var noResultFoundLabel: UILabel!
    @IBOutlet weak var allTitleLabel: UILabel!
    @IBOutlet weak var allBottomLabel: UILabel!
    @IBOutlet weak var activeTitleLabel: UILabel!
    @IBOutlet weak var activeBottomLabel: UILabel!
    @IBOutlet weak var inactiveLabel: UILabel!
    @IBOutlet weak var inactiveBottomLabel: UILabel!
    @IBOutlet weak var productTableView: UITableView! {
        didSet {
            productTableView.registerCellFromNib(cellID: "ProductManagementTableViewCell")
        }
    }
    
    var selectedTab: ProductTabType = .all
    var categoryType: CategoryFilterType = .men
    private lazy var viewModel = InventoryListViewModel(hostVC: self)
    var appliedFilter = AppliedFilter()
    private var searchWorkItem: DispatchWorkItem?
    var hasActionPermission: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getBrandListApi()
        searchTF.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAllProducts()
    }
    
    @IBAction func allDidTapped(_ sender: Any) {
        selectedTab = .all
        updateTabUI()
        viewModel.getAllProducts()
    }
    
    @IBAction func activeDidTapped(_ sender: Any) {
        selectedTab = .active
        updateTabUI()
        viewModel.getAllProducts()
    }
    
    @IBAction func InactiveDidTapped(_ sender: Any) {
        selectedTab = .inactive
        updateTabUI()
        viewModel.getAllProducts()
    }
    
    @IBAction func womenDidTapped(_ sender: Any) {
        menButton.setImage(UIImage(named: ""), for: .normal)
        menLabel.textColor = UIColor.black
        womenButton.setImage(UIImage(named: "btnGradient"), for: .normal)
        womenLabel.textColor = UIColor.white
        childrenButton.setImage(UIImage(named: ""), for: .normal)
        childrenLabel.textColor = UIColor.black
        categoryType = .women
        viewModel.getAllProducts()
    }
    
    @IBAction func menDidTapped(_ sender: Any) {
        womenButton.setImage(UIImage(named: ""), for: .normal)
        womenLabel.textColor = UIColor.black
        childrenButton.setImage(UIImage(named: ""), for: .normal)
        childrenLabel.textColor = UIColor.black
        menButton.setImage(UIImage(named: "btnGradient"), for: .normal)
        menLabel.textColor = UIColor.white
        categoryType = .men
        viewModel.getAllProducts()
    }
    
    @IBAction func childrenDidTapped(_ sender: Any) {
        childrenButton.setImage(UIImage(named: "btnGradient"), for: .normal)
        childrenLabel.textColor = UIColor.white
        menButton.setImage(UIImage(named: ""), for: .normal)
        menLabel.textColor = UIColor.black
        womenButton.setImage(UIImage(named: ""), for: .normal)
        womenLabel.textColor = UIColor.black
        categoryType = .kids
        viewModel.getAllProducts()
    }
    
    @IBAction func filterDidTapped(_ sender: Any) {
        let nextVC = InventoryFilterViewController.instantiate(fromAppStoryboard: .InventoryAffilate)
        nextVC.brandsList = viewModel.brandsList
        nextVC.selectedBrandIDs = appliedFilter.brandIDs
        nextVC.onFilterApplied = { [weak self] selectedBrand in
            guard let self = self else { return }
            self.appliedFilter.brandIDs = selectedBrand
            viewModel.getAllProducts()
        }
        self.navigationController?.present(nextVC, animated: true)
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func toggleStatus(at index: Int) {
        let product = getProductByTab(index)   // read before modifying
        let id = product.id ?? 0
        let params = ["product_id": id]
        viewModel.updateActiveStatus(param: params) { [weak self] success in
            guard let self else { return }
            if success {
                viewModel.getAllProducts()
            }
        }
    }
    
    func updateProductCounts() {
        let allCount = viewModel.productsListData?.allProductData?.count ?? 0
        let activeCount = viewModel.productsListData?.activeProduct?.count ?? 0
        let inactiveCount = viewModel.productsListData?.inactiveProduct?.count ?? 0
        
        allTitleLabel.text = "All (\(allCount))"
        activeTitleLabel.text = "Active (\(activeCount))"
        inactiveLabel.text = "Inactive (\(inactiveCount))"
    }
    
    func updateStatusLocally(at index: Int) {
        switch selectedTab {
        case .all:
            if var product = viewModel.productsListData?.allProductData?[index] {
                product.productActiveStatus = (product.productActiveStatus == 1 ? 0 : 1)
                viewModel.productsListData?.allProductData?[index] = product
            }
            
        case .active:
            if var product = viewModel.productsListData?.activeProduct?[index] {
                product.productActiveStatus = (product.productActiveStatus == 1 ? 0 : 1)
                viewModel.productsListData?.activeProduct?[index] = product
            }
            
        case .inactive:
            if var product = viewModel.productsListData?.inactiveProduct?[index] {
                product.productActiveStatus = (product.productActiveStatus == 1 ? 0 : 1)
                viewModel.productsListData?.inactiveProduct?[index] = product
            }
        }
    }
    
    func updateTabUI() {
        allTitleLabel.textColor = selectedTab == .all ? .darkBrown : UIColor(named: "#B3B3B3")
        allBottomLabel.backgroundColor = selectedTab == .all ? .darkBrown : UIColor(named: "#B3B3B3")
        
        activeTitleLabel.textColor = selectedTab == .active ? .darkBrown : UIColor(named: "#B3B3B3")
        activeBottomLabel.backgroundColor = selectedTab == .active ? .darkBrown : UIColor(named: "#B3B3B3")
        
        inactiveLabel.textColor = selectedTab == .inactive ? .darkBrown : UIColor(named: "#B3B3B3")
        inactiveBottomLabel.backgroundColor = selectedTab == .inactive ? .darkBrown : UIColor(named: "#B3B3B3")
    }
    
    func getProductByTab(_ index: Int) -> ProductsList {
        switch selectedTab {
        case .all:
            return viewModel.productsListData!.allProductData![index]
        case .active:
            return viewModel.productsListData!.activeProduct![index]
        case .inactive:
            return viewModel.productsListData!.inactiveProduct![index]
        }
    }
    
    
    
}
extension InventoryListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedTab {
        case .all:
            return viewModel.productsListData?.allProductData?.count ?? 0
        case .active:
            return viewModel.productsListData?.activeProduct?.count ?? 0
        case .inactive:
            return viewModel.productsListData?.inactiveProduct?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductManagementTableViewCell", for: indexPath) as! ProductManagementTableViewCell
        let product = getProductByTab(indexPath.row)
        cell.statusButton.isUserInteractionEnabled = hasActionPermission
        cell.configData(data: product)
        cell.onStatusToggle = { [weak self] in
            self?.toggleStatus(at: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = InventoryDetailsViewController.instantiate(fromAppStoryboard: .InventoryAffilate)
        nextVC.productId = getProductByTab(indexPath.row).id ?? 0
        nextVC.hasActionPermission = hasActionPermission
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

extension InventoryListViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            viewModel.getAllProducts()
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}


enum CategoryFilterType: String {
    case men = "1"
    case women = "2"
    case kids = "3"
}
