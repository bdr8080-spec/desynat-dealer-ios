//
//  StaffManagementViewModel.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 16/04/26.
//

import Foundation

class StaffManagementViewModel {
    
    private var hostVC: StaffManagementViewController
    //    var staffList: [staffList]
    init(hostVC: StaffManagementViewController) {
        self.hostVC = hostVC
    }
    
    func getAllStaffList() {
        
    }
    
    func updateActiveStatus(param: [String: Any], completion: @escaping (Bool) -> Void) {
        //      WebService.shared.updateStatusBoy(param: param){ response in
        //        completion(true)
        //      }
    }
    
    func deleteStaff(param: [String: Any], completion: @escaping (Bool) -> Void) {
        //      WebService.shared.updateStatusBoy(param: param){ response in
        //        completion(true)
//        getAllStaffList()
        //      }
    }
    
    
}
