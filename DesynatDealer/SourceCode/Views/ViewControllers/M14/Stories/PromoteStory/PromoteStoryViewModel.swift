//
//  PromoteStoryViewModel.swift
//  DesynatDealer
//
//  Created by fluper_mac2 on 13/07/26.
//

import Foundation

class PromoteStoryViewModel {
    
    private var hostVC: PromoteStoryViewController
    
    init(hostVC: PromoteStoryViewController) {
        self.hostVC = hostVC
    }
    
    func uploadStories(imageUrl: String, isPromotional: Bool) {
        var param: [String: Any] = ["file": imageUrl,
                                    "thumbnail" : hostVC.thumbnailImage ?? "",
                                    "is_promotional": isPromotional ? 1 : 0] // 0-free,1-promotional
        if isPromotional {
            param["start_date"] = hostVC.selectedApiDate
            param["end_date"] = hostVC.selectedApiDate
            param["total_days"] = 1
            param["amount"] = hostVC.perDayPrice
        }
        WebService.sharedInstance.addNewStoryServices(param: param){ [weak self] response in
            guard let self = self else { return }
            if isPromotional {
                let vc = AddBannerSuccessVC.instantiate(fromAppStoryboard: .BannerManagement)
                vc.comingReason = .forStory
                vc.dismissCallBack = {
                    switch self.hostVC.comingReason {
                    case .fromStoryManagement:
                        self.hostVC.navigationController?.popToViewController(ofClass: StoryManagementListViewController.self)
                    case .fromProfile:
                        self.hostVC.navigationController?.popToViewController(ofClass: DelearProfileViewController.self)
                    }
                }
                hostVC.navigationController?.present(vc, animated: true)
            } else {
                CommonUtils.showToast(message: "Story Uploaded Succesfully".localiz())
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.hostVC.navigationController?.popToViewController(ofClass: DelearProfileViewController.self)
                }
            }
        }
    }
    
    func getStoryPriceServices() {
        let param: [String: Any] = ["country_id": hostVC.countryId,
                                    "no_of_days": 1]
        WebService.sharedInstance.getStoryPriceServices(param: param){ [weak self] response in
            guard let self = self else { return }
            hostVC.perDayPrice = response.perDayPrice
            hostVC.lblTotalPrice.text = CommonUtils.formatPriceStringInput(response.perDayPrice)
        }
    }
    
}
