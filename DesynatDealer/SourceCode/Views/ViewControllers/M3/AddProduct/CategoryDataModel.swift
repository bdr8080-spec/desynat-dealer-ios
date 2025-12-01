//
//  CategoryDataModel.swift
//  DesynatDealer
//
//  Created by fluper on 24/11/25.
//

import Foundation
import UIKit

// MARK: - CategoryDataModel
struct CategoryDataModel: Codable {
    let id: Int?
    let name, description: String?
    let image: String?
    let status: Int?
    let colorCode, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, description, image, status
        case colorCode = "color_code"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - SubCategoryDataModel
struct SubCategoryDataModel: Codable {
    let id, categoryID: Int?
    let nameEnglish, nameArabic: String?
    let image: String?
    let status: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "category_id"
        case nameEnglish = "name_english"
        case nameArabic = "name_arabic"
        case image, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


// MARK: - BrandsListDataModel
struct BrandsListDataModel: Codable {
    let id: Int?
    let nameEnglish, nameArabic: String?
    let image: String?
    let status: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case nameEnglish = "name_english"
        case nameArabic = "name_arabic"
        case image, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - ColorsLisDataModel
struct ColorsLisDataModel: Codable {
    let id: Int?
    let name, hexCode: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case hexCode = "hex_code"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - SizeListDataModel
struct SizeListDataModel: Codable {
    var id: Int?
    var name, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - VariantImage
struct VariantImage {
  var image: UIImage?
  var isPlaceholder: Bool
}
