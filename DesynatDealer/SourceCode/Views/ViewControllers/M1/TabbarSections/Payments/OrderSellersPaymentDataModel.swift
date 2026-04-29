//
//  OrderSellersPaymentDataModel.swift
//  DesynatDealer
//
//  Created by fluper_mac2 on 29/04/26.
//


import Foundation

// MARK: - OrderSellersPaymentDataModel
struct OrderSellersPaymentDataModel: Codable {
    let orders: OrderSellersPaymentData?
    let totalEarning: Double?

    enum CodingKeys: String, CodingKey {
        case orders
        case totalEarning = "total_earning"
    }
}

// MARK: - OrderSellersPaymentData
struct OrderSellersPaymentData: Codable {
    let currentPage: Int?
    let data: [OrdersDataPaymentList]?
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

// MARK: - OrdersDataPaymentList
struct OrdersDataPaymentList: Codable {
    var id: Int?
    var rEType: String?
    var pOrderdetailsId: String?
    var orderId: Int?
    var orderType: String?
    var userId: Int?
    var productId: Int?
    var variantsId: Int?
    var quantity: Int?
    var amount: String?
    var tax: String?
    var shippingFees: String?
    var promocodeId: String?
    var promocodeValue: String?
    var giftcardId: String?
    var giftcardAmount: String?
    var status: String?
    var createdAt: String?
    var updatedAt: String?
    var returnType: String?
    var rEApprove: String?
    var returnReason: String?
    var returnImage: String?
    var exchangeReason: String?
    var exchangeNewSize: String?
    var exchangeOldSize: String?
    var paymentStatus: String?
    var deliveryStatus: String?
    var deliveryBoyId: String?
    var assignStatus: String?
    var assignDate: String?
    var cancelReason: String?
    var isPicked: String?
    var notDeliveredReason: String?
    var sellerId: String?
    var adminCommission: String?
    var orderStatus: String?
    var returnToStore: String?
    var uniqueId: String?
    var referenceLink: String?
    var affiliateId: String?
    var affiliateCommission: String?
    var affiliateAdminCommission: String?

    var userDetails: UserDetails?
    var order: OrderInfo?
    var productDetails: ProductDetails?
    var variationDetails: VariationDetails?
    var exchangeOrderDetails: ExchangeOrderDetails?

    enum CodingKeys: String, CodingKey {
        case id
        case rEType = "r_e_type"
        case pOrderdetailsId = "p_orderdetails_id"
        case orderId = "order_id"
        case orderType = "order_type"
        case userId = "user_id"
        case productId = "product_id"
        case variantsId = "variants_id"
        case quantity
        case amount
        case tax
        case shippingFees = "shipping_fees"
        case promocodeId = "promocode_id"
        case promocodeValue = "promocode_value"
        case giftcardId = "giftcard_id"
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
        case deliveryBoyId = "delivery_boy_id"
        case assignStatus = "assign_status"
        case assignDate = "assign_date"
        case cancelReason = "cancel_reason"
        case isPicked = "is_picked"
        case notDeliveredReason = "not_delivered_reason"
        case sellerId = "seller_id"
        case adminCommission = "admin_commission"
        case orderStatus = "order_status"
        case returnToStore = "returntostore"
        case uniqueId = "unique_id"
        case referenceLink = "reference_link"
        case affiliateId = "affiliate_id"
        case affiliateCommission = "affiliate_commission"
        case affiliateAdminCommission = "affiliate_admin_commission"
        case userDetails = "user_details"
        case order
        case productDetails = "product_details"
        case variationDetails = "variation_details"
        case exchangeOrderDetails = "exchange_order_details"
    }
}

// MARK: - Order Info
struct OrderInfo: Codable {
    var id: Int?
    var orderType: String?
    var orderId: String?
    var userId: Int?
    var deliveryAddress: Int?
    var totalMrp: String?
    var discountMrp: String?
    var shippingFees: String?
    var tax: String?
    var totalAmount: String?
    var paymentStatus: String?
    var paymentMethod: String?
    var deliveryStatus: String?
    var createdAt: String?
    var updatedAt: String?

    var deliveryDetails: DeliveryDetails?

    enum CodingKeys: String, CodingKey {
        case id
        case orderType = "order_type"
        case orderId = "order_id"
        case userId = "user_id"
        case deliveryAddress = "delivery_address"
        case totalMrp = "total_mrp"
        case discountMrp = "discount_mrp"
        case shippingFees = "shipping_fees"
        case tax
        case totalAmount = "total_amount"
        case paymentStatus = "payment_status"
        case paymentMethod = "payment_method"
        case deliveryStatus = "delivery_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deliveryDetails = "delivery_details"
    }
}

// MARK: - ExchangeOrderDetails
struct ExchangeOrderDetails: Codable {
    var id: Int?
    var rEType, pOrderdetailsID: String?
    var orderID, userID, productID, variantsID: Int?
    var quantity: Int?
    var amount, tax, shippingFees: String?
    var promocodeID, promocodeValue, giftcardID, giftcardAmount: String?
    var status, createdAt, updatedAt, returnType: String?
    var rEApprove: String?
    var returnReason, exchangeReason: String?
    var returnImage: [String]?
    var exchangeNewSize: String?
    var exchangeOldSize: String?
    var paymentStatus, deliveryStatus, deliveryBoyID, assignStatus: String?
    var assignDate: String?
    var cancelReason: String?
    var isPicked: String?
    var notDeliveredReason: String?
    var sellerID: String?
    var adminCommission, orderStatus: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case rEType = "r_e_type"
        case pOrderdetailsID = "p_orderdetails_id"
        case orderID = "order_id"
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
    }
    
}


// MARK: - Subcategory
struct Subcategory: Codable {
    var id: Int?
    var nameEnglish: String?
    var nameArabic: String?

    enum CodingKeys: String, CodingKey {
        case id
        case nameEnglish = "name_english"
        case nameArabic = "name_arabic"
    }
}

// MARK: - Size
struct Size: Codable {
    var id: Int?
    var name: String?
}

