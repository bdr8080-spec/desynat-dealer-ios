//
//  InventoryDetailsViewModel.swift
//  DesynatDealer
//
//  Created by fluper on 05/12/25.
//

import Foundation

class InventoryDetailsViewModel {
  
  private var hostVC: InventoryDetailsViewController?
  var productDetails: ProductsList?
  
  init(hostVC: InventoryDetailsViewController? = nil) {
    self.hostVC = hostVC
  }
  
  func updateActiveStatus(param: [String: Any], completion: @escaping (Bool) -> Void) {
      WebService.sharedInstance.updateProductActiveStatus(param: param){ response in
          completion(true)
      }
  }
  
    func getProductDetailsService() {
      let param: [String: Any] = ["product_id" :hostVC?.productId ?? 0]
        WebService.sharedInstance.getProductDetailsService(param: param){ [weak self] response in
      guard let self = self else { return }
          productDetails = response
          hostVC?.configData(data: response)
    }
  }
  
}
