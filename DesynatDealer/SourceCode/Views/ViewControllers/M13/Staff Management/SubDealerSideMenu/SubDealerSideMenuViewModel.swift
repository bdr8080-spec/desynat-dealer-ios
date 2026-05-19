//
//  SubDealerSideMenuViewModel.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 24/04/26.
//

import Foundation
import UIKit
import SDWebImage

class SubDealerSideMenuViewModel {
    
    private var hostVC: SubDealerSideMenuViewController
    var userProfile: StaffDetails?
   
    
    init(hostVC: SubDealerSideMenuViewController) {
        self.hostVC = hostVC
    }
    
    func logoutAPI(){
        WebService.sharedInstance.logoutService() { (response) in
            kSharedSceneDelegate.logoutUser()
            kSharedSceneDelegate.navigateToLoginVC()
            UserDefaults.standard.setValue("No", forKey:"isLogin")
        }
    }
    
    func getUserProfile() {
        if let savedUser: User = kSharedUserDefaults.retrieveModelFor(key: .user, model: User.self) {
            getStaffDetails(userId: savedUser.id ?? 0)
        }
    }
    
    func getStaffDetails(userId: Int?) {
        let param: [String:Any] = ["id": userId ?? 0]
        WebService.sharedInstance.getSingleStaffDetailService(param, completion: { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if response.isBlock == 1 {
                    kSharedSceneDelegate.navigateToLoginVC()
                } else {
                    self.userProfile = response
                    self.populateData(data: response)
                    if response.roleAction?.first?.menuID == 1 {
                        kSharedUserDefaults.setSubAdminUserHasDashboardAccess(hasDashboardAccess: true)
                        if response.roleAction?.first?.menuID == 1 && response.roleAction?.first?.canAction == 1 {
                            kSharedUserDefaults.setSubAdminActionDashboardAccess(hasActionDashboardAccess: true)
                        }
                    } else if response.roleAction?.first?.menuID != 1 {
                        kSharedUserDefaults.setSubAdminUserHasDashboardAccess(hasDashboardAccess: false)
                        kSharedUserDefaults.setSubAdminActionDashboardAccess(hasActionDashboardAccess: false)
                    }
                }
            }
        })
    }
    
    func populateData(data: StaffDetails) {
        if let imageUrlString = data.profilePic,
           let url = URL(string: imageUrlString) {
            hostVC.userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            hostVC.userProfileImageView.sd_imageIndicator?.startAnimatingIndicator()
            hostVC.userProfileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "userProfile"))
        } else {
            hostVC.userProfileImageView.image = UIImage(named: "userProfile")
        }
        
        hostVC.usernameLabel.text = "\(data.firstName ?? "")"
        hostVC.userEmailLabel.text = data.email
        hostVC.sideMenuTableView.reloadData()
        hostVC.updateTableHeight()
    }
}
