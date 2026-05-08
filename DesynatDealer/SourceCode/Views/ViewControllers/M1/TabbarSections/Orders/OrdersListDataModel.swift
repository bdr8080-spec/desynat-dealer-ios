//
//  OrdersListDataModel.swift
//  DesynatDealer
//
//  Created by fluper on 09/01/26.
//

import Foundation

// MARK: - OrdersListDataModel
struct OrdersListDataModel: Codable {
    let allOrder, ongoingOrder: [OrdersListData]?
    let pastOrder: [OrdersListData]?
    
    enum CodingKeys: String, CodingKey {
        case allOrder = "All_order"
        case ongoingOrder = "ongoing_order"
        case pastOrder = "past_order"
    }
}

// MARK: - OrdersListData
struct OrdersListData: Codable {
    let id, orderID, userID, productID: Int?
    let variantsID, quantity: Int?
    let amount, tax, shippingFees, orderType: String?
    let promocodeID, promocodeValue, giftcardID, giftcardAmount: String?
    let status, createdAt, updatedAt, returnType: String?
    let rEApprove: String?
    let returnReason, exchangeReason, exchangeNewSize: String?
    let returnImage: [String]?
    let exchangeOldSize: String?
    let paymentStatus, deliveryStatus: String?
    let deliveryBoyID: String?
    let assignStatus: String?
    let assignDate: String?
    let cancelReason: String?
    let isPicked: String?
    let notDeliveredReason: String?
    let sellerID, adminCommission: String?
    let userDetails: UserDetails?
    let order: Order?
    let productDetails: ProductDetails?
    let variationDetails: VariationDetails?
    let userRatingReviewProvide: UserRatingReviewProvide?
    var chatRoomrecords: ChatRoomrecords?
    
    enum CodingKeys: String, CodingKey {
        case id
        case orderID = "order_id"
        case userID = "user_id"
        case productID = "product_id"
        case orderType = "order_type"
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
        case userDetails = "user_details"
        case order
        case productDetails = "product_details"
        case variationDetails = "variation_details"
        case userRatingReviewProvide = "user_rating_review_provide"
        case chatRoomrecords = "chat_roomrecords"
    }
}

// MARK: - ChatRoomrecords
struct ChatRoomrecords: Codable {
    var id: Int?
    var uniqueID, type: String?
    var userID, sellerID: Int?
    var productID, variationID, price, quantity: String?
    var deliveryAddress, shipping, tax, totalAmount: String?
    var customDetails, productRequest, action, createdAt: String?
    var updatedAt: String?
    
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
    }
}


//// MARK: - Category
//struct Category: Codable {
//    let id: Int?
//    let name, description: String?
//    let image: String?
//    let status: Int?
//    let colorCode, createdAt, updatedAt: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id, name, description, image, status
//        case colorCode = "color_code"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//    }
//}

//// MARK: - Subcategory
//struct Subcategory: Codable {
//    let id, categoryID: Int?
//    let nameEnglish, nameArabic: String?
//    let image: String?
//    let status: Int?
//    let createdAt, updatedAt: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case categoryID = "category_id"
//        case nameEnglish = "name_english"
//        case nameArabic = "name_arabic"
//        case image, status
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//    }
//}


// MARK: - Order
struct Order: Codable {
    let id: Int?
    let orderType, orderID: String?
    let userID, deliveryAddress: Int?
    let totalMrp, discountMrp, promocodeStatus: String?
    let promocodeID, promocodeValue, giftcardAmount, giftcardID: String?
    let shippingFees, tax: String?
    let walletAmount: String?
    let totalAmount, paymentStatus, paymentMethod, deliveryStatus: String?
    let transactionID, deliveryBoyID: String?
    let assignStatus: String?
    let assignDate: String?
    let createdAt, updatedAt: String?
    let cancelReason: String?
    let userDetails: UserDetails?
    let deliveryDetails: DeliveryDetails?
    
    enum CodingKeys: String, CodingKey {
        case id
        case orderType = "order_type"
        case orderID = "order_id"
        case userID = "user_id"
        case deliveryAddress = "delivery_address"
        case totalMrp = "total_mrp"
        case discountMrp = "discount_mrp"
        case promocodeStatus = "promocode_status"
        case promocodeID = "promocode_id"
        case promocodeValue = "promocode_value"
        case giftcardAmount = "giftcard_amount"
        case giftcardID = "giftcard_id"
        case shippingFees = "shipping_fees"
        case tax
        case walletAmount = "wallet_amount"
        case totalAmount = "total_amount"
        case paymentStatus = "payment_status"
        case paymentMethod = "payment_method"
        case deliveryStatus = "delivery_status"
        case transactionID = "transaction_id"
        case deliveryBoyID = "delivery_boy_id"
        case assignStatus = "assign_status"
        case assignDate = "assign_date"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case cancelReason = "cancel_reason"
        case userDetails = "user_details"
        case deliveryDetails = "delivery_details"
    }
}

