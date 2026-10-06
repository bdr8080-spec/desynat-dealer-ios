//
//  PayoutDataModel.swift
//  DesynatDealer
//
//  Created by fluper_mac2 on 01/10/26.
//

import Foundation

// MARK: - AllTransactionPayoutModel
struct AllTransactionPayoutModel: Codable {
    let currencyCode: String?
    let currencySymbol: String?
    let totalRevenue: String?
    let totalCommission: String?
    let transactions: TransactionsPayout?

    enum CodingKeys: String, CodingKey {
        case currencyCode = "currency_code"
        case currencySymbol = "currency_symbol"
        case transactions = "transactions"
        case totalRevenue = "total_revenue"
        case totalCommission = "total_commission"
    }
}

// MARK: - TransactionsPayout
struct TransactionsPayout: Codable {
    let currentPage: Int?
    let data: [TransactionsPayoutList]?
    let firstPageURL: String?
    let from: Int?
    let lastPage: Int?
    let lastPageURL: String?
    let links: [Link]?
    let nextPageURL: String?
    let path: String?
    let perPage: Int?
    let prevPageURL: String?
    let to: Int?
    let total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data = "data"
        case firstPageURL = "first_page_url"
        case from = "from"
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case links = "links"
        case nextPageURL = "next_page_url"
        case path = "path"
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to = "to"
        case total = "total"
    }
}

// MARK: - TransactionsPayoutList
struct TransactionsPayoutList: Codable {
    let id: Int?
    let transactionType: Int?
    let transactionLabel: String?
    let referenceID: String?
    let orderID: Int?
    let transactionID: String?
    let amount: String?
    let customerName: String?
    let totalCommission: String?
    let transactionDate: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case transactionType = "transaction_type"
        case transactionLabel = "transaction_label"
        case referenceID = "reference_id"
        case orderID = "order_id"
        case transactionID = "transaction_id"
        case amount = "amount"
        case transactionDate = "transaction_date"
        case customerName = "customer_name"
        case totalCommission = "total_commission"
    }
}



// MARK: - MyPayoutDataModel
struct MyPayoutDataModel: Codable {
    let currencyCode: String?
    let currencySymbol: String?
    let totalEarning: String?
    let totalCommission: String?
//    let totalEarning: String?
    let totalPaid: String?
    let pendingAmount: String?
    let lastPayout: String?
    let lastPayoutDate: String?
    let payouts: MyPayoutData?

    enum CodingKeys: String, CodingKey {
        case currencyCode = "currency_code"
        case currencySymbol = "currency_symbol"
        case totalEarning = "total_earning"
        case totalCommission = "total_commission"
//        case totalEarning = "total_earning"
        case totalPaid = "total_paid"
        case pendingAmount = "pending_amount"
        case lastPayout = "last_payout"
        case lastPayoutDate = "last_payout_date"
        case payouts = "payouts"
    }
}

// MARK: - MyPayoutData
struct MyPayoutData: Codable {
    let currentPage: Int?
    let data: [MyPayoutDataList]?
    let firstPageURL: String?
    let from: Int?
    let lastPage: Int?
    let lastPageURL: String?
    let links: [Link]?
    let nextPageURL: String?
    let path: String?
    let perPage: Int?
    let prevPageURL: String?
    let to: Int?
    let total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data = "data"
        case firstPageURL = "first_page_url"
        case from = "from"
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case links = "links"
        case nextPageURL = "next_page_url"
        case path = "path"
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to = "to"
        case total = "total"
    }
}

// MARK: - MyPayoutDataList
struct MyPayoutDataList: Codable {
    let id: Int?
    let requestID: String?
    let amount, totalCommission: String?
    let transactionID: String?
    let paymentStatus: String?
    let payoutDate, fromDate, toDate: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case requestID = "request_id"
        case amount = "amount"
        case transactionID = "transaction_id"
        case paymentStatus = "payment_status"
        case payoutDate = "payout_date"
        case totalCommission = "total_commission"
        case fromDate = "from_date"
        case toDate = "to_date"
    }
}
