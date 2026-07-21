//
//  PromotePriceDataModel.swift
//  DesynatDealer
//
//  Created by fluper_mac2 on 21/07/26.
//

import Foundation

// MARK: - PromotionPriceDataModel
struct PromotionPriceDataModel: Codable {
    let id, countryID: Int?
    let perDayPrice, createdAt, updatedAt: String?
    let totalAmount: Int?
    let countryInfo: CountryInfo?

    enum CodingKeys: String, CodingKey {
        case id
        case countryID = "country_id"
        case perDayPrice = "per_day_price"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case totalAmount = "total_amount"
        case countryInfo = "country_info"
    }
}
