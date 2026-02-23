//
//  BannerManagementVM.swift
//  DesynatDealer
//
//  Created by fluper on 18/12/25.
//

import UIKit

class BannerManagementVM: NSObject {
    private var hostVC: BannerManagemntVC
    var searchText: String = ""
    var appliedFilter: BannerFilterModel?
    
    init(hostVC: BannerManagemntVC) {
        self.hostVC = hostVC
    }
    
    func getAllBanners() {
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

//        if !(filter?.statusIds.isEmpty ?? false) {
//            params["banner_filter"] = filter?.statusIds
//        }
      
      if let status = filter?.statusId {
          params["banner_filter"] = status // wrap in array if API expects array
      }
        
        WebService.sharedInstance.getBanners(param: params) { data in
            self.hostVC.bannerData = data
            self.hostVC.bannerTableView.reloadData()
            self.hostVC.lblNoData.isHidden = !data.isEmpty
        }
    }
    
}
