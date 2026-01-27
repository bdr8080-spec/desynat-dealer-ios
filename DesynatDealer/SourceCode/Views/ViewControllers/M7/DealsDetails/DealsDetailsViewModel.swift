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
    var addedProducts: [AddedProductInDeal]?
    var dealData: DealData?
    var remainingProduct: [ProductsList]?
    
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
                addedProducts = response.addedProducts
                remainingProduct = response.remainingProduct
                dealData = response.dealData
                hostVC.configDealData()
                switch hostVC.tabType {
                case .listedDeals:
                    hostVC.noDataFound.isHidden = !(remainingProduct?.isEmpty ?? true)
                case .enrolled:
                    hostVC.noDataFound.isHidden = !(addedProducts?.isEmpty ?? true)
                case .expired:
                    hostVC.noDataFound.isHidden = !(addedProducts?.isEmpty ?? true)
                }
            }
        }
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
    
    func deleteProductsRequest(productIs: Int) {
        let params: [String: Any] = ["deal_id": hostVC.dealID ?? 0,
                                     "id": productIs]
        WebService.sharedInstance.deleteProductsInDeal(param: params){ response in
            DispatchQueue.main.async { [self] in
                CommonUtils.showToast(message: "Item remove from deals succesfully!")
                self.dealDetailsRequest()
            }
        }
    }
}
