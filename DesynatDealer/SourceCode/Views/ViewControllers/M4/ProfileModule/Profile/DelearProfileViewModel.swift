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
    var highlightList: [GetHighLightsDataModel]?
    
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
    
    func getMyHighLights(){
    WebService.sharedInstance.getMyHighLights { [weak self] response in
      guard let self else { return }
        highlightList = response
        hostVC.storiesCollectionView.reloadData()
    }
  }
  
}
