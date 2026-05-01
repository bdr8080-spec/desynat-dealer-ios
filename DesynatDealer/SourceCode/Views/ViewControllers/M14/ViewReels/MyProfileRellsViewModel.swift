//
//  MyProfileRellsViewModel.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 02/04/26.
//

import Foundation

class MyProfileRellsViewModel {
    
    private var hostVC: MyProfileRellsViewController
    
    init(hostVC: MyProfileRellsViewController) {
        self.hostVC = hostVC
    }
    
    func deleteReel() {
        let param: [String: Any] = ["reel_id": hostVC.reelsData?.id ?? 0]
        WebService.sharedInstance.deleteReelsServices(param: param) { [weak self] response in
            guard let self = self else { return }
            CommonUtils.showToast(message: "Reel deleted Successfully".localiz())
            self.hostVC.navigationController?.popViewController(animated: true)
        }
    }
    
    func updateMyReelsStatusRequest() {
        let param: [String: Any] = ["reel_id": hostVC.reelsData?.id ?? 0]
        WebService.sharedInstance.updateMyReelsStatusServices(param: param) { [weak self] response in
            guard let self = self else { return }
            self.hostVC.reelsData = response
            self.hostVC.configData()
            if response.status == 1 {
                CommonUtils.showToast(message: "Reel activated successfully".localiz())
            } else {
                CommonUtils.showToast(message: "Reel deactivated successfully".localiz())
            }
        }
    }
    
}
