//
//  InventoryListViewModel.swift
//  DesynatDealer
//
//  Created by fluper on 05/12/25.
//

import Foundation

class InventoryListViewModel {
  
  private var hostVC: InventoryListViewController?
  
  init(hostVC: InventoryListViewController) {
    self.hostVC = hostVC
  }
  
  var productsListData: InventoryListDataModel?
  var searchText: String = ""
//  var categoriesList: [CategoryDataModel] = []
  var brandsList: [BrandsListDataModel] = []
  
//  func getCategoriesListApi() {
//      WebService.sharedInstance.getCategoriesService { [weak self] list in
//          self?.categoriesList = list
//      }
//  }
  
  func getBrandListApi() {
      WebService.sharedInstance.getBrandService() { [weak self] list in
          self?.brandsList = list
      }
  }
  
  func getAllProducts() {
    var params: [String : Any] = ["type": hostVC?.selectedTab.rawValue ?? 1,
                                  "cargory_filter": [hostVC?.categoryType.rawValue ?? "1"]]
      // Search
    if !searchText.isEmpty {
      params["search"] = searchText
    }

    // BRAND FILTER
    if let brandIDs = hostVC?.appliedFilter.brandIDs, !brandIDs.isEmpty {
        params["brand_filter"] = brandIDs
    }

      // API CALL
      WebService.sharedInstance.getInventoryListServices(param: params) { [weak self] response in
          guard let self = self else { return }
          self.productsListData = response
          DispatchQueue.main.async {
              self.hostVC?.productTableView.reloadData()
            self.hostVC?.updateProductCounts()
            let type = self.hostVC?.selectedTab.rawValue ?? "0"
            switch type {
            case "0":
                self.hostVC?.noResultFoundLabel.isHidden = !(self.productsListData?.allProductData?.isEmpty ?? true)

            case "1":
                self.hostVC?.noResultFoundLabel.isHidden = !(self.productsListData?.activeProduct?.isEmpty ?? true)

            case "2":
                self.hostVC?.noResultFoundLabel.isHidden = !(self.productsListData?.inactiveProduct?.isEmpty ?? true)

            default:
                break
            }
          }
      }
  }
  
  func updateActiveStatus(param: [String: Any], completion: @escaping (Bool) -> Void) {
      WebService.sharedInstance.updateInventoryActiveStatus(param: param){ response in
          completion(true)
      }
  }
}
