//
//  DealsDetailsViewModel.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 22/01/26.
//

import Foundation

class DealsDetailsViewModel {
    
    private var hostVC: DealsDetailsViewController
    var searchText: String = ""
    var dealDetails: DealsDetailsDataModel?
    
    init(hostVC: DealsDetailsViewController) {
        self.hostVC = hostVC
    }
    
    func dealDetailsRequest() {
        var params: [String: Any] = [:]
        params["deal_id"] = hostVC.dealID ?? 0
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        WebService.sharedInstance.getDealDetailsRequest(param: params){ response in
            DispatchQueue.main.async { [self] in
                dealDetails = response
                hostVC.configDealData()
            }
            
        }
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
    
    func deleteProductsRequest(productIs: Int) {
        var params: [String: Any] = ["deal_id": hostVC.dealID ?? 0,
                                     "id": productIs]
        WebService.sharedInstance.getDealDetailsRequest(param: params){ response in
            DispatchQueue.main.async { [self] in
                self.dealDetailsRequest()
            }
        }
    }
}
