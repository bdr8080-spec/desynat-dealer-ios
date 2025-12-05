//
//  EditProfileDataModel.swift
//  DesynatDealer
//
//  Created by fluper on 05/12/25.
//

import Foundation

// MARK: - SellerProfileDataModel
struct SellerProfileDataModel: Codable {
    let id: Int?
    let profilePic: String?
    let firstName, lastName, countryCode, mobile: String?
    let email, password, acceptTerms, otp: String?
    let otpVerify, deviceType, deviceToken, adminVerify: String?
    let storeInformation, bankInformation: String?
    let rejectReason, lang: String?
    let isBlock: Int?
    let affilateCommission: String?
    let createdAt, updatedAt: String?
    let storeInfo: StoreInfo?
    let sellerBankDetails: SellerBankDetails?
    let subcriptionPlan: [String]?
    let ownerDocument, storeDocument: [Document]?

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
        case deviceType = "device_type"
        case deviceToken = "device_token"
        case adminVerify = "admin_verify"
        case storeInformation = "store_information"
        case bankInformation = "bank_information"
        case rejectReason = "reject_reason"
        case lang
        case isBlock = "is_block"
        case affilateCommission = "affilate_commission"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case storeInfo = "store_info"
        case sellerBankDetails = "seller_bank_details"
        case subcriptionPlan = "subcription_plan"
        case ownerDocument = "owner_document"
        case storeDocument = "store_document"
    }
}
