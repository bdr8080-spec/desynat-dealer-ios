//
//  ProductsViewController.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit

class ProductsViewController: UIViewController {
  
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
  private lazy var viewModel = ProductsViewModel(hostVC: self)
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
    self.navigationController?.present(nextVC, animated: true)
  }
  
    func toggleStatus(product: ProductsList, index: Int) {
    let params: [String: Any] = [
      "product_id": product.id ?? 0
    ]
    viewModel.updateActiveStatus(param: params) { [weak self] success in
      guard let self else { return }
      if success {
          let newStatus = product.productActiveStatus == 1 ? 0 : 1
          updateStatusLocally(at: index)
          productTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
      }
    }
  }
  
    func updateStatusLocally(at index: Int) {
        switch selectedTab {
        case .all:
            viewModel.productsListData?.allProductData?[index].productActiveStatus =
                (viewModel.productsListData?.allProductData?[index].productActiveStatus == 1 ? 0 : 1)

        case .active:
            viewModel.productsListData?.activeProduct?[index].productActiveStatus =
                (viewModel.productsListData?.activeProduct?[index].productActiveStatus == 1 ? 0 : 1)

        case .inactive:
            viewModel.productsListData?.inactiveProduct?[index].productActiveStatus =
                (viewModel.productsListData?.inactiveProduct?[index].productActiveStatus == 1 ? 0 : 1)
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
      cell.onStatusToggle = { [weak self] in
          self?.toggleStatus(product: product, index: indexPath.row)
      }

    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let nextVC = ProductDetailViewController.instantiate(fromAppStoryboard: .Product)
      nextVC.productId = getProductByTab(indexPath.row).id ?? 0
    self.navigationController?.pushViewController(nextVC, animated: true)
  }
  
}

enum ProductTabType: String {
  case all = "0"
  case active = "1"
  case inactive = "2"
}
