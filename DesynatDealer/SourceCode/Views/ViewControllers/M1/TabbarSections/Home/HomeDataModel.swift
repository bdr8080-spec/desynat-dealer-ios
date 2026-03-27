//
//  HomeDataModel.swift
//  DesynatDealer
//
//  Created by fluper on 24/11/25.
//

import Foundation

// MARK: - StoreAvailabilityStatusModel
struct StoreAvailabilityStatusModel: Codable {
    let id, sellerID: Int?
    let storeImage: String?
    let storeName, country, storeAddress, addressLine1: String?
    let addressLine2, storePhone, countryCode, storeMailID: String?
    let storeAvailability: Int?
    let bio, dataLet, long, createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case sellerID = "seller_id"
        case storeImage = "store_image"
        case storeName = "store_name"
        case country
        case storeAddress = "store_address"
        case addressLine1 = "address_line1"
        case addressLine2 = "address_line2"
        case storePhone = "store_phone"
        case countryCode = "country_code"
        case storeMailID = "store_mail_id"
        case storeAvailability = "Store_Availability"
        case bio
        case dataLet = "let"
        case long
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
