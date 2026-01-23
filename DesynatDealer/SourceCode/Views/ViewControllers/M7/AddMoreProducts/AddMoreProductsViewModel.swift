//
//  AddMoreProductsViewModel.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 23/01/26.
//

import Foundation

class AddMoreProductsViewModel {
    
    private var hostVC: AddMoreProductsViewController
    
    init(hostVC: AddMoreProductsViewController) {
        self.hostVC = hostVC
    }
    
    func addProductsRequest() {
        var params: [String: Any] = ["deal_id": hostVC.dealID ?? 0,
                                     "product_ids": hostVC.selectedProductIDs]
        WebService.sharedInstance.getDealDetailsRequest(param: params){ response in
            DispatchQueue.main.async { [self] in
                let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
                vc.comingReason = .dealAdded
                vc.callBackDismiss = {
                    self.dealDetailsRequest()
                }
                self.hostVC.navigationController?.present(vc, animated: true)
            }
        }
    }
}
