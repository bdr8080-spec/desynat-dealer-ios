//
//  MySubscriptionPlanDataModel.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 20/03/26.
//

import Foundation

// MARK: - MySubscriptionPlanDataModel
struct MySubscriptionPlanDataModel: Codable {
    let currentPage: Int?
    let data: [MySubscriptionPlanList]?
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

// MARK: - MySubscriptionPlanList
struct MySubscriptionPlanList: Codable {
    let id: Int?
    let transactionID: String?
    let sellerID, planID: Int?
    let status, planStartDate, planEndDate, amount: String?
    let isExpired: String?
    let onlineTransactionID: String?
    let paymentMethod, paymentStatus, createdAt, updatedAt: String?
    let planInfo: PlanInfo?

    enum CodingKeys: String, CodingKey {
        case id
        case transactionID = "transaction_id"
        case sellerID = "seller_id"
        case planID = "plan_id"
        case status
        case planStartDate = "plan_start_date"
        case planEndDate = "plan_end_date"
        case amount
        case isExpired = "is_expired"
        case onlineTransactionID = "online_transaction_id"
        case paymentMethod = "payment_method"
        case paymentStatus = "payment_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case planInfo = "plan_info"
    }
}

// MARK: - PlanInfo
struct PlanInfo: Codable {
    let id, countryID: Int?
    let planNameEnglish, planNameArabic: String?
    let duration, durationType: Int?
//    let newDurationType: String?
//    let newDuration: String?
    let noOfVideos, noOfProducts, noOfHighlights, noOfEmployee: Int?
    let stories, discountedPrice, commission: Int?
    let price: Double?
    let commissionPercentage, status: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case countryID = "country_id"
        case planNameEnglish = "plan_name_english"
        case planNameArabic = "plan_name_arabic"
        case duration
        case durationType = "duration_type"
//        case newDuration = "new_duration"
//        case newDurationType = "new_duration_type"
        case noOfVideos = "no_of_videos"
        case noOfProducts = "no_of_products"
        case noOfHighlights = "no_of_highlights"
        case noOfEmployee = "no_of_employee"
        case stories, price
        case discountedPrice = "discounted_price"
        case commission
        case commissionPercentage = "commission_percentage"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

