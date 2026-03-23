//
//  MySubscriptionPlanViewModel.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 19/03/26.
//

import Foundation
class MySubscriptionPlanViewModel {
    private var hostVc :  MySubsciptionPlanViewController?
    var transactionId: String?
    var payAmt: Int?
    var durationOfPlan: String?
    var plansList: [GetPlansSubscriptionModel]? = []
    var myPurchasedPlansList: [MySubscriptionPlanList] = []
    private var currentPage = 1
    private var lastPage = 1
    private var isFetching = false
    private var hasMorePages = true
    
    init(hostVc: MySubsciptionPlanViewController) {
        self.hostVc = hostVc
    }
    
    func getPlans(){
        WebService.sharedInstance.getPlansListService { list in
            self.plansList = list
            self.hostVc?.subsciptionPlanCollectionView.reloadData()
        }
    }
    
    func purchasePlan(planID: Int) {
        let params: [String: Any] = ["plan_id": planID]
        WebService.sharedInstance.purchasePlansListService(param: params) { result in
            let vc = PaymentMethodVC.instantiate(fromAppStoryboard: .Main)
            vc.paymentFrom = .mySubscriptionPlan
            vc.transactionIds = result.transactionID ?? ""
            vc.payAmount = self.payAmt ?? 0
            vc.durationOfPlan = self.durationOfPlan
            self.hostVc?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getMyPlansListRequest(reset: Bool = false) {
        
        guard !isFetching, hasMorePages else { return }
        
        isFetching = true
        
        if reset {
            currentPage = 1
            lastPage = 1
            hasMorePages = true
            myPurchasedPlansList.removeAll()
            self.hostVc?.noDataFoundLabel.isHidden = false
        }
        
        let params: [String: Any] = [
            "page": currentPage,
            "limit": 10]
        WebService.sharedInstance.getMyPlansListService(param: params) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isFetching = false
                guard let data = response.data else { return }
                // Append only once
                self.myPurchasedPlansList.append(contentsOf: data)
                self.lastPage = response.lastPage ?? 1
                // Decide if more pages exist
                if self.currentPage >= self.lastPage {
                    self.hasMorePages = false
                } else {
                    self.currentPage += 1
                }
                self.hostVc?.myPlanTableView.reloadData()
                self.hostVc?.noDataFoundLabel.isHidden = !self.myPurchasedPlansList.isEmpty
            }
        }
    }
    
    func resetAndFetchStories() {
        currentPage = 1
        lastPage = 1
        isFetching = false
        hasMorePages = true
        myPurchasedPlansList.removeAll()
        getMyPlansListRequest()
    }
    
}
