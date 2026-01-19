//
//  SignUpModel.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 03/11/25.
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



