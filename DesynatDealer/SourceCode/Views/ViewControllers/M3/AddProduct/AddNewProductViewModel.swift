//
//  AddNewProductViewMode.swift
//  DesynatDealer
//
//  Created by fluper on 24/11/25.
//

import Foundation

class AddNewProductViewModel: NSObject {
  
  private var hostVC: AddNewProductViewController
  var categoriesList: [CategoryDataModel] = []
  var subcategoriesList: [SubCategoryDataModel] = []
  var brandsList: [BrandsListDataModel] = []
  var colorsList: [ColorsLisDataModel] = []
  var sizesList: [SizeListDataModel] = []
  
  init(hostVC: AddNewProductViewController) {
    self.hostVC = hostVC
  }
  
  func getCategoriesListApi(){
    WebService.sharedInstance.getCategoriesService { [self] list in
      self.categoriesList = list
      self.hostVC.categoriesCollectionView.reloadData()
      self.hostVC.selectedCategoriesSection = categoriesList.first?.id ?? 0
      getSubCategoriesListApi()
    }
  }
  
  func getSubCategoriesListApi(){
    let param: [String :Any] = ["category_id": self.hostVC.selectedCategoriesSection ?? ""]
    WebService.sharedInstance.getSubCategoriesService(param: param) { [self] list in
      self.subcategoriesList = list
    }
  }
  
  func getBrandListApi(){
    WebService.sharedInstance.getBrandService() { [self] list in
      self.brandsList = list
    }
  }
  
  func getColoursListApi(){
    WebService.sharedInstance.getColorsListService() { [self] list in
      self.colorsList = list
    }
  }
  
  func getSizeListApi(){
    WebService.sharedInstance.getSizeListService() { [self] list in
      self.sizesList = list
    }
  }
  
  func validFields() -> Bool {
    var errorMessage: AlertConstant = .none
    
    let categoryId = hostVC.selectedCategoriesSection ?? -1
    let subcategoryId = hostVC.selectedSubCategoriesId ?? -1
    let brandId = hostVC.selectedBrandId ?? -1
    
    let otherBrandEn = hostVC.otherBrandEnglishTF.text?.trimmed() ?? ""
    let otherBrandAr = hostVC.otherBrandArabicTF.text?.trimmed() ?? ""
    let productNameEn = hostVC.producNameEngTF.text?.trimmed() ?? ""
    let productNameAr = hostVC.productNameArabicTF.text?.trimmed() ?? ""
    let descriptionEn = hostVC.descriptionEngTextView.text?.trimmed() ?? ""
    let descriptionAr = hostVC.descriptionArabicTextView.text?.trimmed() ?? ""
    
    let minQuantity = hostVC.minCartQuantityTF.text?.trimmed() ?? ""
    let maxQuantity = hostVC.maxCartQuantityTF.text?.trimmed() ?? ""
    let returnDays = hostVC.returnDayTF.text?.trimmed() ?? ""
    let exchangeDays = hostVC.exchangableTF.text?.trimmed() ?? ""
    let selectedBrand = brandsList.first { $0.id == brandId }
    let isOtherBrand = selectedBrand?.nameEnglish?.lowercased() == "other"
    // --------------------
    // MAIN STATIC CHECKS
    // --------------------
    if categoryId == -1 {
      errorMessage = .selectCategory
    } else if subcategoryId == -1 {
      errorMessage = .selectSubCategory
    } else if brandId == -1 {
      errorMessage = .selectBrand
    }  else if isOtherBrand && otherBrandEn.isEmpty {
      errorMessage = .otherBrandEnEmpty
    } else if isOtherBrand && otherBrandAr.isEmpty {
      errorMessage = .otherBrandArEmpty
    } else if productNameEn.isEmpty {
      errorMessage = .productNameEnEmpty
    } else if productNameAr.isEmpty {
      errorMessage = .productNameArEmpty
    } else if descriptionEn.isEmpty || descriptionEn == "Write Here" {//else if descriptionEn.isEmpty {
      errorMessage = .descriptionEnEmpty
    } else if descriptionAr.isEmpty || descriptionAr == "Write Here" {//else if descriptionAr.isEmpty {
      errorMessage = .descriptionArEmpty   // <-- STOP here
    } else if hostVC.prepareSpecificationData() == nil {
      hostVC.showAlert(msg: "Please fill all required fields for each specification")
      return false
    } else if hostVC.prepareVariantData(isWomenCategory: hostVC.isWomenCategory) == nil {
      hostVC.showAlert(msg: "Please fill all required fields for each variant before submitting")
      return false
    } else if minQuantity.isEmpty {
      errorMessage = .minQuantity
    } else if maxQuantity.isEmpty {
      errorMessage = .maxQuantity
    } else {
      // Check if max < min
      let minVal = Int(minQuantity) ?? 0
      let maxVal = Int(maxQuantity) ?? 0
      if maxVal < minVal {
        errorMessage = .maxMinQuantity
      } else if hostVC.isProductReturnable && returnDays.isEmpty {
        errorMessage = .returnDays
      } else if hostVC.isProductExchangable && exchangeDays.isEmpty {
        errorMessage = .exchangeDays
      } else if hostVC.selectedSizeChartImageUrl?.isEmpty ?? true {
        errorMessage = .sizeChartUpload
      }
    }
    
    
    // show final error if any
    if errorMessage != .none {
      hostVC.showAlert(msg: errorMessage.rawValue)
      return false
    }
    
    return true
  }
  
  
  