// MARK: - DeliveryDetails
struct DeliveryDetails: Codable {
    let id, userID: Int?
    let name, mobile, countryCode, address: String?
    let houseNo: String?
    let streetNo: String?
    let postalCode: String?
    let city, state: String?
    let countryName: String?
    let landmark: String?
    let saveAddressAs, status: Int?
    let latitude, longitude, createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case name, mobile
        case countryCode = "country_code"
        case address
        case houseNo = "house_no"
        case streetNo = "street_no"
        case postalCode = "postal_code"
        case city, state
        case countryName = "country_name"
        case landmark
        case saveAddressAs = "save_address_as"
        case status, latitude, longitude
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - UserDetails
struct UserDetails: Codable {
    let id: Int?
    let profileImage: String?
    let fullName, countryCode, mobile, email: String?
    let emailVerifiedAt, otp: String?
    let otpVerify: String?
//    let otpVerify, deviceType: String?
    let deviceToken, userDetailsLet, long: String?
    let status, createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case profileImage = "profile_image"
        case fullName = "full_name"
        case countryCode = "country_code"
        case mobile, email
        case emailVerifiedAt = "email_verified_at"
        case otp
        case otpVerify = "otp_verify"
//        case deviceType = "device_type"
        case deviceToken = "device_token"
        case userDetailsLet = "let"
        case long, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - ProductDetails
struct ProductDetails: Codable {
    let id: Int?
    let sellerID, storeID, categoryID, subcategoryID: String?
    let brandID: String?
    let otherEn, otherAr: String?
    let productNameEn, productNameAr, descriptionEn, descriptionAr: String?
    let minCardQuantity, maxCardQuantity, productReturn: String?
    let returnDays: String?
    let productExchangable: String?
    let exchangableDays: String?
    let reviewRating, affiliatedProduct: String?
    let affiliatedCommission: String?
    let customizedProduct, readyToShip, cashOnDelivery: String?
    let uploadSizeChart: String?
    let productActiveStatus: Int?
    let createdAt, updatedAt: String?
    let category: Category?
    let subcategory: SubcategoryDetails?
    let brand: Brand?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case sellerID = "seller_id"
        case storeID = "store_id"
        case categoryID = "category_id"
        case subcategoryID = "subcategory_id"
        case brandID = "brand_id"
        case otherEn = "other_en"
        case otherAr = "other_ar"
        case productNameEn = "product_name_en"
        case productNameAr = "product_name_ar"
        case descriptionEn = "description_en"
        case descriptionAr = "description_ar"
        case minCardQuantity = "min_card_quantity"
        case maxCardQuantity = "max_card_quantity"
        case productReturn = "product_return"
        case returnDays = "return_days"
        case productExchangable = "product_exchangable"
        case exchangableDays = "exchangable_days"
        case reviewRating = "review_rating"
        case affiliatedProduct = "affiliated_product"
        case affiliatedCommission = "affiliated_commission"
        case customizedProduct = "customized_product"
        case readyToShip = "ready_to_ship"
        case cashOnDelivery = "cash_on_delivery"
        case uploadSizeChart = "upload_size_chart"
        case productActiveStatus = "product_active_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case category, subcategory, brand
    }
}

// MARK: - VariationDetails
struct VariationDetails: Codable {
    let id, productID: Int?
    let parentChild: String?
    let variantImage: [String]?
    let colorID, sizeID, bust, waist: String?
    let hip, shoulder, sleeveLength, length: String?
    let totalStock, sku: String?
    let skuThresholdValue: String?
    let actualPrice, discountType, discountValue, finalPrice: String?
    let status, createdAt, updatedAt: String?
    let color, size: SizeDetails?
    
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
        case color, size
    }
}

// MARK: - SizeDetails
struct SizeDetails: Codable {
    let id: Int?
    let name,nameAr, hexCode, createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case hexCode = "hex_code"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case nameAr = "name_ar"
    }
}

// MARK: - UserRatingReviewProvide
struct UserRatingReviewProvide: Codable {
    let id, userID, orderID, orderdetailsID: Int?
    let productID: Int?
    let productRating: String?
    let productReview: String?
    let productImage: String?
    let storeID: Int?
    let storeRating: String?
    let storeReview: String?
    let storeImage, createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case orderID = "order_id"
        case orderdetailsID = "orderdetails_id"
        case productID = "product_id"
        case productRating = "product_rating"
        case productReview = "product_review"
        case productImage = "product_image"
        case storeID = "store_id"
        case storeRating = "store_rating"
        case storeReview = "store_review"
        case storeImage = "store_image"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
