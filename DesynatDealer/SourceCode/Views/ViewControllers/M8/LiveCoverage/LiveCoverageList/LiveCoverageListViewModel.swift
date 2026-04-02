//
//  LiveCoverageListViewModel.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 13/02/26.
//

import Foundation

class LiveCoverageListViewModel {
    
    private var hostVC: LiveCoverageListViewController
    var searchText: String = ""
    var currentPage: Int = 1
    var isLoading = false
    var hasMoreData = true
    var liveRequestList: [LiveCoverageRequestList] = []
    var appliedFilter: LiveCoverageFilterModel?
    
    init(hostVC: LiveCoverageListViewController) {
        self.hostVC = hostVC
    }
    
    func getAllLiveCoverageRequest() {
        
        if isLoading || !hasMoreData { return }
        isLoading = true
        
        let filter = appliedFilter
        var params: [String: Any] = [:]
        
        params["page"] = currentPage
        params["limit"] = 2
       
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        
        if let from = filter?.fromDate, !from.isEmpty {
            params["from"] = from
        }
        
        if let to = filter?.toDate, !to.isEmpty {
            params["to"] = to
        }
        
        if let status = filter?.filterId, status > -1 {
            params["filter"] = status + 1
        }
        
        WebService.sharedInstance.getLiveCoverageRequest(param: params) { data in
            
            let newData = data.data ?? []
            
            if self.currentPage == 1 {
                self.liveRequestList = newData
            } else {
                self.liveRequestList.append(contentsOf: newData)
            }
            
            self.hasMoreData = !newData.isEmpty
            self.isLoading = false
            
            DispatchQueue.main.async {
                self.hostVC.timeSlotsTableView.reloadData()
                self.hostVC.timeSlotsTableView.layoutIfNeeded()
                self.hostVC.handleHeightOfTableView()
                self.hostVC.noDataFoundLabel.isHidden = !self.liveRequestList.isEmpty
            }
        }
    }
    
    
}


struct LiveCoverageFilterModel {
    var fromDate: String?
    var toDate: String?
    var filterId: Int?
}
