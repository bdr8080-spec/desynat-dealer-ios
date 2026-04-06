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
  var userProfile: SellerProfileDataModel?
  
  init(hostVC: HomeViewController) {
    self.hostVC = hostVC
  }
    
    func getCountOfNotificationRequest(){
        WebService.sharedInstance.getCountOfNotificationForService { [self] count in
            if count > 0 {
                self.hostVC.notificationCountView.isHidden = false
                self.hostVC.notificationCountLabel.text = count.description
            } else {
                self.hostVC.notificationCountView.isHidden = true
            }
        }
    }
    
    func getAdminStory() {
        WebService.sharedInstance.getAdminStoryService() { list in
            if list.count > 0 {
                self.hostVC.adminstoryImageView.image = .logo
                self.hostVC.adminstoryButtonOutlet.isUserInteractionEnabled = true
            } else{
                self.hostVC.adminstoryImageView.image = .adminStroyEmpty
                self.hostVC.adminstoryButtonOutlet.isUserInteractionEnabled = false
            }
        }
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
  
  func getUserProfile(){
    WebService.sharedInstance.getUserProfile { [weak self] response in
      guard let self else { return }
      userProfile = response
      hostVC.showProfileImage()
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
