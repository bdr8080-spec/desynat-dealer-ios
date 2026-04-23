//
//  UpdateStatusProfileDataModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 21/04/26.
//

import Foundation

// MARK: - UpdateStatusProfileDataModel
struct UpdateStatusProfileDataModel: Codable {
    let id: Int?
    let type: String?
    let profilePic: String?
    let fullName: String?
    let fullNameAr: String?
    let countryID, countryCode, mobile, email: String?
    let emailVerifiedAt: String?
    let password, unhashedPassword: String?
    let otp: String?
    let otpVerify, deviceType: String?
    let fcmToken, rememberToken: String?
    let status: Int?
    let createdAt, updatedAt: String?
    let notification, appNotification: Int?

    enum CodingKeys: String, CodingKey {
        case id, type
        case profilePic = "profile_pic"
        case fullName = "full_name"
        case fullNameAr = "full_name_ar"
        case countryID = "country_id"
        case countryCode = "country_code"
        case mobile, email
        case emailVerifiedAt = "email_verified_at"
        case password
        case unhashedPassword = "unhashed_password"
        case otp
        case otpVerify = "otp_verify"
        case deviceType = "device_type"
        case fcmToken = "fcm_token"
        case rememberToken = "remember_token"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case notification
        case appNotification = "app_notification"
    }
}
