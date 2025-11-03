//
//  CountryModel.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 03/11/25.
//



// MARK: - Country
struct CountryModel: Codable {
    let id: Int?
    let name: String?
    let isoCode: String?
    let currencyName: String?
    let currencyCode: String?
    let currencySymbol: String?
    let dialCode: String?
    let flag: String?
    let exchangeRateToKwd: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case isoCode = "iso_code"
        case currencyName = "currency_name"
        case currencyCode = "currency_code"
        case currencySymbol = "currency_symbol"
        case dialCode = "dial_code"
        case flag
        case exchangeRateToKwd = "exchange_rate_to_kwd"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
