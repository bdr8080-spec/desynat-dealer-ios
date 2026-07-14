//
//  StoryManagementListViewModel.swift
//  DesynatDealer
//
//  Created by fluper_mac2 on 14/07/26.
//

import Foundation

class StoryManagementListViewModel {
    
    private var hostVC: StoryManagementListViewController
    
    init(hostVC: StoryManagementListViewController) {
        self.hostVC = hostVC
    }
    var searchText: String = ""
    var appliedFilter: BannerFilterModel?
    
    func getAllStories() {
        let filter = appliedFilter
        var params: [String: Any] = [:]
        
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        
        if let from = filter?.fromDate, !from.isEmpty {
            params["from"] = from
        }
        
        if let to = filter?.toDate, !to.isEmpty {
            params["to"] = to
        }
        
        if let status = filter?.statusId {
            params["banner_filter"] = status
        }
        
        WebService.sharedInstance.getBanners(param: params) { data in
            self.hostVC.bannerData = data
            self.hostVC.storiesTableView.reloadData()
            self.hostVC.lblNoData.isHidden = !data.isEmpty
        }
    }
}
