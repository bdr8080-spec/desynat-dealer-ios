//
//  LiveStramingDataModel.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 03/04/26.
//


import Foundation
 
// MARK: - LivestramingData
//struct LivestramingData: Codable {
//    let currentPage: Int?
//    let data: [LiveStramingDataModel]?
//    let firstPageURL: String?
//    let from, lastPage: Int?
//    let lastPageURL: String?
//    let links: [Link]?
//    let nextPageURL: String?
//    let path: String?
//    let perPage: Int?
//    let prevPageURL: String?
//    let to, total: Int?
//    
//    enum CodingKeys: String, CodingKey {
//        case currentPage = "current_page"
//        case data
//        case firstPageURL = "first_page_url"
//        case from
//        case lastPage = "last_page"
//        case lastPageURL = "last_page_url"
//        case links
//        case nextPageURL = "next_page_url"
//        case path
//        case perPage = "per_page"
//        case prevPageURL = "prev_page_url"
//        case to, total
//    }
//}




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


struct ShowLiveEvenetsDataModel: Codable {
    let id: Int?
    let timeslotId: Int?
    let sellerId: Int?
    let orderId: Int?
    let adminVerify: Int?
    let rejectReason: String?
    let cancelReason: String?
    let channelId: String?
    let uid: UInt?  // 700773128
    let liveToken: String?
    let createdAt: String?
    let updatedAt: String?
    let sellerDetails: SellerDetails?
    let timeslotDetails: TimeslotDetails?
    
    enum CodingKeys: String, CodingKey {
        case id, uid
        case timeslotId = "timeslot_id"
        case sellerId = "seller_id"
        case orderId = "order_id"
        case adminVerify = "admin_verify"
        case rejectReason = "reject_reason"
        case cancelReason = "cancel_reason"
        case channelId = "channel_id"
        case liveToken = "liveToken"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case sellerDetails = "seller_details"
        case timeslotDetails = "timeslot_details"
    }
}

struct SellerDetails: Codable {
    let id: Int?
    let profilePic: String?
    let firstName, lastName, countryCode, mobile: String?
    let email, password, acceptTerms, otp: String?
    let otpVerify: String?
//    let deviceType: String?
    let deviceToken: String?
    let adminVerify, storeInformation, bankInformation: String?
    let rejectReason, lang: String?
    let isBlock: Int?
    let createdAt, updatedAt: String?
    let storeInfo: StoreInfo?
    
    enum CodingKeys: String, CodingKey {
        case id
        case profilePic = "profile_pic"
        case firstName = "first_name"
        case lastName = "last_name"
        case countryCode = "country_code"
        case mobile, email, password
        case acceptTerms = "accept_terms"
        case otp
        case otpVerify = "otp_verify"
//        case deviceType = "device_type"
        case deviceToken = "device_token"
        case adminVerify = "admin_verify"
        case storeInformation = "store_information"
        case bankInformation = "bank_information"
        case rejectReason = "reject_reason"
        case lang
        case isBlock = "is_block"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case storeInfo = "store_info"
    }
}
 
