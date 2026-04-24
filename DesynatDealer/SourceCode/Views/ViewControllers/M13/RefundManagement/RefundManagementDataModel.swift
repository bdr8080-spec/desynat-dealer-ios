//
//  RefundManagementDataModel.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 24/04/26.
//

import Foundation

// MARK: - RefundManagementDataModel
//struct RefundManagementDataModel: Codable {
//    let currentPage: Int?
//    let data: [RefundManagementList]?
//    let firstPageURL: String?
//    let from, lastPage: Int?
//    let lastPageURL: String?
//    let links: [Link]?
//    let nextPageURL: String?
//    let path: String?
//    let perPage: Int?
//    let prevPageURL: String?
//    let to, total: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case currentPage = "current_page"
//        case data
//        case firstPageURL = "first_page_url"
//        case from
//        case lastPage = "last_page"
//        case lastPageURL = "last_page_url"
//        case links
//        case nextPageURL = "next_page_url"
//        case path
//        case perPage = "per_page"
//        case prevPageURL = "prev_page_url"
//        case to, total
//    }
//}
//
//// MARK: - RefundManagementList
//struct RefundManagementList: Codable {
//    let id: Int?
//    let rEType, pOrderdetailsID: String?
//    let orderID: Int?
//    let orderType: String?
//    let userID, productID, variantsID, quantity: Int?
//    let amount, tax, shippingFees: String?
//    let promocodeID, promocodeValue, giftcardID, giftcardAmount: String?
//    let status, createdAt, updatedAt, returnType: String?
//    let rEApprove: String?
//    let returnReason, returnImage, exchangeReason, exchangeNewSize: String?
//    let exchangeOldSize: String?
//    let paymentStatus, deliveryStatus: String?
//    let deliveryBoyID: String?
//    let assignStatus: String?
//    let assignDate: String?
//    let cancelReason: String?
//    let isPicked: String?
//    let notDeliveredReason: String?
//    let sellerID: String?
//    let adminCommission, orderStatus: String?
//    let returntostore: String?
//    let uniqueID, referenceLink, affiliateID: String?
//    let affiliateCommission, affiliateAdminCommission: String?
//    let order: Order?
//    let productDetails: ProductDetails?
//    let variationDetails: VariationDetails?
//    let userRatingReviewProvide, driverDetails: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case rEType = "r_e_type"
//        case pOrderdetailsID = "p_orderdetails_id"
//        case orderID = "order_id"
//        case orderType = "order_type"
//        case userID = "user_id"
//        case productID = "product_id"
//        case variantsID = "variants_id"
//        case quantity, amount, tax
//        case shippingFees = "shipping_fees"
//        case promocodeID = "promocode_id"
//        case promocodeValue = "promocode_value"
//        case giftcardID = "giftcard_id"
//        case giftcardAmount = "giftcard_amount"
//        case status
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case returnType = "return_type"
//        case rEApprove = "r_e_approve"
//        case returnReason = "return_reason"
//        case returnImage = "return_image"
//        case exchangeReason = "exchange_reason"
//        case exchangeNewSize = "exchange_new_size"
//        case exchangeOldSize = "exchange_old_size"
//        case paymentStatus = "payment_status"
//        case deliveryStatus = "delivery_status"
//        case deliveryBoyID = "delivery_boy_id"
//        case assignStatus = "assign_status"
//        case assignDate = "assign_date"
//        case cancelReason = "cancel_reason"
//        case isPicked = "is_picked"
//        case notDeliveredReason = "not_delivered_reason"
//        case sellerID = "seller_id"
//        case adminCommission = "admin_commission"
//        case orderStatus = "order_status"
//        case returntostore
//        case uniqueID = "unique_id"
//        case referenceLink = "reference_link"
//        case affiliateID = "affiliate_id"
//        case affiliateCommission = "affiliate_commission"
//        case affiliateAdminCommission = "affiliate_admin_commission"
//        case order
//        case productDetails = "product_details"
//        case variationDetails = "variation_details"
//        case userRatingReviewProvide = "user_rating_review_provide"
//        case driverDetails = "driver_details"
//    }
//}
//
//// MARK: - Order
//struct Order: Codable {
//    let id: Int?
//    let orderType, orderID: String?
//    let userID, deliveryAddress: Int?
//    let totalMrp, discountMrp, promocodeStatus: String?
//    let promocodeID, promocodeValue: String?
//    let giftcardAmount: String?
//    let giftcardID: String?
//    let shippingFees, tax: String?
//    let walletAmount: String?
//    let totalAmount, paymentStatus, paymentMethod, deliveryStatus: String?
//    let transactionID: String?
//    let deliveryBoyID: String?
//    let assignStatus: String?
//    let assignDate: String?
//    let createdAt, updatedAt: String?
//    let cancelReason: String?
//    let uniqueID: String?
//    let deliveryDetails: DeliveryDetails?
//    let giftCardDetails, promocodeDetails: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case orderType = "order_type"
//        case orderID = "order_id"
//        case userID = "user_id"
//        case deliveryAddress = "delivery_address"
//        case totalMrp = "total_mrp"
//        case discountMrp = "discount_mrp"
//        case promocodeStatus = "promocode_status"
//        case promocodeID = "promocode_id"
//        case promocodeValue = "promocode_value"
//        case giftcardAmount = "giftcard_amount"
//        case giftcardID = "giftcard_id"
//        case shippingFees = "shipping_fees"
//        case tax
//        case walletAmount = "wallet_amount"
//        case totalAmount = "total_amount"
//        case paymentStatus = "payment_status"
//        case paymentMethod = "payment_method"
//        case deliveryStatus = "delivery_status"
//        case transactionID = "transaction_id"
//        case deliveryBoyID = "delivery_boy_id"
//        case assignStatus = "assign_status"
//        case assignDate = "assign_date"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case cancelReason = "cancel_reason"
//        case uniqueID = "unique_id"
//        case deliveryDetails = "delivery_details"
//        case giftCardDetails = "gift_card_details"
//        case promocodeDetails = "promocode_details"
//    }
//}
//
//// MARK: - DeliveryDetails
//struct DeliveryDetails: Codable {
//    let id, userID: Int?
//    let name, mobile, countryCode, address: String?
//    let houseNo: String?
//    let streetNo: String?
//    let postalCode: String?
//    let city, state, countryName: String?
//    let landmark: String?
//    let saveAddressAs, status: Int?
//    let latitude, longitude: String?
//    let createdAt, updatedAt: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case userID = "user_id"
//        case name, mobile
//        case countryCode = "country_code"
//        case address
//        case houseNo = "house_no"
//        case streetNo = "street_no"
//        case postalCode = "postal_code"
//        case city, state
//        case countryName = "country_name"
//        case landmark
//        case saveAddressAs = "save_address_as"
//        case status, latitude, longitude
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//    }
//}
//
//// MARK: - ProductDetails
//struct ProductDetails: Codable {
//    let id: Int?
//    let sellerID, storeID, categoryID, subcategoryID: String?
//    let brandID: String?
//    let otherEn, otherAr: String?
//    let productNameEn, productNameAr, descriptionEn, descriptionAr: String?
//    let minCardQuantity, maxCardQuantity, productReturn, returnDays: String?
//    let productExchangable, exchangableDays, reviewRating, affiliatedProduct: String?
//    let affiliatedCommission: String?
//    let customizedProduct, readyToShip, cashOnDelivery: String?
//    let uploadSizeChart: String?
//    let productActiveStatus: Int?
//    let createdAt, updatedAt: String?
//    let brand: Brand?
//    let category: Category?
//    let subcategory: Brand?
//    let sellerDetails: SellerDetails?
//    let store: Store?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case sellerID = "seller_id"
//        case storeID = "store_id"
//        case categoryID = "category_id"
//        case subcategoryID = "subcategory_id"
//        case brandID = "brand_id"
//        case otherEn = "other_en"
//        case otherAr = "other_ar"
//        case productNameEn = "product_name_en"
//        case productNameAr = "product_name_ar"
//        case descriptionEn = "description_en"
//        case descriptionAr = "description_ar"
//        case minCardQuantity = "min_card_quantity"
//        case maxCardQuantity = "max_card_quantity"
//        case productReturn = "product_return"
//        case returnDays = "return_days"
//        case productExchangable = "product_exchangable"
//        case exchangableDays = "exchangable_days"
//        case reviewRating = "review_rating"
//        case affiliatedProduct = "affiliated_product"
//        case affiliatedCommission = "affiliated_commission"
//        case customizedProduct = "customized_product"
//        case readyToShip = "ready_to_ship"
//        case cashOnDelivery = "cash_on_delivery"
//        case uploadSizeChart = "upload_size_chart"
//        case productActiveStatus = "product_active_status"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case brand, category, subcategory
//        case sellerDetails = "seller_details"
//        case store
//    }
//}
//
//// MARK: - Brand
//struct Brand: Codable {
//    let id: Int?
//    let nameEnglish, nameArabic: String?
//    let image: String?
//    let status: Int?
//    let createdAt, updatedAt: String?
//    let categoryID: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case nameEnglish = "name_english"
//        case nameArabic = "name_arabic"
//        case image, status
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case categoryID = "category_id"
//    }
//}
//
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
//
//// MARK: - SellerDetails
//struct SellerDetails: Codable {
//    let id: Int?
//    let type: String?
//    let parentID: String?
//    let profilePic: String?
//    let firstName, lastName, countryCode, mobile: String?
//    let email, password, acceptTerms, otp: String?
//    let otpVerify, deviceType: String?
//    let deviceToken: String?
//    let adminVerify, storeInformation, bankInformation: String?
//    let rejectReason, lang: String?
//    let isBlock: Int?
//    let affilateCommission: String?
//    let fcmToken: String?
//    let profileQr: String?
//    let qrSellerURL: String?
//    let createdAt, updatedAt: String?
//    let notification, appNotification: Int?
//    let nameAr, selectCategory, savePassword: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id, type
//        case parentID = "parent_id"
//        case profilePic = "profile_pic"
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case countryCode = "country_code"
//        case mobile, email, password
//        case acceptTerms = "accept_terms"
//        case otp
//        case otpVerify = "otp_verify"
//        case deviceType = "device_type"
//        case deviceToken = "device_token"
//        case adminVerify = "admin_verify"
//        case storeInformation = "store_information"
//        case bankInformation = "bank_information"
//        case rejectReason = "reject_reason"
//        case lang
//        case isBlock = "is_block"
//        case affilateCommission = "affilate_commission"
//        case fcmToken = "fcm_token"
//        case profileQr = "profile_qr"
//        case qrSellerURL = "qrSellerUrl"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case notification
//        case appNotification = "app_notification"
//        case nameAr = "name_ar"
//        case selectCategory = "select_category"
//        case savePassword = "save_password"
//    }
//}
//
//// MARK: - Store
//struct Store: Codable {
//    let id, sellerID: Int?
//    let storeImage: String?
//    let storeName, country, storeAddress, addressLine1: String?
//    let addressLine2, storePhone, countryCode, storeMailID: String?
//    let storeAvailability: Int?
//    let bio, storeLet, long, createdAt: String?
//    let updatedAt: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case sellerID = "seller_id"
//        case storeImage = "store_image"
//        case storeName = "store_name"
//        case country
//        case storeAddress = "store_address"
//        case addressLine1 = "address_line1"
//        case addressLine2 = "address_line2"
//        case storePhone = "store_phone"
//        case countryCode = "country_code"
//        case storeMailID = "store_mail_id"
//        case storeAvailability = "Store_Availability"
//        case bio
//        case storeLet = "let"
//        case long
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//    }
//}
//
//// MARK: - VariationDetails
//struct VariationDetails: Codable {
//    let id, productID: Int?
//    let parentChild: String?
//    let variantImage: [String]?
//    let colorID, sizeID: String?
//    let bust, waist, hip, shoulder: String?
//    let sleeveLength, length: String?
//    let totalStock, sku: String?
//    let skuThresholdValue: String?
//    let actualPrice, discountType, discountValue, finalPrice: String?
//    let status, createdAt, updatedAt: String?
//    let color, size: Color?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case productID = "product_id"
//        case parentChild = "parent_child"
//        case variantImage = "variant_image"
//        case colorID = "color_id"
//        case sizeID = "size_id"
//        case bust, waist, hip, shoulder
//        case sleeveLength = "sleeve_length"
//        case length
//        case totalStock = "total_stock"
//        case sku
//        case skuThresholdValue = "sku_threshold_value"
//        case actualPrice = "actual_price"
//        case discountType = "discount_type"
//        case discountValue = "discount_value"
//        case finalPrice = "final_price"
//        case status
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case color, size
//    }
//}
//
//// MARK: - Color
//struct Color: Codable {
//    let id: Int?
//    let name, hexCode, createdAt, updatedAt: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id, name
//        case hexCode = "hex_code"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//    }
//}
