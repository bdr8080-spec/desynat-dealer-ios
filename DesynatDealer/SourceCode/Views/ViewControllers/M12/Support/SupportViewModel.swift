//
//  SupportViewModel.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 08/04/26.
//


import Foundation

class SupportViewModel {
    
    private var hostVC: SupportViewController
    var ticketsList: [SupportList] = []
    var currentPage: Int = 1
    var totalPages: Int = 1
    var searchText: String = ""
    
    init(hostVC: SupportViewController) {
        self.hostVC = hostVC
    }
    
    func getAllTicketListRequest() {
        var params: [String : Any] = [:]
        params["page"] = currentPage
        params["limit"] = 3
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        WebService.sharedInstance.getAllTicketListforUserService(params: params) { [weak self] response in
            guard let self = self else { return }
            
            // Update page info
            self.currentPage = response.currentPage ?? 1
            self.totalPages = response.lastPage ?? 1
            
            // Update data
            self.ticketsList = response.data ?? []
            
            DispatchQueue.main.async {
                self.hostVC.pageCountLabel.text = String(format: "%02d of %02d", self.currentPage, self.totalPages)
                self.hostVC.ticketManagementTableView.reloadData()
                self.hostVC.noDataFoundLabel.isHidden = !self.ticketsList.isEmpty
                self.hostVC.updatePaginationButtonImages()
            }
        }
    }
    
    func goToNextPage() {
        guard currentPage < totalPages else { return }
        currentPage += 1
        getAllTicketListRequest()
    }
    
    func goToPreviousPage() {
        guard currentPage > 1 else { return }
        currentPage -= 1
        getAllTicketListRequest()
    }
}