  func addProductApi() {
    let specificationData = hostVC.prepareSpecificationData() ?? [:]
    
    let variantData = hostVC.prepareVariantData(isWomenCategory: hostVC.isWomenCategory) ?? [:]
    
    var params: [String:Any] = [
      "category_id": hostVC.selectedCategoriesSection ?? "",
      "subcategory_id": hostVC.selectedSubCategoriesId ?? "",
      "brand_id": hostVC.selectedBrandId ?? "",
      "other_en": hostVC.otherBrandEnglishTF.text?.trimmed() ?? "",
      "other_ar": hostVC.otherBrandArabicTF.text?.trimmed() ?? "",
      "product_name_en": hostVC.producNameEngTF.text?.trimmed() ?? "",
      "product_name_ar": hostVC.productNameArabicTF.text?.trimmed() ?? "",
      "description_en": hostVC.descriptionEngTextView.text?.trimmed() ?? "",
      "description_ar": hostVC.descriptionArabicTextView.text?.trimmed() ?? "",
      "min_card_quantity": hostVC.minCartQuantityTF.text?.trimmed() ?? "",
      "max_card_quantity": hostVC.maxCartQuantityTF.text?.trimmed() ?? "",
      "product_return": hostVC.isProductReturnable.toAPI,
      "return_days": hostVC.returnDayTF.text?.trimmed() ?? "",
      "product_exchangable": hostVC.isProductExchangable.toAPI,
      "exchangable_days": hostVC.exchangableTF.text?.trimmed() ?? "",
      "review_rating": hostVC.isRatingAllowed.toAPI,
      "affiliated_product": hostVC.isAffiliatedAllowed.toAPI,
      "customized_product": hostVC.isCustomizationAllowed.toAPI,
      "ready_to_ship": hostVC.isCustomizationAllowed.toAPI,
      "cash_on_delivery": hostVC.isCashOnDeliveryAllowed.toAPI,
      "upload_size_chart": hostVC.selectedSizeChartImageUrl ?? "",
    ]
    // specification
    params["product_spe_en"] = specificationData["product_spe_en"]
    params["product_spe_feature_en"] = specificationData["product_spe_feature_en"]
    params["product_spe_ar"] = specificationData["product_spe_ar"]
    params["product_spe_feature_ar"] = specificationData["product_spe_feature_ar"]
    
    // variant Data
    params["variant_image"] = variantData["variant_image"]
    params["color_id"] = variantData["color_id"]
    params["size_id"] = variantData["size_id"]
    params["bust"] = variantData["bust"]
    params["waist"] = variantData["waist"]
    params["hip"] = variantData["hip"]
    params["shoulder"] = variantData["shoulder"]
    params["sleeve_length"] = variantData["sleeve_length"]
    params["length"] = variantData["length"]
    params["total_stock"] = variantData["total_stock"]
    params["sku"] = variantData["sku"]
    params["sku_threshold_value"] = variantData["sku_threshold_value"]
    params["actual_price"] = variantData["actual_price"]
    params["discount_type"] = variantData["discount_type"]
    params["discount_value"] = variantData["discount_value"]
    params["final_price"] = variantData["final_price"]
    
    print("param: ====>>\(params)")
    WebService.sharedInstance.addProductService(param: params) { (response) in
      CommonUtils.showToast(message: "Product is added successfully")
      DispatchQueue.main.async { [weak self] in
        guard let self else { return }
        self.hostVC.navigationController?.popViewController(animated: true)
      }
    }
  }
  
