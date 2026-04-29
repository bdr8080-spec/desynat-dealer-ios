//
//  HomeVieWModel.swift
//  DesynatDealer
//
//  Created by fluper on 24/11/25.
//

import Foundation
import UIKit
import SDWebImage

class HomeViewModel {
    
    private var hostVC: HomeViewController
    var storeAvailabilityModel: StoreAvailabilityStatusModel?
    
    init(hostVC: HomeViewController) {
        self.hostVC = hostVC
    }
    
    func getCountOfNotificationRequest(){
        WebService.sharedInstance.getCountOfNotificationForService { [self] response in
            let notificationCount = response.notificationCount ?? 0
            if notificationCount > 0 {
                self.hostVC.notificationCountView.isHidden = false
                self.hostVC.notificationCountLabel.text = notificationCount.description
            } else {
                self.hostVC.notificationCountView.isHidden = true
            }
            
            let chatUnreadCount = response.chatUnreadCount ?? 0
            if chatUnreadCount > 0 {
                self.hostVC.messageCountView.isHidden = false
                self.hostVC.unreadMessageCountLabel.text = chatUnreadCount.description
            } else {
                self.hostVC.messageCountView.isHidden = true
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
    
    func getParentDealerProfile(){
        WebService.sharedInstance.getUserProfile { [weak self] response in
            guard let self else { return }
            if let storeImageUrl = response.profilePic,
               let url = URL(string: storeImageUrl) {
                hostVC.userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                hostVC.userProfileImageView.sd_imageIndicator?.startAnimatingIndicator()
                hostVC.userProfileImageView.sd_setImage(with: url, placeholderImage: .userProfile)
            }
            
        }
    }
    
    func getUserProfile() {
        if let savedUser: User = kSharedUserDefaults.retrieveModelFor(key: .user, model: User.self) {
            if savedUser.type == "0" {
                getParentDealerProfile()
            } else {
                getStaffDetails(userId: savedUser.id)
            }
        }
    }
    
    func getStaffDetails(userId: Int?) {
        let param: [String:Any] = ["id": userId ?? 0]
        WebService.sharedInstance.getSingleStaffDetailService(param, completion: { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let storeImageUrl = response.profilePic,
                   let url = URL(string: storeImageUrl) {
                    self.hostVC.userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    self.hostVC.userProfileImageView.sd_imageIndicator?.startAnimatingIndicator()
                    self.hostVC.userProfileImageView.sd_setImage(with: url, placeholderImage: .userProfile)
                }
                if response.roleAction?.first?.menuID == 1 && response.roleAction?.first?.canAction == 1 {
                    self.hostVC.btnToggle.isUserInteractionEnabled = true
                } else {
                    self.hostVC.btnToggle.isUserInteractionEnabled = false
                }
            }
        })
    }
    
}
