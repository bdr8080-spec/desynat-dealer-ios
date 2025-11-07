//
//  SusbcriptionViewModel.swift
//  DesynatDealer
//
//  Created by fluper on 07/11/25.
//

import Foundation
import UIKit

class SubscriptionPlaneViewModel: NSObject {
    
    private var hostVC: SubscriptionVC
    var plansList: [GetPlansSubscriptionModel]? = []
    var transactionId: String?
    var payAmt: Double?
    
    init(hostVC: SubscriptionVC) {
        self.hostVC = hostVC
    }
    
    func getPlans(){
        WebService.sharedInstance.getPlansListService { list in
            self.plansList = list
            self.hostVC.subscriptionCollView.reloadData()
        }
    }
    
    func purchasePlan(planID: Int) {
        let params: [String: Any] = ["plan_id": planID]
        WebService.sharedInstance.purchasePlansListService(param: params) { result in
            let vc = PaymentMethodVC.instantiate(fromAppStoryboard: .Main)
            vc.transactionIds = result.transactionID ?? ""
            vc.payAmount = self.payAmt ?? 0
            self.hostVC.navigationController?.pushViewController(vc, animated: true)
        }
    }

    //Complete Paymnet Call api
    
    func completePlanPurchase(transactionId: String, paymentStatus:Int, onlineTransactionId: String) {
        let params: [String: Any] = ["transaction_id": transactionId, "payment_status": paymentStatus, "online_transaction_id": onlineTransactionId]
        WebService.sharedInstance.purchasePlansListService(param: params) { result in
            
        }
    }

}

