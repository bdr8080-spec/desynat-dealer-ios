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
    var dashBoardData:DashboardData?
    
    init(hostVC: HomeViewController) {
        self.hostVC = hostVC
    }
    
    func getDashboardApi(filterType:Int?,fromDate:String?,toDate:String?,dateAnalyticsFrom:String?,dateAnalyticsTo:String?) {
        var param = [String:Any]()
        if filterType ?? 0 > 0 {
           param = ["filter":filterType ?? 0]
        }
//        if fromDate != "" && toDate != "" {
//            param = ["from_date":fromDate ?? "",
//                                        "to_date":toDate ?? ""]
//        }
//        if dateAnalyticsTo != "" && dateAnalyticsFrom != "" {
//            param = ["from_date_analytics":dateAnalyticsFrom ?? "",
//                                        "to_date_analytics":dateAnalyticsTo ?? ""]
//        }
        
        if let from = fromDate, let to = toDate, !from.isEmpty, !to.isEmpty {
            param["from_date"] = from
            param["to_date"] = to
        } else if let filter = filterType, filter > 0 {
//            param["filter"] = filter
        }
        
        if let aFrom = dateAnalyticsFrom, let aTo = dateAnalyticsTo, !aFrom.isEmpty, !aTo.isEmpty {
            param["from_date_analytics"] = aFrom
            param["to_date_analytics"] = aTo
        }
        WebService.sharedInstance.sellerDashboardService(param: param) { data in
            self.dashBoardData = data
            let text = "KD"//.localiz()
            self.hostVC.lblTotalRevenue.text = "\(self.dashBoardData?.totalRevenue ?? "") \(text)"
            self.hostVC.lblActiveProducts.text = "\(self.dashBoardData?.totalActiveProducts ?? 0)"
            self.hostVC.lblInActiveProducts.text = "\(self.dashBoardData?.totalInactiveProducts ?? 0)"
            self.hostVC.lblCompletedOrders.text = "\(self.dashBoardData?.totalCompletedOrders ?? 0)"
            self.hostVC.lblCancelledOrders.text = "\(self.dashBoardData?.totalCancelledOrders ?? 0)"
            self.hostVC.lblActiveStaff.text = "\(self.dashBoardData?.totalActiveStaff ?? 0)"
            self.hostVC.lblInActiveStaff.text = "\(self.dashBoardData?.totalInactiveStaff ?? 0)"
            self.hostVC.lblNewOrders.text = "\(self.dashBoardData?.totalNewOrders ?? 0)"
            self.hostVC.lblOngoingOrders.text = "\(self.dashBoardData?.totalOngoingOrders ?? 0)"
            self.hostVC.lblTotalProducts.text = "(\(self.dashBoardData?.totalProducts ?? 0))"
            self.hostVC.lblTotalOrders.text = "(\(self.dashBoardData?.totalOrders ?? 0))"
            self.hostVC.lblTotalStaff.text = "(\(self.dashBoardData?.totalStaff ?? 0))"
            self.hostVC.setUpChart()
        }
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
                let storeStatus = response.storeInfo?.storeAvailability ?? 0
                hostVC.btnToggle.setImage(
                    UIImage(named: storeStatus == 1 ? "toggle_on" : "toggle_off"),
                    for: .normal
                )
                hostVC.busyOnOffLabel.text = storeStatus == 1 ? "Open".localiz() : "Busy".localiz()
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
                if response.isBlock == 1 {
                    kSharedSceneDelegate.navigateToLoginVC()
                } else {
                    if let storeImageUrl = response.profilePic,
                       let url = URL(string: storeImageUrl) {
                        self.hostVC.userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        self.hostVC.userProfileImageView.sd_imageIndicator?.startAnimatingIndicator()
                        self.hostVC.userProfileImageView.sd_setImage(with: url, placeholderImage: .userProfile)
                        let savedStatus = UserDefaults.standard.getIntFor(key: .storeAvailabilityStatus) ?? 0
                        self.hostVC.btnToggle.setImage(
                            UIImage(named: savedStatus == 1 ? "toggle_on" : "toggle_off"),
                            for: .normal
                        )
                        self.hostVC.busyOnOffLabel.text = savedStatus == 1 ? "Open".localiz() : "Busy".localiz()
                    }
                    if response.roleAction?.first?.menuID == 1 && response.roleAction?.first?.canAction == 1 {
                        self.hostVC.btnToggle.isUserInteractionEnabled = true
                    } else {
                        self.hostVC.btnToggle.isUserInteractionEnabled = false
                    }
                }
            }
        })
    }
}
