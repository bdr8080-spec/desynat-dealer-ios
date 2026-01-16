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
  var ordersListData: OrdersListDataModel?
  
  init(hostVC: OrdersViewController? = nil) {
    self.hostVC = hostVC
  }
  
  func getAllOrders() {
    var params: [String : Any] = ["type": hostVC?.orderCategoryType.rawValue ?? 1, // 1 Normal 2 Orders
                                  "tabs": hostVC?.selectedTab.rawValue ?? 1] // 0 all_orders 1 ongoing_orders 2 past_orders
    // Search
    if !searchText.isEmpty {
      params["search"] = searchText
    }
    
//    if let status = appliedFilter.orderDeliveryStatus, !status.isEmpty {
//      params["status"] = toDate
//    }
    
    if let status = appliedFilter.orderDeliveryStatus {
      params["status"] = status.rawValue
    }
    
    if let fromDate = appliedFilter.fromDate,
       !fromDate.isEmpty,
       let formattedFromDate = convertDateFormat(fromDate) {
        params["from_date"] = formattedFromDate
    }

    if let toDate = appliedFilter.toDate,
       !toDate.isEmpty,
       let formattedToDate = convertDateFormat(toDate) {
        params["to_date"] = formattedToDate
    }
    
    // API CALL
    WebService.sharedInstance.getOrdersListServices(param: params) { [weak self] response in
      guard let self = self else { return }
      ordersListData = response
      DispatchQueue.main.async {
        self.hostVC?.ordersTableView.reloadData()
        self.hostVC?.updateProductCounts()
        let type = self.hostVC?.selectedTab.rawValue ?? 1
        switch type {
        case 1:
          self.hostVC?.noDataFoundLabel.isHidden = !(self.ordersListData?.allOrder?.isEmpty ?? true)
          
        case 2:
          self.hostVC?.noDataFoundLabel.isHidden = !(self.ordersListData?.ongoingOrder?.isEmpty ?? true)
          
        case 3:
          self.hostVC?.noDataFoundLabel.isHidden = !(self.ordersListData?.pastOrder?.isEmpty ?? true)
          
        default:
          break
        }
      }
    }
  }
  
  func convertDateFormat(
      _ dateString: String,
      from inputFormat: String = "dd/MM/yyyy",
      to outputFormat: String = "yyyy-MM-dd"
  ) -> String? {
      let inputFormatter = DateFormatter()
      inputFormatter.dateFormat = inputFormat
      inputFormatter.locale = Locale(identifier: "en_US_POSIX")

      let outputFormatter = DateFormatter()
      outputFormatter.dateFormat = outputFormat
      outputFormatter.locale = Locale(identifier: "en_US_POSIX")

      guard let date = inputFormatter.date(from: dateString) else {
          return nil
      }
      return outputFormatter.string(from: date)
  }

}

enum OrderCategoryType: Int {
  case normalOrders = 1
  case customizedOrders = 2
}
//1 all 2 onging 3 Past Order
enum OrderSelectedTabType: Int {
  case all = 1
  case ongoing = 2
  case past = 3
}

enum OrderStatus: String {
    case confirmed = "1"
    case packed    = "2"
    case shipped   = "3"
    case exchange  = "4"
}
