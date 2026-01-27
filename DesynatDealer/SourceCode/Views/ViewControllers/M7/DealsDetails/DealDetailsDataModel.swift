//
//  DealDetailsDataModel.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 23/01/26.
//

import Foundation

// MARK: - DealsDetailsDataModel
struct DealsDetailsDataModel: Codable {
    let dealData: DealData?
    let addedProducts: [AddedProductInDeal]?
    let remainingProduct: [ProductsList]?

    enum CodingKeys: String, CodingKey {
        case dealData = "deal_data"
        case addedProducts = "added_products"
        case remainingProduct = "remaining_Product"
    }
}

// MARK: - DealData
struct DealData: Codable {
    let id: Int?
    let image: String?
    let nameEnglish, nameArabic: String?
    let categoryID, subCategoryID: Int?
    let discount, from, to: String?
    let status: Int?
    let createdAt, updatedAt: String?
    let categoryDetails: Category?
    let subCategoryDetails: SubcategoryDetails?

    enum CodingKeys: String, CodingKey {
        case id, image
        case nameEnglish = "name_english"
        case nameArabic = "name_arabic"
        case categoryID = "category_id"
        case subCategoryID = "sub_category_id"
        case discount, from, to, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case categoryDetails = "category_details"
        case subCategoryDetails = "sub_category_details"
    }
}

// MARK: - AddedProductInDeal
struct AddedProductInDeal: Codable {
    let id, dealID: Int?
    let sellerID: String?
    let productID: Int?
    let discount, createdAt, updatedAt: String?
    let productDetails: DealAddedProductDetails?

    enum CodingKeys: String, CodingKey {
        case id
        case dealID = "deal_id"
        case sellerID = "seller_id"
        case productID = "product_id"
        case discount
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case productDetails = "product_details"
    }
}

// MARK: - DealAddedProductDetails
struct DealAddedProductDetails: Codable {
    let id: Int?
    let sellerID, storeID, categoryID, subcategoryID: String?
    let brandID, otherEn, otherAr, productNameEn: String?
    let productNameAr, descriptionEn, descriptionAr, minCardQuantity: String?
    let maxCardQuantity, productReturn, returnDays, productExchangable: String?
    let exchangableDays, reviewRating, affiliatedProduct, affiliatedCommission: String?
    let customizedProduct, readyToShip, cashOnDelivery: String?
    let uploadSizeChart: String?
    let productActiveStatus, avgProductRating: Int?
    let createdAt, updatedAt: String?
    let category: Category?
    let subcategory, brand: SubCategoryDataModel?
    let productSpecifications: [ProductSpecification]?
    let productVariants: [ProductVariant]?

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
        case avgProductRating = "avg_product_rating"
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
        case productSpecifications = "product_specifications"
        case productVariants = "product_variants"
    }
}
