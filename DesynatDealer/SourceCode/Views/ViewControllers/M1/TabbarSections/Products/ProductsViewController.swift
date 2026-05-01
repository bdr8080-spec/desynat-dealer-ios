//
//  ProductsViewController.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit

class ProductsViewController: UIViewController {
    
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
    @IBOutlet weak var backButtonOutlet: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    var selectedTab: ProductTabType = .all
    private lazy var viewModel = ProductsViewModel(hostVC: self)
    var appliedFilter = AppliedFilter()
    private var searchWorkItem: DispatchWorkItem?
    var hasActionPermission: Bool = true
    var comingFromTabbar: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getBrandListApi()
        viewModel.getCategoriesListApi()
        searchTF.delegate = self
        backButtonOutlet.isHidden = comingFromTabbar
        plusButton.isHidden = !hasActionPermission
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAllProducts(type: selectedTab.rawValue)
    }
    
    @IBAction func backdidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func allDidTapped(_ sender: Any) {
        selectedTab = .all
        updateTabUI()
        viewModel.getAllProducts(type: selectedTab.rawValue)
    }
    
    @IBAction func activeDidTapped(_ sender: Any) {
        selectedTab = .active
        updateTabUI()
        viewModel.getAllProducts(type: selectedTab.rawValue)
        
    }
    
    @IBAction func InactiveDidTapped(_ sender: Any) {
        selectedTab = .inactive
        updateTabUI()
        viewModel.getAllProducts(type: selectedTab.rawValue)
        
    }
    
    
    @IBAction func addDidTapped(_ sender: Any) {
        let nextVC = AddNewProductViewController.instantiate(fromAppStoryboard: .Product)
        nextVC.comingReason = .forAddingProduct
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func filterDidTapped(_ sender: Any) {
        let nextVC = ProductManagementFilterViewController.instantiate(fromAppStoryboard: .Product)
        nextVC.viewModel.brandsList = viewModel.brandsList
        nextVC.viewModel.categoriesList = viewModel.categoriesList
        nextVC.selectedCategoryIDs = appliedFilter.categoryIDs
        nextVC.selectedBrandIDs = appliedFilter.brandIDs
        nextVC.onFilterApplied = { [weak self] selectedCat, selectedBrand in
            guard let self = self else { return }
            self.appliedFilter.categoryIDs = selectedCat
            self.appliedFilter.brandIDs = selectedBrand
            viewModel.getAllProducts(type: selectedTab.rawValue)
        }
        self.navigationController?.present(nextVC, animated: true)
    }
    
    func toggleStatus(at index: Int) {
        let product = getProductByTab(index)   // read before modifying
        let id = product.id ?? 0
        let params = ["product_id": id]
        viewModel.updateActiveStatus(param: params) { [weak self] success in
            guard let self else { return }
            if success {
                viewModel.getAllProducts(type: selectedTab.rawValue)
            }
        }
    }
    
    func updateProductCounts() {
        let allCount = viewModel.productsListData?.allProductData?.count ?? 0
        let activeCount = viewModel.productsListData?.activeProduct?.count ?? 0
        let inactiveCount = viewModel.productsListData?.inactiveProduct?.count ?? 0
        let text1 = "All".localiz()
        let text2 = "Active".localiz()
        let text3 = "Inactive".localiz()
        allTitleLabel.text = "\(text1) (\(allCount))"
        activeTitleLabel.text = "\(text2) (\(activeCount))"
        inactiveLabel.text = "\(text3) (\(inactiveCount))"
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
extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        cell.configData(data: product)
        cell.statusButton.isUserInteractionEnabled = hasActionPermission
        cell.onStatusToggle = { [weak self] in
            self?.toggleStatus(at: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = ProductDetailViewController.instantiate(fromAppStoryboard: .Product)
        nextVC.productId = getProductByTab(indexPath.row).id ?? 0
        nextVC.hasActionPermission = hasActionPermission
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

enum ProductTabType: String {
    case all = "0"
    case active = "1"
    case inactive = "2"
}

extension ProductsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            viewModel.getAllProducts(type: selectedTab.rawValue)
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}
