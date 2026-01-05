//
//  OrdersViewMode.swift
//  DesynatDealer
//
//  Created by fluper on 05/01/26.
//

import Foundation

class OrdersViewModel {
  
  private var hostVC: OrdersViewController?
  var searchText: String = ""
  var appliedFilter = OrderListFilterModel()
  init(hostVC: OrdersViewController? = nil) {
    self.hostVC = hostVC
  }
  
  func getAllOrders() {
//      var params: [String : Any] = ["type": type] // 0 all_orders 1 ongoing_orders 2 past_orders
//      // Search
//      if !searchText.isEmpty {
//          params["search"] = searchText
//      }
////      // cargory_filter
//    if let categoryIDs = hostVC?.appliedFilter.categoryIDs, !categoryIDs.isEmpty {
//        params["cargory_filter"] = categoryIDs
//    }
//
//    // BRAND FILTER
//    if let brandIDs = hostVC?.appliedFilter.brandIDs, !brandIDs.isEmpty {
//        params["brand_filter"] = brandIDs
//    }
//
//      // API CALL
//      WebService.sharedInstance.getProductsListServices(param: params) { [weak self] response in
//          guard let self = self else { return }
//          self.productsListData = response
//          DispatchQueue.main.async {
//              self.hostVC?.productTableView.reloadData()
//            self.hostVC?.updateProductCounts()
//            switch type {
//            case "0":
//                self.hostVC?.noResultFoundLabel.isHidden = !(self.productsListData?.allProductData?.isEmpty ?? true)
//
//            case "1":
//                self.hostVC?.noResultFoundLabel.isHidden = !(self.productsListData?.activeProduct?.isEmpty ?? true)
//
//            case "2":
//                self.hostVC?.noResultFoundLabel.isHidden = !(self.productsListData?.inactiveProduct?.isEmpty ?? true)
//
//            default:
//                break
//            }
//          }
//      }
  }
}

enum OrderCategoryType {
  case normalOrders
  case customizedOrders
}

enum OrderSelectedTabType {
  case all
  case ongoing
  case past
}
