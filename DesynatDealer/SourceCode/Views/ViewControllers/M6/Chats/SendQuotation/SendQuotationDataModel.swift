//
//  SendQuotationDataModel.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 11/01/26.
//

import Foundation

// MARK: - SendQuotationDataModel
struct SendQuotationDataModel: Codable {
    let id: Int?
    let uniqueID, type: String?
    let userID, sellerID: Int?
    let productID, variationID, price, quantity: String?
    let deliveryAddress, shipping, tax, totalAmount: String?
    let customDetails, productRequest, action, createdAt: String?
    let updatedAt: String?
    let productVariation: ProductVariation?

    enum CodingKeys: String, CodingKey {
        case id
        case uniqueID = "unique_id"
        case type
        case userID = "user_id"
        case sellerID = "seller_id"
        case productID = "product_id"
        case variationID = "variation_id"
        case price, quantity
        case deliveryAddress = "delivery_address"
        case shipping, tax
        case totalAmount = "total_amount"
        case customDetails = "custom_details"
        case productRequest = "product_request"
        case action
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case productVariation = "product_variation"
    }
}

