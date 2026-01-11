//
//  ChatInboxListDataModel.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 11/01/26.
//

import Foundation

struct ChatInboxListModel: Codable {
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

// MARK: - ProductVariation
struct ProductVariation: Codable {
    let id, productID: Int?
    let parentChild: String?
    let variantImage: [String]?
    let colorID, sizeID: String?
    let bust, waist, hip, shoulder: String?
    let sleeveLength, length: String?
    let totalStock, sku: String?
    let skuThresholdValue: String?
    let actualPrice, discountType, discountValue, finalPrice: String?
    let status, createdAt, updatedAt: String?
    let productDetails: ProductDetails?
    
    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case parentChild = "parent_child"
        case variantImage = "variant_image"
        case colorID = "color_id"
        case sizeID = "size_id"
        case bust, waist, hip, shoulder
        case sleeveLength = "sleeve_length"
        case length
        case totalStock = "total_stock"
        case sku
        case skuThresholdValue = "sku_threshold_value"
        case actualPrice = "actual_price"
        case discountType = "discount_type"
        case discountValue = "discount_value"
        case finalPrice = "final_price"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case productDetails = "product_details"
    }
}
