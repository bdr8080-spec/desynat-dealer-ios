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
    
    init(hostVc: MySubsciptionPlanViewController) {
        self.hostVc = hostVc
    }
    
    func getMyPlanListApi(){
        WebService.sharedInstance.getMyPlansListService() { (response) in
            
        }
    }
    
    func buySubscriptionPlanApi(){
        let param: [String: Any] = [:]
        WebService.sharedInstance.purchaseSubscriptionPlanService(param: param) { (response) in
            
        }
    }
    func getPlans(){
        WebService.sharedInstance.getPlansListService { list in
            self.plansList = list
            self.hostVc?.subsciptionPlanCollectionView.reloadData()
        }
    }
}
