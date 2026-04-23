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
    
    init(hostVC: StaffManagementViewController) {
        self.hostVC = hostVC
    }
    
    func getAllStaffList(completion: @escaping ([StaffDetails]) -> Void) {
        WebService.sharedInstance.getAllStaffListService(completion: { response in
            self.staffList = response
            completion(self.staffList)
        })
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
    
    
}
