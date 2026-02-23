//
//  SendNewLiveRequestViewModel.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 23/02/26.
//

import Foundation

class SendNewLiveRequestViewModel {
    
    private var hostVC: SendNewLiveRequestViewController
    var timeSlotsList: [GetTimeSlotsDataModel] = []
    
    init(hostVC: SendNewLiveRequestViewController) {
        self.hostVC = hostVC
    }
    
    func getAllTimeSlotsRequest() {
        let params: [String: Any] = ["date": hostVC.selectedDateString ?? ""]
        WebService.sharedInstance.getTimeSlotsRequest(param: params) { data in
            self.timeSlotsList = data
            DispatchQueue.main.async {
                self.hostVC.timeCollectionView.reloadData()
                self.hostVC.totalCoverageLabel.text = "Total Coverages- \(self.timeSlotsList.count)"
                self.hostVC.timeCollectionView.layoutIfNeeded()
                self.hostVC.handleHeightOfTableView()
                self.hostVC.noDataFoundLabel.isHidden = !self.timeSlotsList.isEmpty
            }
        }
    }
    
    func sendTimeSlotsRequest(timeslotId: Int) {
        let params: [String: Any] = ["timeslot_id": timeslotId]
        WebService.sharedInstance.sendTimeSlotsRequest(param: params) { data in
            DispatchQueue.main.async {
                self.hostVC.dismiss(animated: true) { [weak self] in
                    self?.hostVC.onSendTapped?()
                }
            }
        }
    }
    
}

