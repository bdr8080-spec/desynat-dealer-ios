//
//  EditInventoryDetailsViewModel.swift
//  DesynatDealer
//
//  Created by fluper on 05/12/25.
//

import Foundation

class EditInventoryDetailsViewModel {
  
  private var hostVC: EditInventoryDetailsViewController?
  var productDetails: ProductsList?
  
  init(hostVC: EditInventoryDetailsViewController? = nil) {
    self.hostVC = hostVC
  }
  
  func updateActiveStatus(param: [String: Any], completion: @escaping (Bool) -> Void) {
      WebService.sharedInstance.updateProductActiveStatus(param: param){ response in
          completion(true)
      }
  }
  
  func populateData() {
    hostVC?.configData(data: productDetails)
  }
  
//  func validateFieldsWithErrors() -> String {
//    func isEmpty(_ text: String?) -> Bool {
//      return text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
//    }
//    if isEmpty(hostVC?.totalStocksTF.text) { return "Please enter total stocks" }
//    
//    if isEmpty(hostVC?.skuLimitTF.text) { return "Please enter SKU limit" }
//    return ""
//  }
  
  func validateFieldsWithErrors() -> String {
      func isEmpty(_ text: String?) -> Bool {
          return text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
      }
      
      let totalText = hostVC?.totalStocksTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
      let skuText = hostVC?.skuLimitTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
      
      if isEmpty(totalText) {
          return "Please enter total stocks".localiz()
      }
      
      if isEmpty(skuText) {
          return "Please enter SKU limit".localiz()
      }
      
      // Validate SKU Limit <= Total Stocks
      if let totalStocks = Int(totalText), let skuLimit = Int(skuText), skuLimit > totalStocks {
          let text = "SKU limit cannot be greater than total stocks".localiz()
          return "\(text) (\(totalStocks))"
      }
      
      return ""
  }

  
  func updateInventoryDetails() {
    let param: [String: Any] = ["product_id": hostVC?.productId ?? 0,
                                "variation_id": hostVC?.selectedVariant?.id ?? 0,
                                "stock_quantity": hostVC?.totalStocksTF.text ?? "",
                                "sku": hostVC?.skuLimitTF.text ?? ""]
      WebService.sharedInstance.updateInventoryDetails(param: param){ response in
        DispatchQueue.main.async {
            CommonUtils.showToast(message: "Inventory updated succesfully".localiz())
          self.hostVC?.navigationController?.popToViewController(ofClass: InventoryListViewController.self, animated: true)
        }
      }
  }
  
}
