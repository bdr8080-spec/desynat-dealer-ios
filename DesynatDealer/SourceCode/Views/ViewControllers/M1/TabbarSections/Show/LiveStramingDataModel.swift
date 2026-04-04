//
//  LiveStramingDataModel.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 03/04/26.
//


import Foundation
 
 
struct LiveStramingDataModel: Codable {
    let currentRequests: [CurrentRequest]?
    let futureRequests: [CurrentRequest]?
    
    enum CodingKeys: String, CodingKey {
        case currentRequests = "current_requests"
        case futureRequests = "future_requests"
    }
}
 
struct CurrentRequest: Codable {
    let adminVerify: Int?
    let cancelReason: String?
    let channelId: String?
    let liveToken: String?
    let createdAt: String?
    let id: Int?
    let orderId: Int?
    let rejectReason: String?
    let sellerId: Int?
    let timeslotDetails: TimeslotDetails?
    let timeslotId: Int?
    let uid: UInt?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case adminVerify = "admin_verify"
        case cancelReason = "cancel_reason"
        case channelId = "channel_id"
        case liveToken = "liveToken"
        case createdAt = "created_at"
        case id
        case orderId = "order_id"
        case rejectReason = "reject_reason"
        case sellerId = "seller_id"
        case timeslotDetails = "timeslot_details"
        case timeslotId = "timeslot_id"
        case uid
        case updatedAt = "updated_at"
    }
}
 
//struct TimeslotDetails: Codable {
//    let countryId: Int?
//    let countryInfo: CountryInfo?
//    let createdAt: String?
//    let date: String?
//    let from: String?
//    let id: Int?
//    let status: Int?
//    let to: String?
//    let updatedAt: String?
//    
//    enum CodingKeys: String, CodingKey {
//        case countryId = "country_id"
//        case countryInfo = "country_info"
//        case createdAt = "created_at"
//        case date, from, id, status, to
//        case updatedAt = "updated_at"
//    }
//}
// 
//struct CountryInfo: Codable {
//    let createdAt: String?
//    let currencyCode: String?
//    let currencyName: String?
//    let currencySymbol: String?
//    let dialCode: String?
//    let exchangeRateToKwd: String?
//    let flag: String?
//    let flag1: String?
//    let id: Int?
//    let isoCode: String?
//    let name: String?
//    let updatedAt: String?
//    
//    enum CodingKeys: String, CodingKey {
//        case createdAt = "created_at"
//        case currencyCode = "currency_code"
//        case currencyName = "currency_name"
//        case currencySymbol = "currency_symbol"
//        case dialCode = "dial_code"
//        case exchangeRateToKwd = "exchange_rate_to_kwd"
//        case flag, flag1, id
//        case isoCode = "iso_code"
//        case name
//        case updatedAt = "updated_at"
//    }
//}
////}
// 
// 
// MARK: - AgroaTokenDataModel
struct AgroaTokenDataModel: Codable {
    let token, appID, channel: String?
    let uid: UInt?

    enum CodingKeys: String, CodingKey {
        case token
        case appID = "appId"
        case channel, uid
    }
}
