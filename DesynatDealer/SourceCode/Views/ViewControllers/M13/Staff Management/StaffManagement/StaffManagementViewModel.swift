//
//  StaffManagementViewModel.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 16/04/26.
//

import Foundation

class StaffManagementViewModel {
    
    private var hostVC: StaffManagementViewController
    var staffList: [StaffDetails] = []
    var searchText: String = ""
    var currentPage: Int = 1
    var isLoading = false
    var hasMoreData = true
    let limit = 10
    var appliedFilter = StaffListFilterModel()
    init(hostVC: StaffManagementViewController) {
        self.hostVC = hostVC
    }
    
    func updateActiveStatus(param: [String: Any], completion: @escaping (Bool) -> Void) {
        WebService.sharedInstance.updateActiveInactiveStaffDetailService(param, completion: { response in
            completion(true)
        })
    }
    
    func deleteStaff(param: [String: Any], completion: @escaping (Bool) -> Void) {
        WebService.sharedInstance.deleteStaffService(param, completion: { response in
            completion(true)
        })
    }
    
    func getAllStaffList() {
        
        if isLoading || !hasMoreData { return }
        isLoading = true
        
        let filter = appliedFilter
        var params: [String: Any] = [:]
        
        params["page"] = currentPage
        params["limit"] = limit
        
        if !searchText.isEmpty {
            params["search"] = searchText
        }
        
        if let fromDate = filter.fromDate,
           !fromDate.isEmpty,
           let formatted = convertDateFormat(fromDate) {
            params["from_date"] = formatted
        }
        
        if let toDate = filter.toDate,
           !toDate.isEmpty,
           let formatted = convertDateFormat(toDate) {
            params["to_date"] = formatted
        }
        
        if let roleId = filter.roleId {//,
//           status.rawValue > -1 {
            params["role_filter"] = roleId
        }
        
        if let status = filter.activeStatus {
            params["status_filter"] = status
        }
        
        WebService.sharedInstance.getAllStaffListService(param: params) { data in
            
            let newData = data.data ?? []
            
            if self.currentPage == 1 {
                self.staffList = newData
            } else {
                self.staffList.append(contentsOf: newData)
            }
            
            // IMPORTANT FIX
            // if returned data count < limit means last page
            self.hasMoreData = newData.count == self.limit
            
            self.isLoading = false
            
            DispatchQueue.main.async {
                self.hostVC.tableView.reloadData()
                self.hostVC.noDataFoundLabel.isHidden = !self.staffList.isEmpty
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

