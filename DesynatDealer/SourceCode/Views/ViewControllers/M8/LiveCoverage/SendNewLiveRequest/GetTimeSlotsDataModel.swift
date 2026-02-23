//
//  GetTimeSlotsDataModel.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 23/02/26.
//

import Foundation

// MARK: - GetTimeSlotsDataModel
struct GetTimeSlotsDataModel: Codable {
    let id, countryID: Int?
    let date, from, to: String?
    let status: Int?
    let createdAt, updatedAt: String?
    let countryInfo: CountryInfo?

    enum CodingKeys: String, CodingKey {
        case id
        case countryID = "country_id"
        case date, from, to, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case countryInfo = "country_info"
    }
}
