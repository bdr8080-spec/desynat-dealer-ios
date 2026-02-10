//
//  ChatDetailsDataMode.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 11/01/26.
//

import Foundation

enum ComingReasonAtChatScreen {
    case quotationSentForFirstTime
    case doModificationAfterQuotationSent
}

// MARK: - ChatDetailsDataModel
struct ChatDetailsDataModel: Codable {
  let record: Record?

  enum CodingKeys: String, CodingKey {
      case record
  }
}

// MARK: - Record
struct Record: Codable {
  let id: Int?
  let uniqueID, type: String?
  let userID, sellerID: Int?
  let productID, variationID, price, quantity: String?
  let deliveryAddress, shipping, tax, totalAmount: String?
  let customDetails, productRequest, action, createdAt: String?
  let updatedAt: String?
  let productVariation: ProductVariation?
  let userDetails: UserDetails?
  let sellerDetails: UserDetails?
  let deliveryDetails: DeliveryDetails?
  let orderCreateStatus: OrderCreateStatus?

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
      case userDetails = "user_details"
      case sellerDetails = "seller_details"
      case deliveryDetails = "delivery_details"
      case orderCreateStatus = "order_create_status"
  }
}

// MARK: - Welcome
struct OrderCreateStatus: Codable {
    let id: Int?
//    let orderType, orderID: String?
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
    let uniqueID: String?

    enum CodingKeys: String, CodingKey {
        case id
//        case orderType = "order_type"
//        case orderID = "order_id"
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
        case uniqueID = "unique_id"
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
  let size, color: Color?

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
    case size, color
  }
}

// MARK: - Color
struct Color: Codable {
    let id: Int?
    let name, hexCode, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case hexCode = "hex_code"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
      
    }
}

// MARK: - DeliveryDetails
//struct DeliveryDetails: Codable {
//    let id, userID: Int?
//    let name, mobile, countryCode, address: String?
//    let houseNo: String?
//    let streetNo: String?
//    let postalCode, city, state, countryName: String?
//    let landmark: String?
//    let saveAddressAs, status: Int?
//    let setAsDefault, latitude, longitude, createdAt: String?
//    let updatedAt: String?
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
//        case status
//        case setAsDefault = "set_as_default"
//        case latitude, longitude
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//    }
//}

//// MARK: - ProductDetails
//struct ProductDetails: Codable {
//  let id: Int?
//  let sellerID, storeID, categoryID, subcategoryID: String?
//  let brandID: String?
//  let otherEn, otherAr: String?
//  let productNameEn, productNameAr, descriptionEn, descriptionAr: String?
//  let minCardQuantity, maxCardQuantity, productReturn: String?
//  let returnDays: String?
//  let productExchangable: String?
//  let exchangableDays: String?
//  let reviewRating, affiliatedProduct, affiliatedCommission, customizedProduct: String?
//  let readyToShip, cashOnDelivery: String?
//  let uploadSizeChart: String?
//  let productActiveStatus: Int?
//  let createdAt, updatedAt: String?
//
//  enum CodingKeys: String, CodingKey {
//      case id
//      case sellerID = "seller_id"
//      case storeID = "store_id"
//      case categoryID = "category_id"
//      case subcategoryID = "subcategory_id"
//      case brandID = "brand_id"
//      case otherEn = "other_en"
//      case otherAr = "other_ar"
//      case productNameEn = "product_name_en"
//      case productNameAr = "product_name_ar"
//      case descriptionEn = "description_en"
//      case descriptionAr = "description_ar"
//      case minCardQuantity = "min_card_quantity"
//      case maxCardQuantity = "max_card_quantity"
//      case productReturn = "product_return"
//      case returnDays = "return_days"
//      case productExchangable = "product_exchangable"
//      case exchangableDays = "exchangable_days"
//      case reviewRating = "review_rating"
//      case affiliatedProduct = "affiliated_product"
//      case affiliatedCommission = "affiliated_commission"
//      case customizedProduct = "customized_product"
//      case readyToShip = "ready_to_ship"
//      case cashOnDelivery = "cash_on_delivery"
//      case uploadSizeChart = "upload_size_chart"
//      case productActiveStatus = "product_active_status"
//      case createdAt = "created_at"
//      case updatedAt = "updated_at"
//  }
//}
//
