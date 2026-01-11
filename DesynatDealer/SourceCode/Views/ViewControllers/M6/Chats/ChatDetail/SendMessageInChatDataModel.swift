//
//  SendMessageInChatDataModel.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 11/01/26.
//

import Foundation

// MARK: - SendMessageInChatDataModel
struct SendMessageInChatDataModel: Codable {
    let userID: Int?
    let uniqueID, message, type, by: String?
    let times: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case uniqueID = "unique_id"
        case message, type, by, times
    }
}
