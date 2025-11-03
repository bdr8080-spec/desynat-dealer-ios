//
//  StoreInfoModel.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 03/11/25.
//



// MARK: - StoreInfoModel
struct StoreInfoModel: Codable {
    let sellerID: String?
    let storeImage: String?
    let storeName: String?
    let country: String?
    let storeAddress: String?
    let addressLine1: String?
    let addressLine2: String?
    let storePhone: String?
    let storeMailID: String?
    let bio: String?
    let latitude: String?
    let longitude: String?
    let updatedAt: String?
    let createdAt: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case sellerID = "seller_id"
        case storeImage = "store_image"
        case storeName = "store_name"
        case country
        case storeAddress = "store_address"
        case addressLine1 = "address_line1"
        case addressLine2 = "address_line2"
        case storePhone = "store_phone"
        case storeMailID = "store_mail_id"
        case bio
        case latitude = "let"
        case longitude = "long"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
}
