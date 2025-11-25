//
//  FilterManagementViewModel.swift
//  DesynatDealer
//
//  Created by fluper on 25/11/25.
//

import Foundation

import Foundation

class FilterManagementViewModel {
  
  private var hostVC: ProductManagementFilterViewController
  var categoriesList: [CategoryDataModel] = []
  var brandsList: [BrandsListDataModel] = []
  
  init(hostVC: ProductManagementFilterViewController) {
    self.hostVC = hostVC
  }
  
//  func getCategoriesListApi(completion: @escaping () -> Void) {
//      WebService.sharedInstance.getCategoriesService { [weak self] list in
//          self?.categoriesList = list
//          completion()
//      }
//  }
//  
//  func getBrandListApi(completion: @escaping () -> Void) {
//      WebService.sharedInstance.getBrandService() { [weak self] list in
//          self?.brandsList = list
//          completion()
//      }
//  }
}
