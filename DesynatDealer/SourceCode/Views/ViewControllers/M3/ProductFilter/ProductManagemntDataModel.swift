//
//  ProductManagemntDataModel.swift
//  DesynatDealer
//
//  Created by fluper on 20/11/25.
//

import Foundation

struct FilterSection {
    var header: String
    var options: [FilterOption]
}

struct FilterOption {
    var id: String
    var title: String
    var isSelected: Bool = false
    var selectedImage: String = "filledCheckbox"
    var unselectedImage: String = "checkBox"
}
