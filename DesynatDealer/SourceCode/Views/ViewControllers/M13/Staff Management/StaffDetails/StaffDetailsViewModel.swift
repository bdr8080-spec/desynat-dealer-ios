//
//  StaffDetailsViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 21/04/26.
//

import Foundation
import UIKit

class StaffDetailsViewModel {
    
    private var hostVC: StaffDetailsViewController
    var staffDetails = [StaffDetails]()
    
    init(hostVC: StaffDetailsViewController) {
        self.hostVC = hostVC
    }
    
    func getStaffDetails() {
        let param: [String:Any] = ["id": hostVC.staffID ?? 0]
        WebService.sharedInstance.getSingleStaffDetailService(param, completion: { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.staffDetails.removeAll()
                self.staffDetails.append(response)
//                self.staffDetails = response
                self.hostVC.configUserData()
            }
        })
    }
    
    func upadteStaffStatus(param: [String: Any],_ selectedIndex:Int) {
        WebService.sharedInstance.updateActiveInactiveStaffDetailService(param) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let status = response.isBlock {
                    self.hostVC.isActiveLbl.text = response.isBlock == 0 ? "Active" : "Inactive"
                    self.hostVC.activeStatusbtn.setImage(UIImage(named: status == 0 ? "toggleOn" : "toggleOff"), for: .normal)
                    CommonUtils.showToast(message: status == 0 ? "Staff has been unblocked Successfully" : "Staff has been blocked Successfully"
                    )
                }
            }
        }
    }
        
        func shareStaffDetails() {
            //        let param: [String: Any] = ["id": hostVC.staffID ?? 0]
            //        WebService.sharedInstance.shareSubAdminCeredentialService(param: param){ [weak self] response in
            //            guard let self = self else { return }
            //            DispatchQueue.main.async {
            //                let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
            //                vc.comingReason = .ceredentailSentSuccessfully
            //                self.hostVC.navigationController?.present(vc, animated: true)
            //            }
            //        }
        }
        
        func deleteStaffDetails(param: [String: Any]) {
            WebService.sharedInstance.deleteStaffService(param, completion: { [weak self] response in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    CommonUtils.showToast(message: "Profile is deleted successfully")
                    self.hostVC.navigationController?.popViewController(animated: true)
                }
            })
        }
    }

