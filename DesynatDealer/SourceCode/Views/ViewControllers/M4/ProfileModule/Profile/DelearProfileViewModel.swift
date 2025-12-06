//
//  DelearProfileViewModel.swift
//  DesynatDealer
//
//  Created by fluper on 06/12/25.
//

import Foundation

class DelearProfileViewModel {
  
  private var hostVC: DelearProfileViewController
  var userProfile: SellerProfileDataModel?
  
  init(hostVC: DelearProfileViewController) {
    self.hostVC = hostVC
  }
  
  func getUserProfile(){
    WebService.sharedInstance.getUserProfile { [weak self] response in
      guard let self else { return }
      userProfile = response
      hostVC.populateData()
    }
  }
  
}
