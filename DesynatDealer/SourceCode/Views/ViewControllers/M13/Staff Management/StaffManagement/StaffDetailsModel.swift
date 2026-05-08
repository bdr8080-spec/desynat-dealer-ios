//
//  StaffDetailsModel.swift
//  DesynatDealer
//
//  Created by Riya Mac on 23/04/26.
//

import Foundation

// MARK: - StaffManagementDataModel
struct StaffManagementDataModel: Codable {
    let currentPage: Int?
    let data: [StaffDetails]?
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

struct StaffDetails: Codable {
    var id: Int?
    var type, parentID: String?
    var profilePic: String?
    var firstName, lastName, countryCode, mobile: String?
    var email, password, acceptTerms: String?
    var otp: String?
    var otpVerify: String?
    var deviceType, deviceToken: String?
    var adminVerify, storeInformation, bankInformation: String?
    var rejectReason, lang: String?
    var isBlock: Int?
    var affilateCommission, fcmToken, profileQr, qrSellerURL, unhashedPassword: String?
    var createdAt, updatedAt: String?
    var notification, appNotification: Int?
    var nameAr, selectCategory: String?
    var sellerCategory: SellerCategory?
    var roleAction: [RoleAction]?
    var status:String?
    
    enum CodingKeys: String, CodingKey {
        case id, type
        case parentID = "parent_id"
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
        case fcmToken = "fcm_token"
        case profileQr = "profile_qr"
        case qrSellerURL = "qrSellerUrl"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case notification
        case appNotification = "app_notification"
        case nameAr = "name_ar"
        case selectCategory = "select_category"
        case sellerCategory = "seller_category"
        case roleAction = "role__action"
        case unhashedPassword = "save_password"
        case status
    }
}

// MARK: - RoleAction
struct RoleAction: Codable {
    var id: Int?
    var sellerID: String?
    var menuID: Int?
    var canView, canAction: Int?
    var createdAt, updatedAt: String?
    var sellermenu: [Sellermenu]?

    enum CodingKeys: String, CodingKey {
        case id
        case sellerID = "seller_id"
        case menuID = "menu_id"
        case canView = "can_view"
        case canAction = "can_action"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case sellermenu
    }
}


// MARK: - Sellermenu
struct Sellermenu: Codable {
    var id: Int?
    var title,titleAr, route, icon, activePatterns: String?
    var parentID: String?
    var orderBy, status: Int?
    var createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, title, route, icon
        case activePatterns = "active_patterns"
        case parentID = "parent_id"
        case orderBy = "order_by"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case titleAr = "title_ar"
    }
}


// MARK: - SellerCategory
struct SellerCategory: Codable {
    var id: Int?
    var nameEn, nameAr, status: String?
    var createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - GetAllSellerData
struct GetAllSellerData: Codable {
    var id: Int?
    var title,titleAr, route, icon, activePatterns: String?
    var parentID: String?
    var orderBy, status: Int?
    var createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, title, route, icon
        case activePatterns = "active_patterns"
        case parentID = "parent_id"
        case orderBy = "order_by"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case titleAr = "title_ar"
    }
}


// MARK: - Datum
struct GetAllStaffRoles: Codable {
    var id: Int?
    var nameEn, nameAr, status: String?
    var createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct AddStaffData: Codable {
    var profilePic: String?
    var type, firstName, lastName, nameAr: String?
    var countryCode, mobile, email, password: String?
    var acceptTerms: String?
    var deviceType, deviceToken: String?
    var otpVerify, adminVerify: String?
    var lang: String?
    var parentID: Int?
    var updatedAt, createdAt: String?
    var id: Int?
    var selectCategory:Int?

    enum CodingKeys: String, CodingKey {
        case profilePic = "profile_pic"
        case type
        case firstName = "first_name"
        case lastName = "last_name"
        case nameAr = "name_ar"
        case countryCode = "country_code"
        case mobile, email, password
        case acceptTerms = "accept_terms"
        case deviceType = "device_type"
        case deviceToken = "device_token"
        case otpVerify = "otp_verify"
        case adminVerify = "admin_verify"
        case lang
        case parentID = "parent_id"
        case selectCategory = "select_category"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
}
