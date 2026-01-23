//
//  DealManagemnetListDataModel.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 23/01/26.
//

import Foundation

// MARK: - DealsListDataModel
struct DealsListDataModel: Codable {
    let listedDeal: [ListedDeal]?
    let enrolled, expiredDeal: [ListedDeal]?
    
    enum CodingKeys: String, CodingKey {
        case listedDeal = "listed_deal"
        case enrolled
        case expiredDeal = "expired_deal"
    }
}

// MARK: - ListedDeal
struct ListedDeal: Codable {
    let id: Int?
    let image: String?
    let nameEnglish, nameArabic: String?
    let categoryID, subCategoryID: Int?
    let discount, from, to: String?
    let status: Int?
    let createdAt, updatedAt: String?
    let sellerDealCount: Int?
    let sellerDealrecord: SellerDealrecord?
    
    enum CodingKeys: String, CodingKey {
        case id, image
        case nameEnglish = "name_english"
        case nameArabic = "name_arabic"
        case categoryID = "category_id"
        case subCategoryID = "sub_category_id"
        case discount, from, to, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case sellerDealCount = "seller_deal_count"
        case sellerDealrecord = "seller_dealrecord"
    }
}

// MARK: - SellerDealrecord
struct SellerDealrecord: Codable {
    let id, dealID, sellerID, productID: Int?
    let discount, createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case dealID = "deal_id"
        case sellerID = "seller_id"
        case productID = "product_id"
        case discount
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
