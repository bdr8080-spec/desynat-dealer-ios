//
//  SupportListDataModel.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 08/04/26.
//


import Foundation
import UIKit

// MARK: - SupportListDataModel
struct SupportListDataModel: Codable {
    let currentPage: Int?
    let data: [SupportList]?
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

// MARK: - SupportList
struct SupportList: Codable {
    let id: Int?
    let ticketID: String?
    let ticketTypeID: Int?
    let title, description: String?
    let senderID, senderType: Int?
    let file: String?
    let status: Int?
    let createdAt, updatedAt: String?
    let senderDetails: SenderDetails?
    let ticketTypeDetails: TicketTypeDetails?

    enum CodingKeys: String, CodingKey {
        case id
        case ticketID = "ticket_id"
        case ticketTypeID = "ticket_type_id"
        case title, description
        case senderID = "sender_id"
        case senderType = "sender_type"
        case file, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case senderDetails = "sender_details"
        case ticketTypeDetails = "ticket_type_details"
    }
}

// MARK: - TicketTypeDetails
struct TicketTypeDetails: Codable {
    let id: Int?
    let name: String?
    let status: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

enum TicketStatus: Int {
    case pending = 0
    case resolved = 1

    var text: String {
        switch self {
        case .pending: return "Pending"
        case .resolved: return "Resolved"
        }
    }
    
    var color: UIColor {
        switch self {
        case .pending: return UIColor(hexString: "#D72E04")   // 🔴 red
        case .resolved: return UIColor(hexString: "#0A8A20")  // 🟢 green
        }
    }
}


// MARK: - TicketTypesList
struct TicketTypesList: Codable {
    let id: Int?
    let name: String?
    let status: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
