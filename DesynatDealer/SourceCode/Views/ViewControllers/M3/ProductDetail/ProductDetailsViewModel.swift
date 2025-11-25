//
//  ProductDetailsViewModel.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 25/11/25.
//

import Foundation
import UIKit

class ProductDetailsViewModel {
  
  private var hostVC: ProductDetailViewController
  var productDetails: ProductsList?
  
  init(hostVC: ProductDetailViewController) {
    self.hostVC = hostVC
  }
  
  func updateActiveStatus(param: [String: Any], completion: @escaping (Bool) -> Void) {
      WebService.sharedInstance.updateProductActiveStatus(param: param){ response in
          completion(true)
      }
  }
  
    func getProductDetailsService() {
        let param: [String: Any] = ["product_id" :hostVC.productId]
        WebService.sharedInstance.getProductDetailsService(param: param){ [weak self] response in
      guard let self = self else { return }
          productDetails = response
            hostVC.configData(data: response)
    }
  }
    
    func deleteProductDetailsService() {
        let param: [String: Any] = ["product_id" :hostVC.productId]
        WebService.sharedInstance.deleteProductDetailsService(param: param){ [weak self] response in
      guard let self = self else { return }
            CommonUtils.showToast(message: "Product has been deleted successfully")
            DispatchQueue.main.async {
                self.hostVC.navigationController?.popViewController(animated: true)
            }
    }
  }
  
}
