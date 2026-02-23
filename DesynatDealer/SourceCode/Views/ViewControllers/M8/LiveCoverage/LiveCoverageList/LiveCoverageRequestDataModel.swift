//
//  LiveCoverageRequestDataModel.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 23/02/26.
//

import Foundation

// MARK: - LiveCoverageRequestDataModel
struct LiveCoverageRequestDataModel: Codable {
    let currentPage: Int?
    let data: [LiveCoverageRequestList]?
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

// MARK: - LiveCoverageRequestList
struct LiveCoverageRequestList: Codable {
    let id, timeslotID, sellerID, orderID: Int?
    let adminVerify: Int?
    let rejectReason, cancelReason: String?
    let createdAt, updatedAt: String?
    let timeslotDetails: TimeslotDetails?

    enum CodingKeys: String, CodingKey {
        case id
        case timeslotID = "timeslot_id"
        case sellerID = "seller_id"
        case orderID = "order_id"
        case adminVerify = "admin_verify"
        case rejectReason = "reject_reason"
        case cancelReason = "cancel_reason"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case timeslotDetails = "timeslot_details"
    }
}

// MARK: - TimeslotDetails
struct TimeslotDetails: Codable {
    let id, countryID: Int?
    let date, from, to: String?
    let status: Int?
    let createdAt, updatedAt: String?
    let countryInfo: CountryInfo?

    enum CodingKeys: String, CodingKey {
        case id
        case countryID = "country_id"
        case date, from, to, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case countryInfo = "country_info"
    }
}

// MARK: - Link
struct Link: Codable {
    let url: String?
    let label: String?
    let active: Bool?
}
