//
//  OrderDetailsViewModel.swift
//  DesynatDealer
//
//  Created by fluper on 09/01/26.
//

import Foundation

class OrderDetailsViewModel {
  
  private var hostVC: OrderDetailsViewController
  
  init(hostVC: OrderDetailsViewController) {
    self.hostVC = hostVC
  }
  
  func orderDetailRequest() {
    let param: [String: Any] = ["id": hostVC.orderId]
      WebService.sharedInstance.ordersDetails(param: param){ response in
        DispatchQueue.main.async {
          self.hostVC.orderDetails = response
          self.hostVC.bindData()
        }

      }
  }

  func orderStatusRequest(status: String) {
    let param: [String: Any] = ["id": hostVC.orderId,
                                "status": status]
      WebService.sharedInstance.updateOrdersStatus(param: param){ response in
        DispatchQueue.main.async {
          CommonUtils.showToast(message: "Status is updated")
          self.orderDetailRequest()
        }

      }
  }
  
  func orderStatusRequestForExchangeAndReturn(status: String) {
    let param: [String: Any] = ["id": hostVC.orderId,
                                "status": status]
      WebService.sharedInstance.updateOrdersStatusForExchnageAndReturn(param: param){ response in
        DispatchQueue.main.async {
          self.orderDetailRequest()
        }

      }
  }
  
}
