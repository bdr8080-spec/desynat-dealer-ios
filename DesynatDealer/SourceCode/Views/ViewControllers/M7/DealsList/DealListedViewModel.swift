//
//  DealListedViewModel.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 22/01/26.
//

import Foundation

//class DealListedViewModel {
//    
//    private var hostVC: DealListedViewController
//    var searchText: String = ""
//    var listedDeal: [ListedDeal]?
//    var enrolledDeals: [ListedDeal]?
//    var expiredDeal: [ListedDeal]?
//    var appliedFilter = DealListFilterModel()
//  
//    init(hostVC: DealListedViewController) {
//        self.hostVC = hostVC
//    }
//    
//    func dealsListRequest() {
//        var params: [String: Any] = [:]
//        if !searchText.isEmpty {
//            params["search"] = searchText
//        }
//        
//        if let fromDate = appliedFilter.fromDate,
//           !fromDate.isEmpty,
//           let formattedFromDate = convertDateFormat(fromDate) {
//            params["from"] = formattedFromDate
//            params["tab"] = hostVC.tabType.rawValue
//        }
//
//        if let toDate = appliedFilter.toDate,
//           !toDate.isEmpty,
//           let formattedToDate = convertDateFormat(toDate) {
//            params["to"] = formattedToDate
//        }
//        
//        WebService.sharedInstance.getDealsListRequest(param: params){ response in
//            DispatchQueue.main.async { [self] in
//                self.listedDeal = response.listedDeal
//                self.enrolledDeals = response.enrolled
//                self.expiredDeal = response.expiredDeal
//
//                hostVC.listTableView.reloadData()
//                hostVC.updateNoDataState()
//            }
//
//        }
//    }
//    
//    func convertDateFormat(
//        _ dateString: String,
//        from inputFormat: String = "dd/MM/yyyy",
//        to outputFormat: String = "yyyy-MM-dd"
//    ) -> String? {
//        let inputFormatter = DateFormatter()
//        inputFormatter.dateFormat = inputFormat
//        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
//
//        let outputFormatter = DateFormatter()
//        outputFormatter.dateFormat = outputFormat
//        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
//
//        guard let date = inputFormatter.date(from: dateString) else {
//            return nil
//        }
//        return outputFormatter.string(from: date)
//    }
//
//}

import Foundation

class DealListedViewModel {

    private var hostVC: DealListedViewController
    var searchText: String = ""
    var listedDeal: [ListedDeal]?
    var enrolledDeals: [ListedDeal]?
    var expiredDeal: [ListedDeal]?

    // Tab-specific filters
    var filtersByTab: [DealsListedType: DealListFilterModel] = [:]

    init(hostVC: DealListedViewController) {
        self.hostVC = hostVC
    }

    // Current filter for the selected tab
    func currentFilter(for tab: DealsListedType) -> DealListFilterModel {
        return filtersByTab[tab] ?? DealListFilterModel()
    }

    func dealsListRequest(tab: DealsListedType) {

        let filter = currentFilter(for: tab)
        var params: [String: Any] = [:]

        if !searchText.isEmpty {
            params["search"] = searchText
        }

        // Pass tab only if filter is applied
        if filter.isApplied {
            params["tab"] = tab.rawValue
        }

        if let fromDate = filter.fromDate,
           !fromDate.isEmpty,
           let formattedFromDate = convertDateFormat(fromDate) {
            params["from"] = formattedFromDate
        }

        if let toDate = filter.toDate,
           !toDate.isEmpty,
           let formattedToDate = convertDateFormat(toDate) {
            params["to"] = formattedToDate
        }

        WebService.sharedInstance.getDealsListRequest(param: params) { response in
            DispatchQueue.main.async {
                self.listedDeal = response.listedDeal
                self.enrolledDeals = response.enrolled
                self.expiredDeal = response.expiredDeal

                self.hostVC.listTableView.reloadData()
                self.hostVC.updateNoDataState()
            }
        }
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

// MARK: - Filter helper
extension DealListFilterModel {
    var isApplied: Bool {
        let hasFrom = !(fromDate?.isEmpty ?? true)
        let hasTo = !(toDate?.isEmpty ?? true)
        return hasFrom || hasTo
    }
}
