//
//  DealListedViewModel.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 22/01/26.
//

import Foundation

class DealListedViewModel {
    
    private var hostVC: DealListedViewController
    var searchText: String = ""
    var listedDeal: [ListedDeal]?
    var enrolledDeals: [ListedDeal]?
    var expiredDeal: [ListedDeal]?
    
    init(hostVC: DealListedViewController) {
        self.hostVC = hostVC
    }
    
    func dealsListRequest() {
        var params: [String: Any] = [:]
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        WebService.sharedInstance.getDealsListRequest(param: params){ response in
            DispatchQueue.main.async { [self] in
                self.listedDeal = response.listedDeal
                self.enrolledDeals = response.enrolled
                self.expiredDeal = response.expiredDeal
                switch hostVC.tabType {
                case .listedDeals:
//                    self.hostVC.listTableView.isHidden = listedDeal?.isEmpty ?? true
                    hostVC.noDataFoundLabel.isHidden = !(listedDeal?.isEmpty ?? true)
                case .enrolled:
//                    self.hostVC.listTableView.isHidden = enrolledDeals?.isEmpty ?? true
                    hostVC.noDataFoundLabel.isHidden = !(enrolledDeals?.isEmpty ?? true)
                case .expired:
//                    self.hostVC.listTableView.isHidden = expiredDeal?.isEmpty ?? true
                    hostVC.noDataFoundLabel.isHidden = !(expiredDeal?.isEmpty ?? true)
                }
                self.hostVC.listTableView.reloadData()
            }
        }
    }
}
