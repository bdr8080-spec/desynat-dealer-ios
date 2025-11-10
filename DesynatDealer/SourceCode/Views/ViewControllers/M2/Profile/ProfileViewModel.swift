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
    
//    func getUserData() {
//        if let savedUser: UserModel = kSharedUserDefaults.retrieveModelFor(key: .user, model: UserModel.self) {
//            hostVC.usernameLabel.text = savedUser.fullName
//            hostVC.emailLabel.text = savedUser.email
//            hostVC.userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.medium
//            (hostVC.userProfileImageView.sd_imageIndicator as? SDWebImageActivityIndicator)?.indicatorView.color = .gray
//            if let imageUrlString = savedUser.profileImage,
//               let url = URL(string: imageUrlString) {
//                hostVC.userProfileImageView.sd_setImage(
//                    with: url,
//                    placeholderImage: UIImage(named: "userProfile")
//                )
//            } else {
//                hostVC.userProfileImageView.image = UIImage(named: "userProfile")
//            }
//        }
//    }

    
}
