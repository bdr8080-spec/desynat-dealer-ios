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
    
    init(hostVC: LiveCoverageListViewController) {
        self.hostVC = hostVC
    }
    
}
