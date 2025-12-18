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
    
    init(hostVC: BannerManagemntVC) {
        self.hostVC = hostVC
    }
    
    func getAllBanners() {
        var params: [String: Any] = [:]
        
        if !searchText.isEmpty {
          params["search"] = searchText
        }
        
        WebService.sharedInstance.getBanners(param: params) { data in
            self.hostVC.bannerData = data
            self.hostVC.bannerTableView.reloadData()
            self.hostVC.lblNoData.isHidden = !data.isEmpty
        }
    }
    
    
    
    
    
}
