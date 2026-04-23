//
//  NotificationDataModel.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 22/04/26.
//



// MARK: - NotificationDataModel
struct NotificationDataModel: Codable {
    let id: Int?
    let profileImage: String?
    let fullName, countryCode, mobile, email: String?
    let emailVerifiedAt: String?
    let otp, otpVerify: String?
    let bannerView, lang, createdAt: String?
    let affiliatedUserdetails: String?
    let notification: Int?
    let appNotification: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case profileImage = "profile_image"
        case fullName = "full_name"
        case countryCode = "country_code"
        case mobile, email
        case emailVerifiedAt = "email_verified_at"
        case otp
        case otpVerify = "otp_verify"
        case bannerView = "banner_view"
        case lang
        case createdAt = "created_at"
        case affiliatedUserdetails = "affiliated_userdetails"
        case notification
        case appNotification = "app_notification"
    }
}
