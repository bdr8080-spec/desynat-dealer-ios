//
//  NotificationsListDataModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 17/03/26.
//

import Foundation

// MARK: - NotificationsListDataModel
struct NotificationsListDataModel: Codable {
    let currentPage: Int?
    let data: [NotificationsList]?
    let firstPageURL: String?
    let from, lastPage: Int?
    let lastPageURL: String?
    let links: [Link]?
    let nextPageURL: String?
    let path: String?
    let perPage: Int?
    let prevPageURL: String?
    let to, total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case links
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to, total
    }
}

// MARK: - NotificationsList
struct NotificationsList: Codable {
    let id, senderID, senderType, receiverID: Int?
    let receiverType: Int?
    let titleEnglish: String?
    let titleArabic: String?
    let descriptionEnglish: String?
    let descriptionArabic: String?
    let notificationType: String?
    let isRead: Int?
    let createdAt, updatedAt: String?
//    let receiverDetails: [ReceiverDetails]?
    let senderDetails: SenderDetails?

    enum CodingKeys: String, CodingKey {
        case id
        case senderID = "sender_id"
        case senderType = "sender_type"
        case receiverID = "receiver_id"
        case receiverType = "receiver_type"
        case titleEnglish = "title_english"
        case titleArabic = "title_arabic"
        case descriptionEnglish = "description_english"
        case descriptionArabic = "description_arabic"
        case notificationType = "notification_type"
        case isRead = "is_read"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
//        case receiverDetails = "receiver_details"
        case senderDetails = "sender_details"
    }
}

// MARK: - SenderDetails
struct SenderDetails: Codable {
    let id: Int?
    let profilePic: String?
    let fullName: String?
    let countryCode, mobile: String?
    let email: String?
    let emailVerifiedAt, otp: String?
    let otpVerify: String?
//    let deviceType: String?
    let fcmToken: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case profilePic = "profile_pic"
        case fullName = "full_name"
        case countryCode = "country_code"
        case mobile, email
        case emailVerifiedAt = "email_verified_at"
        case otp
        case otpVerify = "otp_verify"
//        case deviceType = "device_type"
        case fcmToken = "fcm_token"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - ReceiverDetails
struct ReceiverDetails: Codable {
    let id: Int?
    let profilePic: String?
    let fullNameEnglish, fullNameArabic: String?
    let email: String?
    let countryCode, mobile, password, unhashedPassword: String?
    let addressLine1, addressLine2, city, state: String?
    let receiverDetailsLet, long: String?
    let countryID, zoneID: Int?
    let otp: String?
    let otpVerify: String?
//    let deviceType: String?
    let deviceToken: String?
    let vehicleName, vehicleRegNo, documentInformation, status: String?
    let onDuty: String?
    let fcmToken: String?
    let createdAt: String?
    let updatedAt: String?
    let firstName, lastName, acceptTerms, adminVerify: String?
    let storeInformation, bankInformation: String?
    let rejectReason: String?
    let lang: String?
    let isBlock: Int?
    let affilateCommission, profileImage: String?
    let fullName: String?
    let emailVerifiedAt: String?
    let bannerView: String?
    let accessToken, affiliatedUserdetails: String?

    enum CodingKeys: String, CodingKey {
        case id
        case profilePic = "profile_pic"
        case fullNameEnglish = "full_name_english"
        case fullNameArabic = "full_name_arabic"
        case email
        case countryCode = "country_code"
        case mobile, password
        case unhashedPassword = "unhashed_password"
        case addressLine1 = "address_line1"
        case addressLine2 = "address_line2"
        case city, state
        case receiverDetailsLet = "let"
        case long
        case countryID = "country_id"
        case zoneID = "zone_id"
        case otp
        case otpVerify = "otp_verify"
//        case deviceType = "device_type"
        case deviceToken = "device_token"
        case vehicleName = "vehicle_name"
        case vehicleRegNo = "vehicle_reg_no"
        case documentInformation = "document_information"
        case status
        case onDuty = "on_duty"
        case fcmToken = "fcm_token"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case firstName = "first_name"
        case lastName = "last_name"
        case acceptTerms = "accept_terms"
        case adminVerify = "admin_verify"
        case storeInformation = "store_information"
        case bankInformation = "bank_information"
        case rejectReason = "reject_reason"
        case lang
        case isBlock = "is_block"
        case affilateCommission = "affilate_commission"
        case profileImage = "profile_image"
        case fullName = "full_name"
        case emailVerifiedAt = "email_verified_at"
        case bannerView = "banner_view"
        case accessToken
        case affiliatedUserdetails = "affiliated_userdetails"
    }
}
