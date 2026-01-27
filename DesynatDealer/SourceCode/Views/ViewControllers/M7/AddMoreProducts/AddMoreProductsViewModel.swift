//
//  AddMoreProductsViewModel.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 23/01/26.
//

import Foundation

class AddMoreProductsViewModel {
    
    private var hostVC: AddMoreProductsViewController
    var searchText: String = ""
    
    init(hostVC: AddMoreProductsViewController) {
        self.hostVC = hostVC
    }
    
    func addProductsRequest(ids: [Int]) {
        let params: [String: Any] = ["deal_id": hostVC.dealID ?? 0,
                                     "product_ids": ids]
        WebService.sharedInstance.addProductsInDeal(param: params){ response in
            DispatchQueue.main.async { [self] in
                let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
                vc.comingReason = .dealAdded
                vc.callBackDismiss = {
                    self.hostVC.selectedProductIDs.removeAll()
                    self.hostVC.updateAddToDealsButtonState()
                    self.dealDetailsRequest()
                }
                self.hostVC.navigationController?.present(vc, animated: true)
            }
        }
    }
    
    func dealDetailsRequest() {
        var params: [String: Any] = [:]
        params["deal_id"] = hostVC.dealID ?? 0
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        WebService.sharedInstance.getDealDetailsRequest(param: params){ response in
            DispatchQueue.main.async { [self] in
                hostVC.dealDetails = response.remainingProduct
                hostVC.productsCollectionView.reloadData()
                hostVC.noDataFoundLabel.isHidden = !(hostVC.dealDetails?.isEmpty ?? true)
            }
            
        }
    }
}