  func deleteProductDetailsService() {
    let param: [String: Any] = ["product_id" :hostVC.productId ?? 0]
    WebService.sharedInstance.deleteProductDetailsService(param: param){ [weak self] response in
      guard let self = self else { return }
      CommonUtils.showToast(message: "Product has been deleted successfully")
      DispatchQueue.main.async {
        //                self.hostVC.navigationController?.popViewController(animated: true)
        self.hostVC.navigationController?.popToRootViewController(animated: true)
      }
    }
  }
  
  func getProductDetailsService() {
    let param: [String: Any] = ["product_id" :hostVC.productId ?? 0]
    WebService.sharedInstance.getProductDetailsService(param: param){ [weak self] response in
      guard let self = self else { return }
      hostVC.prefillProductDetails(response)
    }
  }
  
  func editProductApi() {
    let specificationData = hostVC.prepareSpecificationData() ?? [:]
    let variantData = hostVC.prepareVariantData(isWomenCategory: hostVC.isWomenCategory) ?? [:]
    var params: [String:Any] = [
      "product_id": hostVC.productId ?? 0,
      "category_id": hostVC.selectedCategoriesSection ?? "",
      "subcategory_id": hostVC.selectedSubCategoriesId ?? "",
      "brand_id": hostVC.selectedBrandId ?? "",
      "other_en": hostVC.otherBrandEnglishTF.text?.trimmed() ?? "",
      "other_ar": hostVC.otherBrandArabicTF.text?.trimmed() ?? "",
      "product_name_en": hostVC.producNameEngTF.text?.trimmed() ?? "",
      "product_name_ar": hostVC.productNameArabicTF.text?.trimmed() ?? "",
      "description_en": hostVC.descriptionEngTextView.text?.trimmed() ?? "",
      "description_ar": hostVC.descriptionArabicTextView.text?.trimmed() ?? "",
      "min_card_quantity": hostVC.minCartQuantityTF.text?.trimmed() ?? "",
      "max_card_quantity": hostVC.maxCartQuantityTF.text?.trimmed() ?? "",
      "product_return": hostVC.isProductReturnable.toAPI,
      "return_days": hostVC.returnDayTF.text?.trimmed() ?? "",
      "product_exchangable": hostVC.isProductExchangable.toAPI,
      "exchangable_days": hostVC.exchangableTF.text?.trimmed() ?? "",
      "review_rating": hostVC.isRatingAllowed.toAPI,
      "affiliated_product": hostVC.isAffiliatedAllowed.toAPI,
      "customized_product": hostVC.isCustomizationAllowed.toAPI,
      "ready_to_ship": hostVC.isCustomizationAllowed.toAPI,
      "cash_on_delivery": hostVC.isCashOnDeliveryAllowed.toAPI,
      "upload_size_chart": hostVC.selectedSizeChartImageUrl ?? "",
    ]
    // specification
    params["product_spe_en"] = specificationData["product_spe_en"]
    params["product_spe_feature_en"] = specificationData["product_spe_feature_en"]
    params["product_spe_ar"] = specificationData["product_spe_ar"]
    params["product_spe_feature_ar"] = specificationData["product_spe_feature_ar"]
    
    // variant Data
    params["variant_image"] = variantData["variant_image"]
    params["color_id"] = variantData["color_id"]
    params["size_id"] = variantData["size_id"]
    params["bust"] = variantData["bust"]
    params["waist"] = variantData["waist"]
    params["hip"] = variantData["hip"]
    params["shoulder"] = variantData["shoulder"]
    params["sleeve_length"] = variantData["sleeve_length"]
    params["length"] = variantData["length"]
    params["total_stock"] = variantData["total_stock"]
    params["sku"] = variantData["sku"]
    params["sku_threshold_value"] = variantData["sku_threshold_value"]
    params["actual_price"] = variantData["actual_price"]
    params["discount_type"] = variantData["discount_type"]
    params["discount_value"] = variantData["discount_value"]
    params["final_price"] = variantData["final_price"]
    
    print("param: ====>>\(params)")
    WebService.sharedInstance.editProductService(param: params) { (response) in
      CommonUtils.showToast(message: "Product is updated successfully")
      DispatchQueue.main.async { [weak self] in
        guard let self else { return }
        self.hostVC.navigationController?.popViewController(animated: true)
      }
    }
  }
  
}

extension Bool {
  var toAPI: String {
    return self ? "1" : "0"
  }
}
