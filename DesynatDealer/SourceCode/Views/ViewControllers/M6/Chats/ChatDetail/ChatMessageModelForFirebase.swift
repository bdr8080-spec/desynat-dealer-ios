//
//  ChatMessage.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 11/01/26.
//


import Foundation
import FirebaseFirestore
//import FirebaseFirestoreSwift

// Main message model for Firestore

//struct ChatMessage: Codable, Identifiable {
//    @DocumentID var id: String?
//    let by: String
//    let message: String
//    let type: String
//    let timestamp: Timestamp
//}


//struct Chat : Equatable, Codable {
//    var id:String?
//    var senderId :String?
//    var type:String//ChatMessageType = .text
//    var message:String?
//    var timestamp:Int?
//    
//    static func == (lhs: Chat, rhs: Chat) -> Bool {
//        return lhs.senderId == rhs.senderId
//    }
//    
//    func getCreatedOn() -> Date? {
//        if timestamp != nil {
//            return Date(timeIntervalSince1970: TimeInterval(Int.getInt(timestamp!)/1000))
//        } else {
//            return nil
//        }
//    }
//}

enum ChatMessageType : Int, Codable {
    case text = 0
    case image = 1
}

import Foundation

struct Chat: Equatable, Codable {
    var uniqueId: String?
    var senderId: String?
    var type: String // "0" = message, "1" = image
    var message: String?
    var by: String? // "user" or "seller"
    var read: Int?  // 0 unread, 1 read
    var times: String? // ISO8601 string

    static func == (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.senderId == rhs.senderId && lhs.times == rhs.times
    }

    func getCreatedOn() -> Date? {
        guard let times = times else { return nil }
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: times)
    }

    func toBackendDictionary(uniqueId: String) -> [String: Any] {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let isoDate = times ?? formatter.string(from: Date())

        return [
            "user_id": senderId ?? "",
            "unique_id": uniqueId,
            "message": message ?? "",
            "type": type,
            "by": by ?? "user",
            "times": isoDate,
            "read": read ?? 0
        ]
    }
}
