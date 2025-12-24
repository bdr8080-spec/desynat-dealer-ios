//
//  BannerModel.swift
//  DesynatDealer
//
//  Created by fluper on 18/12/25.
//

// MARK: - BannerModel
struct BannerModel: Codable {
    let id: Int?
    let orderID: String?
    let sellerID: Int?
    let bannerPosition: String?
    let category, subcatgory: String?
    let startDate, endDate, totalDays, uploadBanner: String?
    let price, adminVerify, paymentStatus: String?
    let transactionID, cancelledReason: String?
    let createdAt, updatedAt: String?
    let categoryDetails: CategoryDetails?
    let subcategoryDetails: SubcategoryDetails?

    enum CodingKeys: String, CodingKey {
        case id
        case orderID = "order_id"
        case sellerID = "seller_id"
        case bannerPosition = "banner_position"
        case category, subcatgory
        case startDate = "start_date"
        case endDate = "end_date"
        case totalDays = "total_days"
        case uploadBanner = "upload_banner"
        case price
        case adminVerify = "Admin_verify"
        case paymentStatus = "payment_status"
        case transactionID = "transaction_id"
        case cancelledReason = "cancelled_reason"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case categoryDetails = "category_details"
        case subcategoryDetails = "subcategory_details"
    }
}

// MARK: CategoryDetails
struct CategoryDetails: Codable {
    let id: Int?
    let name, description: String?
    let image: String?
    let status: Int?
    let colorCode, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, description, image, status
        case colorCode = "color_code"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: SubcategoryDetails
struct SubcategoryDetails: Codable {
    let id, categoryID: Int?
    let nameEnglish, nameArabic: String?
    let image: String?
    let status: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "category_id"
        case nameEnglish = "name_english"
        case nameArabic = "name_arabic"
        case image, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - PriceModel
struct PriceModel: Codable {
    let id, countryID, type: Int?
    let perDayPrice, createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case countryID = "country_id"
        case type
        case perDayPrice = "per_day_price"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct BannerFilterModel {
    var fromDate: String?
    var toDate: String?
    var statusIds: [Int] = []
}
