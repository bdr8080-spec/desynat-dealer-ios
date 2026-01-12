//
//  ChatTimeFormatter.swift
//  DesynatDealer
//
//  Created by fluper on 12/01/26.
//


import Foundation
import FirebaseFirestore

extension Timestamp {
    
    func chatTimeString() -> String {
        let date = self.dateValue()
        return ChatTimeFormatter.shared.string(from: date)
    }
}

final class ChatTimeFormatter {
    static let shared: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"   // 08:32 AM
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter
    }()
}
