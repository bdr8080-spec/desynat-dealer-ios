//
//  User.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 03/11/25.
//


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
//    let deviceType: String?
    let deviceToken: String?
    let adminVerify: String?
    let storeInformation: String?
    let bankInformation: String?
    let createdAt: String?
    let updatedAt: String?
    let accessToken:String?
    let subcriptionPlanCheck: String?
    
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
//        case deviceType = "device_type"
        case deviceToken = "device_token"
        case adminVerify = "admin_verify"
        case storeInformation = "store_information"
        case bankInformation = "bank_information"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case accessToken = "accessToken"
        case subcriptionPlanCheck = "subcription_plan_check"
    }
}
