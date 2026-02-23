//
//  CancelLiveRequestViewModel.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 23/02/26.
//

import Foundation

class CancelSendRequestViewModel {
    
    private var hostVC: CancelSendRequestViewController
    
    init(hostVC: CancelSendRequestViewController) {
        self.hostVC = hostVC
    }
    
    func cancelLiveCoverageRequest(reason: String) {
        let params: [String: Any] = ["id": hostVC.timeSlotsId ?? 0, "cancel_reason": reason]
        WebService.sharedInstance.cancelLiveCoverageRequest(param: params) { data in
            DispatchQueue.main.async {
                self.hostVC.dismiss(animated: true) {
                    self.hostVC.onCancellationDone?()
                }
            }
        }
    }
    
}

