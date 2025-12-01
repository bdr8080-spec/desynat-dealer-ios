//
//  HomeDataModel.swift
//  DesynatDealer
//
//  Created by fluper on 24/11/25.
//

import Foundation

// MARK: - StoreAvailabilityStatusModel
struct StoreAvailabilityStatusModel: Codable {
    let id, sellerID: Int?
    let storeImage: String?
    let storeName, country, storeAddress, addressLine1: String?
    let addressLine2, storePhone, countryCode, storeMailID: String?
    let storeAvailability: Int?
    let bio, dataLet, long, createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case sellerID = "seller_id"
        case storeImage = "store_image"
        case storeName = "store_name"
        case country
        case storeAddress = "store_address"
        case addressLine1 = "address_line1"
        case addressLine2 = "address_line2"
        case storePhone = "store_phone"
        case countryCode = "country_code"
        case storeMailID = "store_mail_id"
        case storeAvailability = "Store_Availability"
        case bio
        case dataLet = "let"
        case long
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


//// MARK: - DealerProfileDetail
//struct DealerProfileDetail: Codable {
//    let id: Int?
//    let profilePic: String?
//    let firstName, lastName, countryCode, mobile: String?
//    let email, password, acceptTerms, otp: String?
//    let otpVerify, deviceType, deviceToken, adminVerify: String?
//    let storeInformation, bankInformation: String?
//    let rejectReason, lang: String?
//    let isBlock: Int?
//    let createdAt, updatedAt: String?
//    let storeInfo: StoreInfo?
//    let ownerDocument, storeDocument: [Document]?
//    let sellerBankDetails: SellerBankDetails?
//    let subcriptionPlan: [String]?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case profilePic = "profile_pic"
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case countryCode = "country_code"
//        case mobile, email, password
//        case acceptTerms = "accept_terms"
//        case otp
//        case otpVerify = "otp_verify"
//        case deviceType = "device_type"
//        case deviceToken = "device_token"
//        case adminVerify = "admin_verify"
//        case storeInformation = "store_information"
//        case bankInformation = "bank_information"
//        case rejectReason = "reject_reason"
//        case lang
//        case isBlock = "is_block"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case storeInfo = "store_info"
//        case ownerDocument = "owner_document"
//        case storeDocument = "store_document"
//        case sellerBankDetails = "seller_bank_details"
//        case subcriptionPlan = "subcription_plan"
//    }
//}
//
//// MARK: - Document
//struct Document: Codable {
//    let id, sellerID: Int?
//    let documentType: String?
//    let documentPath: String?
//    let status, createdAt, updatedAt: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case sellerID = "seller_id"
//        case documentType = "document_type"
//        case documentPath = "document_path"
//        case status
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//    }
//}
//
//// MARK: - SellerBankDetails
//struct SellerBankDetails: Codable {
//    let id: Int?
//    let userID, type, accountType, iban: String?
//    let swift, bankName, accountHolderName: String?
//    let uploadProof: String?
//    let createdAt, updatedAt: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case userID = "user_id"
//        case type
//        case accountType = "account_type"
//        case iban, swift
//        case bankName = "bank_name"
//        case accountHolderName = "account_holder_name"
//        case uploadProof = "upload_proof"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//    }
//}
//
//// MARK: - StoreInfo
//struct StoreInfo: Codable {
//    let id, sellerID: Int?
//    let storeImage: String?
//    let storeName, country, storeAddress, addressLine1: String?
//    let addressLine2, storePhone, countryCode, storeMailID: String?
//    let storeAvailability: Int?
//    let bio, storeInfoLet, long, createdAt: String?
//    let updatedAt: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case sellerID = "seller_id"
//        case storeImage = "store_image"
//        case storeName = "store_name"
//        case country
//        case storeAddress = "store_address"
//        case addressLine1 = "address_line1"
//        case addressLine2 = "address_line2"
//        case storePhone = "store_phone"
//        case countryCode = "country_code"
//        case storeMailID = "store_mail_id"
//        case storeAvailability = "Store_Availability"
//        case bio
//        case storeInfoLet = "let"
//        case long
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//    }
//}
