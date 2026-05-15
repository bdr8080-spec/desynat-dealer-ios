//
//  ChatMessage.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 11/01/26.
//


import Foundation
import FirebaseFirestore

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
    var messageAr: String?
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
    
//        func localizedMessage() -> String {
//                switch AppLanguage.current {
//                case .arabic:
//                    return messageAr ?? message ?? ""
//                case .english:
//                    return message ?? ""
//                }
//            }
    
    func localizedMessage() -> String {
        if AppLanguageManager.shared.currentLanguage == .ar {
            return messageAr ?? message ?? ""
        } else {
            return message ?? ""
        }
    }
    
    func toBackendDictionary(uniqueId: String) -> [String: Any] {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let isoDate = times ?? formatter.string(from: Date())
        
        return [
            "user_id": senderId ?? "",
            "unique_id": uniqueId,
            "message": message ?? "",
            "messageAr": messageAr ?? "",
            "type": type,
            "by": by ?? "user",
            "times": isoDate,
            "read": read ?? 0
        ]
    }
}
