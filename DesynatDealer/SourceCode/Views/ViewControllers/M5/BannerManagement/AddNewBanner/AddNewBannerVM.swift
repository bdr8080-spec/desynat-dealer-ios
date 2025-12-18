//
//  AddNewBannerVM.swift
//  DesynatDealer
//
//  Created by fluper on 18/12/25.
//

import UIKit

class AddNewBannerVM: NSObject {
    private var hostVC: AddNewBannerVC
    
    init(hostVC: AddNewBannerVC) {
        self.hostVC = hostVC
    }
    
    func getCategoriesListApi() {
        WebService.sharedInstance.getCategoriesService { [self] list in
            self.hostVC.categoriesList = list
        }
    }
    
    func getSubCategoriesListApi(categoryId: Int) {
        let param: [String :Any] = ["category_id": categoryId]
      WebService.sharedInstance.getSubCategoriesService(param: param) { list in
          self.hostVC.subcategoriesList = list
      }
    }
    
    func addBanner() {
        guard let positionIndex = hostVC.selectedImg else { return }
        let bannerPosition = String(positionIndex + 1)
        
        var params: [String: Any] = [
            "banner_position": bannerPosition, //1 homeTop 2 home Banner 3 category
            "start_date": hostVC.txtFromDate.text?.toAPIDate() ?? "", //"2025-12-19",
            "end_date": hostVC.txtToDate.text?.toAPIDate() ?? "",
            "total_days": hostVC.lblTotalDays.text ?? "",
            "upload_banner": hostVC.bannerImageUrl,
            "price": hostVC.lblTotalPrice.text ?? ""
        ]
        
        if bannerPosition == "3" {
            params["category"] = hostVC.lblCategory.text ?? ""
            params["subcatgory"] = hostVC.lblSubCategory.text ?? ""
        }
        
        WebService.sharedInstance.addBanners(param: params) { data in
            let vc = AddBannerSuccessVC.instantiate(fromAppStoryboard: .BannerManagement)
            self.hostVC.navigationController?.present(vc, animated: true)
        }
    }
    
    func getPrice() {
        
    }
    
}
