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
    
    init(url: String?, isVideo: Bool, duration: TimeInterval?) {
        self.url = url
        self.isVideo = isVideo
        self.duration = duration
    }
}


// MARK: - SellerHighlightsModel
struct SellerHighlightsModel: Codable {
    let id, type, sellerID: Int?
    let file: String?
    let title: String?
    let status: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, type
        case sellerID = "seller_id"
        case file, status, title
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
