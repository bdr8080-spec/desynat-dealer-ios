//
//  AddStoryModel.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 31/03/26.
//

import Foundation
struct AddStoryModel: Codable {
    let file: String?
    let type, sellerID: Int?
    let updatedAt, createdAt: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case file, type
        case sellerID = "seller_id"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
}

struct UploadFileDataModel: Codable {
    let url: String
}
