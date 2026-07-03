//
//  AddNewProductDataModel.swift
//  DesynatDealer
//
//  Created by fluper on 20/11/25.
//

import Foundation
import UIKit

enum ComingReasonAtAddToProduct {
    case forAddingProduct
    case forEditProduct
}

struct Variant {
    var images: [UIImage] = []
    var imageURLs: [String] = []
    var colorId: Int? = -1
    // NEW
    var mediaTypes: [String] = []
    var localVideoURLs: [URL?] = []
    var sizeVariants: [SizeVariant] = [SizeVariant()]
}

struct SizeVariant {
    var sizeId: Int? = -1
    var bust: String = ""
    var waist: String = ""
    var hip: String = ""
    var shoulder: String = ""
    var sleeveLength: String = ""
    var length: String = ""
    var totalStock: String = ""
    var sku: String = ""
    var actualPrice: String = ""
    var discountTypeIsPercentage: Bool = true
    var discountValue: String = ""
    var finalPrice: String = ""
}

struct Spefication {
    var product_spe_en: String = ""
    var product_spe_feature_en: String = ""
    var product_spe_ar: String = ""
    var product_spe_feature_ar: String = ""
}

// MARK: - ExpectedDeliveryTimeDataModel
struct ExpectedDeliveryTimeDataModel: Codable {
    let id: Int?
    let name, nameAr, status, createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case nameAr = "name_ar"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
