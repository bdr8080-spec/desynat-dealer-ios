//
//  HighLightDataModel.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 01/04/26.
//

import Foundation

// MARK: - GetHighLightsDataModel
struct GetHighLightsDataModel: Codable {
    let currentPage: Int?
    let data: [GetHighLightsList]?
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

// MARK: - GetHighLightsList
struct GetHighLightsList: Codable {
    let id, type, sellerID: Int?
    let file: String?
    let title: String?
    let thumbnail:String?
    let status: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, type
        case sellerID = "seller_id"
        case file, title, status, thumbnail
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


// MARK: - GetMyReelsDataModel
struct GetMyReelsDataModel: Codable {
    let currentPage: Int?
    let data: [GetMyReelsList]?
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

// MARK: - GetMyReelsList
struct GetMyReelsList: Codable {
    let id, type, sellerID: Int?
    let file,thumbnail : String?
    let caption: String?
    let status: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, type
        case sellerID = "seller_id"
        case file, status, caption,thumbnail
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
