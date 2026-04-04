//
//  ProfileViewModel.swift
//  DesynatDealer
//
//  Created by fluper on 10/11/25.
//


import Foundation
import UIKit
import SDWebImage

class ProfileViewModel {
    
  private var hostVC: ProfileViewController
  var userProfile: SellerProfileDataModel?
  
    init(hostVC: ProfileViewController) {
        self.hostVC = hostVC
    }
    
    func logoutAPI(){
        WebService.sharedInstance.logoutService() { (response) in
            kSharedSceneDelegate.logoutUser()
            kSharedSceneDelegate.navigateToLoginVC()
            UserDefaults.standard.setValue("No", forKey:"isLogin")
        }
    }
  
  func getUserProfile(){
    WebService.sharedInstance.getUserProfile { [weak self] response in
      guard let self else { return }
      userProfile = response
      populateData(data: response)
    }
  }
  
  func populateData(data: SellerProfileDataModel) {
    if let imageUrlString = data.profilePic,
       let url = URL(string: imageUrlString) {
      hostVC.userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
      hostVC.userProfileImageView.sd_imageIndicator?.startAnimatingIndicator()
      hostVC.userProfileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "userProfile"))
    } else {
      hostVC.userProfileImageView.image = UIImage(named: "userProfile")
    }
    
    hostVC.usernameLabel.text = "\(data.firstName ?? "") \(data.lastName ?? "")"
    hostVC.userEmailLabel.text = data.email
  }

}
