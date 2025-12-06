//
//  InventoryListDataModel.swift
//  DesynatDealer
//
//  Created by fluper on 06/12/25.
//

import Foundation

// MARK: - InventoryListDataModel
struct InventoryListDataModel: Codable {
    let allProductCount, activeProductCount, inactiveProductCount: Int?
    var allProductData, activeProduct: [ProductsList]?
    var inactiveProduct: [ProductsList]?

    enum CodingKeys: String, CodingKey {
        case allProductCount = "all_product_count"
        case activeProductCount = "active_product_count"
        case inactiveProductCount = "inactive_product_count"
        case allProductData = "all_product_data"
        case activeProduct = "active_product"
        case inactiveProduct = "inactive_product"
    }
}

// MARK: - ActiveProduct
//struct ActiveProduct: Codable {
//    let id: Int?
//    let sellerID, storeID, categoryID, subcategoryID: String?
//    let brandID: String?
//    let otherEn, otherAr: String?
//    let productNameEn: String?
//    let productNameAr: String?
//    let descriptionEn: String?
//    let descriptionAr: String?
//    let minCardQuantity, maxCardQuantity, productReturn: String?
//    let returnDays: String?
//    let productExchangable, exchangableDays, reviewRating, affiliatedProduct: String?
//    let customizedProduct, readyToShip, cashOnDelivery: String?
//    let uploadSizeChart: String?
//    var productActiveStatus: Int?
//    let createdAt, updatedAt: String?
//    let stock: String?
//    let category: Category?
//    let subcategory, brand: Brand?
//    let productSpecifications: [ProductSpecification]?
//    let productVariants: [ProductVariant]?
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
//        case customizedProduct = "customized_product"
//        case readyToShip = "ready_to_ship"
//        case cashOnDelivery = "cash_on_delivery"
//        case uploadSizeChart = "upload_size_chart"
//        case productActiveStatus = "product_active_status"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case stock, category, subcategory, brand
//        case productSpecifications = "product_specifications"
//        case productVariants = "product_variants"
//    }
//}
