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


// MARK: - NotificationCountDataModel
struct NotificationCountDataModel: Codable {
    let notificationCount, chatUnreadCount: Int?

    enum CodingKeys: String, CodingKey {
        case notificationCount = "notification_count"
        case chatUnreadCount = "chat_unread_count"
    }
}

// MARK: - Dashboard Data
struct DashboardData: Codable {
    var totalRevenue: String?
    var totalProducts, totalActiveProducts, totalInactiveProducts, totalOrders: Int?
    var totalNewOrders, totalOngoingOrders, totalCompletedOrders, totalCancelledOrders: Int?
    var totalStaff, totalActiveStaff, totalInactiveStaff: Int?
    var orderAnalytics: [DashboardOrderAnalytic]?
    var visitorAnalytics: [DashboardVisitorAnalytic]?
    
    enum CodingKeys: String, CodingKey {
        case totalRevenue = "total_revenue"
        case totalProducts = "total_products"
        case totalActiveProducts = "total_active_products"
        case totalInactiveProducts = "total_inactive_products"
        case totalOrders = "total_orders"
        case totalNewOrders = "total_new_orders"
        case totalOngoingOrders = "total_ongoing_orders"
        case totalCompletedOrders = "total_completed_orders"
        case totalCancelledOrders = "total_cancelled_orders"
        case totalStaff = "total_staff"
        case totalActiveStaff = "total_active_staff"
        case totalInactiveStaff = "total_inactive_staff"
        case orderAnalytics = "order_analytics"
        case visitorAnalytics = "visitor_analytics"
    }
}

// MARK: - OrderAnalytic
struct DashboardOrderAnalytic: Codable {
    var month: String?
    var orders: Int?
}

// MARK: - VisitorAnalytic
struct DashboardVisitorAnalytic: Codable {
    var month: String?
    var totalVisitors: Int?

    enum CodingKeys: String, CodingKey {
        case month
        case totalVisitors = "total_visitors"
    }
}
