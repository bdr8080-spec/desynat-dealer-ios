//
//  HomeVieWModel.swift
//  DesynatDealer
//
//  Created by fluper on 24/11/25.
//

import Foundation
import UIKit

class HomeViewModel {
  
  private var hostVC: HomeViewController
  var storeAvailabilityModel: StoreAvailabilityStatusModel?
  
  init(hostVC: HomeViewController) {
    self.hostVC = hostVC
  }
  
  func statusUpdateAPI(completion: @escaping (Bool) -> Void) {
    WebService.sharedInstance.storeStatusUpdateService{ [weak self] response in
      guard let self = self else { return }
      let updatedStatus = response.storeAvailability ?? 0
      UserDefaults.standard.saveIntFor(key: .storeAvailabilityStatus, value: updatedStatus)
      self.storeAvailabilityModel = response
      completion(true)
    }
  }
  
//  func getDelearProfile(completion: @escaping (Bool) -> Void) {
//    WebService.sharedInstance.getDelearProfileService{ [weak self] response in
//      guard let self = self else { return }
//      
//      completion(true)
//    }
//  }
  
}
