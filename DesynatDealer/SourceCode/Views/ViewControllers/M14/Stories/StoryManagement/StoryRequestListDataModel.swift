//
//  StoryRequestListDataModel.swift
//  DesynatDealer
//
//  Created by fluper_mac2 on 22/07/26.
//

import Foundation

// MARK: - StoryRequestListDataModel
struct StoryRequestListDataModel: Codable {
    let currentPage: Int?
    let data: [StoryRequestList]?
    let firstPageURL: String?
    let from, lastPage: Int?
    let lastPageURL: String?
    let links: [Link]?
    let nextPageURL, path: String?
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

// MARK: - StoryRequestList
struct StoryRequestList: Codable {
    let id, type, sellerID: Int?
    let file: String?
    let status: Int?
    let thumbnail: String?
    let createdAt, updatedAt, isPromotional, startDate: String?
    let endDate, totalDays, amount, adminVerify: String?
    let paymentStatus: String?
    let transactionID, rejectReason: String?

    enum CodingKeys: String, CodingKey {
        case id, type
        case sellerID = "seller_id"
        case file, status, thumbnail
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isPromotional = "is_promotional"
        case startDate = "start_date"
        case endDate = "end_date"
        case totalDays = "total_days"
        case amount
        case adminVerify = "Admin_verify"
        case paymentStatus = "payment_status"
        case transactionID = "transaction_id"
        case rejectReason = "reject_reason"
    }
}
