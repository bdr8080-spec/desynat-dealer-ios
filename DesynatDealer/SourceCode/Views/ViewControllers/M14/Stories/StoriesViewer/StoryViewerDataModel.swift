//
//  StoryViewerDataModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 27/03/26.
//

import Foundation

// MARK: - Models
struct Story {
    let url: String?          // Make it optional
    let isVideo: Bool
    let duration: TimeInterval?   // nil for videos
    let uploadedTime: String?
    
    init(url: String?, isVideo: Bool, duration: TimeInterval?, uploadedTime: String?) {
        self.url = url
        self.isVideo = isVideo
        self.duration = duration
        self.uploadedTime = uploadedTime
    }
}


// MARK: - SellerHighlightsDataModel
struct SellerHighlightsDataModel: Codable {
    let currentPage: Int?
    let data: [SellerHighlightsModel]?
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

// MARK: - SellerHighlightsModel
struct SellerHighlightsModel: Codable {
    let id, type, sellerID: Int?
    let file: String?
    let title: String?
    let status: Int?
    let createdAt, updatedAt: String?
    let isSeen: Int?

    enum CodingKeys: String, CodingKey {
        case id, type
        case sellerID = "seller_id"
        case file, status, title
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isSeen = "is_seen"
    }
}
