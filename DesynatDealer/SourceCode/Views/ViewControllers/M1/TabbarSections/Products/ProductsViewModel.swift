//
//  ProductsViewModel.swift
//  DesynatDealer
//
//  Created by fluper on 24/11/25.
//

import Foundation

class ProductsViewModel {
  
  private var hostVC: ProductsViewController?
  var productsListData: ProductsListDataModel?
  var searchText: String = ""

  init(hostVC: ProductsViewController) {
    self.hostVC = hostVC
  }
  
  func getAllProducts(type: String) {
      var params: [String : Any] = ["type": type] //0 all product 1 active product 2 inactive product
      // Search
      if !searchText.isEmpty {
          params["search"] = searchText
      }
//      // cargory_filter
//      if let id = appliedFilter.countryId {
//          params["cargory_filter"] = id
//      }
//
//      // brand_filter
//      if let fromDate = appliedFilter.fromDate {
//          params["brand_filter"] = fromDate
//      }


      // API CALL
      WebService.sharedInstance.getProductsListServices(param: params) { [weak self] response in
          guard let self = self else { return }
          self.productsListData = response
          DispatchQueue.main.async {
              self.hostVC?.productTableView.reloadData()
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
      WebService.sharedInstance.updateProductActiveStatus(param: param){ response in
          completion(true)
      }
  }
}
