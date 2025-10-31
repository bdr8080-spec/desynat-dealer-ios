//
//  AttendanceModel.swift
//  TLP-APP
//
//  Created by Mohd Faizan on 10/09/25.
//

import Foundation

// MARK: - SignUpModel
struct SignUpModel: Codable {
    let profilePic: String?
    let firstName: String?
    let lastName: String?
    let countryCode: String?
    let mobile: String?
    let email: String?
    let password: String?
    let acceptTerms: String?
    let deviceType: String?
    let deviceToken: String?
    let otp: String?
    let updatedAt: String?
    let createdAt: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case profilePic = "profile_pic"
        case firstName = "first_name"
        case lastName = "last_name"
        case countryCode = "country_code"
        case mobile
        case email
        case password
        case acceptTerms = "accept_terms"
        case deviceType = "device_type"
        case deviceToken = "device_token"
        case otp
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
}

struct UploadImageModel:Codable{
    let url:String?
}

//struct OtpVerificationModel:Codable{
//    
//}

// MARK: - SellerData
struct User: Codable {
    let id: Int?
    let profilePic: String?
    let firstName: String?
    let lastName: String?
    let countryCode: String?
    let mobile: String?
    let email: String?
    let password: String?
    let acceptTerms: String?
    let otp: String?
    let otpVerify: String?
    let deviceType: String?
    let deviceToken: String?
    let adminVerify: String?
    let storeInformation: String?
    let bankInformation: String?
    let createdAt: String?
    let updatedAt: String?
    let accessToken:String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case profilePic = "profile_pic"
        case firstName = "first_name"
        case lastName = "last_name"
        case countryCode = "country_code"
        case mobile
        case email
        case password
        case acceptTerms = "accept_terms"
        case otp
        case otpVerify = "otp_verify"
        case deviceType = "device_type"
        case deviceToken = "device_token"
        case adminVerify = "admin_verify"
        case storeInformation = "store_information"
        case bankInformation = "bank_information"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case accessToken = "accessToken"
    }
}

// MARK: - StoreInfoModel
struct StoreInfoModel: Codable {
    let sellerID: String?
    let storeImage: String?
    let storeName: String?
    let country: String?
    let storeAddress: String?
    let addressLine1: String?
    let addressLine2: String?
    let storePhone: String?
    let storeMailID: String?
    let bio: String?
    let latitude: String?
    let longitude: String?
    let updatedAt: String?
    let createdAt: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case sellerID = "seller_id"
        case storeImage = "store_image"
        case storeName = "store_name"
        case country
        case storeAddress = "store_address"
        case addressLine1 = "address_line1"
        case addressLine2 = "address_line2"
        case storePhone = "store_phone"
        case storeMailID = "store_mail_id"
        case bio
        case latitude = "let"
        case longitude = "long"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
}

// MARK: - BankInfoModel
struct UploadDocumentModel: Codable {
    let userID: String?
    let type: String?
    let accountType: String?
    let iban: String?
    let swift: String?
    let bankName: String?
    let accountHolderName: String?
    let uploadProof: String?
    let updatedAt: String?
    let createdAt: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case type
        case accountType = "account_type"
        case iban
        case swift
        case bankName = "bank_name"
        case accountHolderName = "account_holder_name"
        case uploadProof = "upload_proof"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
}


// MARK: - SellerData
struct SummaryModel: Codable {
    let id: Int?
    let profilePic: String?
    let firstName, lastName, countryCode, mobile: String?
    let email: String?
    let password: String?
    let acceptTerms, otp, otpVerify: String?
    let deviceType: String?
    let deviceToken: String?
    let adminVerify, storeInformation, bankInformation: String?
    let createdAt, updatedAt: String?
    let storeInfo: StoreInfo?
    let ownerDocument: [Document]?
    let storeDocument: [Document]?
    let sellerBankDetails: SellerBankDetails?

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
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case storeInfo = "store_info"
        case ownerDocument = "owner_document"
        case storeDocument = "store_document"
        case sellerBankDetails = "seller_bank_details"
    }
}

// MARK: - StoreInfo
struct StoreInfo: Codable {
    let id, sellerID: Int?
    let storeImage: String?
    let storeName, country, storeAddress: String?
    let addressLine1, addressLine2, storePhone, storeMailID: String?
    let bio: String?
    let latitude: String? // JSON key: "let" (reserved word in Swift)
    let long: String?
    let createdAt, updatedAt: String?

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
        case storeMailID = "store_mail_id"
        case bio
        case latitude = "let"
        case long
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Document
struct Document: Codable {
    let id, sellerID: Int?
    let documentType: String?
    let documentPath: String?
    let status: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case sellerID = "seller_id"
        case documentType = "document_type"
        case documentPath = "document_path"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - SellerBankDetails
struct SellerBankDetails: Codable {
    let id: Int?
    let userID: String?
    let type, accountType, iban, swift: String?
    let bankName, accountHolderName: String?
    let uploadProof: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case type
        case accountType = "account_type"
        case iban, swift
        case bankName = "bank_name"
        case accountHolderName = "account_holder_name"
        case uploadProof = "upload_proof"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

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

struct EmptyModel:Codable{
    
}
