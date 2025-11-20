//
//  ProductManagemntDataModel.swift
//  DesynatDealer
//
//  Created by fluper on 20/11/25.
//

import Foundation

struct FilterSection {
  let header: String
  var options: [FilterOption]
}

struct FilterOption {
  let title: String
  var isSelected: Bool = false
  let selectedImage: String = "filledCheckbox"
  let unselectedImage: String = "checkBox"
}
