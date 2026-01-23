//
//  DealDetailsDataModel.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 23/01/26.
//

import Foundation

// MARK: - DealsDetailsDataModel
struct DealsDetailsDataModel: Codable {
    let dealData: DealData?
    let addedProducts: [ProductsList]?
    let remainingProduct: [ProductsList]?

    enum CodingKeys: String, CodingKey {
        case dealData = "deal_data"
        case addedProducts = "added_products"
        case remainingProduct = "remaining_Product"
    }
}

// MARK: - DealData
struct DealData: Codable {
    let id: Int?
    let image: String?
    let nameEnglish, nameArabic: String?
    let categoryID, subCategoryID: Int?
    let discount, from, to: String?
    let status: Int?
    let createdAt, updatedAt: String?
    let categoryDetails: Category?
    let subCategoryDetails: SubcategoryDetails?

    enum CodingKeys: String, CodingKey {
        case id, image
        case nameEnglish = "name_english"
        case nameArabic = "name_arabic"
        case categoryID = "category_id"
        case subCategoryID = "sub_category_id"
        case discount, from, to, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case categoryDetails = "category_details"
        case subCategoryDetails = "sub_category_details"
    }
}
