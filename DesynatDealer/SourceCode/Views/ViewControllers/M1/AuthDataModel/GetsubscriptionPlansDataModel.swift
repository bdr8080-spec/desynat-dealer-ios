//
//  GetsubscriptionPlansDataModel.swift
//  DesynatDealer
//
//  Created by fluper on 07/11/25.
//

import Foundation

// MARK: - GetPlansSubscriptionModel
struct GetPlansSubscriptionModel: Codable {
    let id, countryID: Int?
    let planNameEnglish, planNameArabic, isRecommendedStore: String?
    let duration, durationType, noOfVideos, noOfProducts: Int?
    let noOfHighlights, noOfEmployee, stories: Int?
    let commission, commissionPercentage, status: Int?
    let price: Double?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case countryID = "country_id"
        case planNameEnglish = "plan_name_english"
        case planNameArabic = "plan_name_arabic"
        case duration
        case durationType = "duration_type"
        case noOfVideos = "no_of_videos"
        case noOfProducts = "no_of_products"
        case noOfHighlights = "no_of_highlights"
        case noOfEmployee = "no_of_employee"
        case stories, price, commission
        case commissionPercentage = "commission_percentage"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isRecommendedStore = "is_recommended_store"
    }
}

// MARK: - PurchasePlanDataModel
struct PurchasePlanDataModel: Codable {
    let transactionID: String?
    let sellerID: Int?
    let status, paymentStatus, planStartDate: String?
    let planEndDate, paymentMethod, updatedAt, createdAt: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case transactionID = "transaction_id"
        case sellerID = "seller_id"
//        case planID = "plan_id"
        case status
        case paymentStatus = "payment_status"
        case planStartDate = "plan_start_date"
        case planEndDate = "plan_end_date"
        case paymentMethod = "payment_method"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
}
