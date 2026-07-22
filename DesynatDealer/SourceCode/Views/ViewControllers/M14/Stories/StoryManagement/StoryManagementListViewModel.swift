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
    var storiesList: [StoryRequestList] = []
    var currentPage: Int = 1
    var isLoading = false
    var hasMoreData = true
    let limit = 10
    
    func getAllStoriesList() {
        guard !isLoading, hasMoreData else { return }

        isLoading = true

        let filter = appliedFilter
        var params: [String: Any] = [:]

        params["page"] = currentPage
        params["limit"] = limit

        if !searchText.isEmpty {
            params["search"] = searchText
        }

        if let fromDate = filter?.fromDate,
           !fromDate.isEmpty {
            params["from_date"] = fromDate
        }

        if let toDate = filter?.toDate,
           !toDate.isEmpty {
            params["to_date"] = toDate
        }

        if let status = filter?.statusId {
            params["filter"] = status
        }

        WebService.sharedInstance.getMyStoriesRequests(param: params) { [weak self] data in
            guard let self = self else { return }

            let newData = data.data ?? []

            if self.currentPage == 1 {
                self.storiesList = newData
            } else {
                self.storiesList.append(contentsOf: newData)
            }

            self.hasMoreData = newData.count == self.limit

            // Increment page only if more data is available
            if self.hasMoreData {
                self.currentPage += 1
            }

            self.isLoading = false

            DispatchQueue.main.async {
                self.hostVC.storiesTableView.reloadData()
                self.hostVC.lblNoData.isHidden = !self.storiesList.isEmpty
            }
        }
    }
    
    func resetPagination() {
        currentPage = 1
        hasMoreData = true
        isLoading = false
        storiesList.removeAll()
    }
    
    func convertDateFormat(
        _ dateString: String,
        from inputFormat: String = "dd/MM/yyyy",
        to outputFormat: String = "yyyy-MM-dd"
    ) -> String? {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = inputFormatter.date(from: dateString) else {
            return nil
        }
        
        return outputFormatter.string(from: date)
    }
}
