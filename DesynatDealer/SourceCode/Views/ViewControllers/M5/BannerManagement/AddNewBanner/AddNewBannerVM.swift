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
  
  func validation() -> Bool {
      let selectedBanner = hostVC.selectedImg
      let fromDate = hostVC.txtFromDate.text ?? ""
      let toDate = hostVC.txtToDate.text ?? ""
//      let bannerImg = hostVC.bannerImageUrl
      var errorMessage: AlertConstant = .none

      // 1️⃣ Banner position
      if selectedBanner == nil {
          errorMessage = .selectBanner
      }

      // 2️⃣ Category-specific validation
      else if selectedBanner == 2 {
          if hostVC.selectedCategoryId == nil {
              errorMessage = .selectCategory
          } else if hostVC.selectedSubCategoriesId == nil {
              errorMessage = .selectSubCategory
          }
      }
//      hostVC.pickedImage == nil
      // 3️⃣ Common validations (for ALL banner types)
      if errorMessage == .none {
          if fromDate.isEmpty {
              errorMessage = .selectFromDate
          } else if toDate.isEmpty {
              errorMessage = .selectToDate
          } else if hostVC.pickedImage == nil {
              errorMessage = .uploadBanner
          }
      }

      if errorMessage != .none {
          hostVC.showAlert(msg: errorMessage.rawValue.localiz())
      }

      hostVC.view.endEditing(true)
      return errorMessage == .none
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
    
    func uploadFullScreenBanner(
        file: Any,
        isImage: Bool,
        isGif: Bool = false,
        completion: @escaping(String) -> Void
    ) {
        let mime: MultipartUpload.Mime = isGif ? .gif : (isImage ? .image : .pdf)
        
        let param = MultipartUpload(
            fileName: "image",
            file: file,
            mimeType: mime
        )
        
        WebService.sharedInstance.uploadWithResolutionPromotional(withParams: param) {
            url, msg, code in
            completion(url)
        }
    }
  
  func getPrice(type: String) {
      let params: [String: Any] = [
          "type": type
      ]
      
      WebService.sharedInstance.getBannerPrice(param: params) { data in
          let priceString = data.first?.perDayPrice ?? "0"
          let price = Int(priceString) ?? 0
          
          self.hostVC.pricePerDay = price
          self.hostVC.lblTotalPrice.text = "0 KD"
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
            "price": hostVC.getNumericBannerAmount()
        ]
        
        if bannerPosition == "3" {
            params["category"] = hostVC.selectedCategoryId ?? ""
            params["subcatgory"] = hostVC.selectedSubCategoriesId ?? ""
        }
        
        WebService.sharedInstance.addBanners(param: params) { data in
            let vc = AddBannerSuccessVC.instantiate(fromAppStoryboard: .BannerManagement)
            vc.dismissCallBack = {
                self.hostVC.onBannerAdded?()
                self.hostVC.navigationController?.popViewController(animated: true)
            }
            self.hostVC.navigationController?.present(vc, animated: true)
        }
    }
}
