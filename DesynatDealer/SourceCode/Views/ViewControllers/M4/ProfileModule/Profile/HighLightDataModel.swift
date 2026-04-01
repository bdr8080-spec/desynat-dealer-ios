//
//  HighLightDataModel.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 01/04/26.
//

import Foundation

// MARK: - GetHighLightsDataModel
struct GetHighLightsDataModel: Codable {
    var id, type, sellerID: Int?
    var file: String?
    var title: String?
    var status: Int?
    var createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, type
        case sellerID = "seller_id"
        case file, title, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
