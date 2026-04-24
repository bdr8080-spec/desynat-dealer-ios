//
//  RefundManagementDataModel.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 24/04/26.
//

import Foundation

// MARK: - RefundManagementDataModel
struct RefundManagementDataModel: Codable {
    let orders: RefundManagementData?
    let totalRefunds: Double?

    enum CodingKeys: String, CodingKey {
        case orders
        case totalRefunds = "total_refunds"
    }
}

// MARK: - RefundManagementDataModel
struct RefundManagementData: Codable {
    let currentPage: Int?
    let data: [RefundManagementList]?
    let firstPageURL: String?
    let from, lastPage: Int?
    let lastPageURL: String?
    let links: [Link]?
    let nextPageURL: String?
    let path: String?
    let perPage: Int?
    let prevPageURL: String?
    let to, total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case links
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to, total
    }
}

// MARK: - RefundManagementList
struct RefundManagementList: Codable {
    let id: Int?
    let rEType, pOrderdetailsID: String?
    let orderID: Int?
    let orderType: String?
    let userID, productID, variantsID, quantity: Int?
    let amount, tax, shippingFees: String?
    let promocodeID, promocodeValue, giftcardID, giftcardAmount: String?
    let status, createdAt, updatedAt, returnType: String?
    let rEApprove: String?
    let returnReason, returnImage, exchangeReason, exchangeNewSize: String?
    let exchangeOldSize: String?
    let paymentStatus, deliveryStatus: String?
    let deliveryBoyID: String?
    let assignStatus: String?
    let assignDate: String?
    let cancelReason: String?
    let isPicked: String?
    let notDeliveredReason: String?
    let sellerID: String?
    let adminCommission, orderStatus: String?
    let returntostore: String?
    let uniqueID, referenceLink, affiliateID: String?
    let affiliateCommission, affiliateAdminCommission: String?
    let order: Order?
    let productDetails: ProductDetails?
    let variationDetails: VariationDetails?
    let userRatingReviewProvide, driverDetails: String?

    enum CodingKeys: String, CodingKey {
        case id
        case rEType = "r_e_type"
        case pOrderdetailsID = "p_orderdetails_id"
        case orderID = "order_id"
        case orderType = "order_type"
        case userID = "user_id"
        case productID = "product_id"
        case variantsID = "variants_id"
        case quantity, amount, tax
        case shippingFees = "shipping_fees"
        case promocodeID = "promocode_id"
        case promocodeValue = "promocode_value"
        case giftcardID = "giftcard_id"
        case giftcardAmount = "giftcard_amount"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case returnType = "return_type"
        case rEApprove = "r_e_approve"
        case returnReason = "return_reason"
        case returnImage = "return_image"
        case exchangeReason = "exchange_reason"
        case exchangeNewSize = "exchange_new_size"
        case exchangeOldSize = "exchange_old_size"
        case paymentStatus = "payment_status"
        case deliveryStatus = "delivery_status"
        case deliveryBoyID = "delivery_boy_id"
        case assignStatus = "assign_status"
        case assignDate = "assign_date"
        case cancelReason = "cancel_reason"
        case isPicked = "is_picked"
        case notDeliveredReason = "not_delivered_reason"
        case sellerID = "seller_id"
        case adminCommission = "admin_commission"
        case orderStatus = "order_status"
        case returntostore
        case uniqueID = "unique_id"
        case referenceLink = "reference_link"
        case affiliateID = "affiliate_id"
        case affiliateCommission = "affiliate_commission"
        case affiliateAdminCommission = "affiliate_admin_commission"
        case order
        case productDetails = "product_details"
        case variationDetails = "variation_details"
        case userRatingReviewProvide = "user_rating_review_provide"
        case driverDetails = "driver_details"
    }
}
