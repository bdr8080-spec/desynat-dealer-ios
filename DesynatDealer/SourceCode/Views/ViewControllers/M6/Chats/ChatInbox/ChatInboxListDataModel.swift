//
//  ChatInboxListDataModel.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 11/01/26.
//

import Foundation

struct ChatInboxListModel: Codable {
  let id: Int?
  let uniqueID, type, messageType: String?
  let userID, sellerID: Int?
  let productID, variationID, price, quantity: String?
  let deliveryAddress, shipping, tax, totalAmount: String?
  let customDetails: String?
  let productRequest, action,productBuyStatus, createdAt, updatedAt: String?
  let lastChat: String?
  let lastChatTime: String?
  let productVariation: ProductVariation?
  let userDetails: UserDetails?
  let sellerDetails: UserDetails?
  let orderCreateStatus: OrderCreateStatus?
    let unreadCount: Int?
  
  enum CodingKeys: String, CodingKey {
      case id
      case uniqueID = "unique_id"
      case type
      case messageType = "message_type"
      case userID = "user_id"
      case sellerID = "seller_id"
      case productID = "product_id"
      case variationID = "variation_id"
      case price, quantity
      case productBuyStatus = "product_buy_status"
      case deliveryAddress = "delivery_address"
      case shipping, tax
      case totalAmount = "total_amount"
      case customDetails = "custom_details"
      case productRequest = "product_request"
      case action
      case createdAt = "created_at"
      case updatedAt = "updated_at"
      case lastChat = "last_chat"
      case lastChatTime = "last_chat_time"
      case productVariation = "product_variation"
      case userDetails = "user_details"
      case sellerDetails = "seller_details"
    case orderCreateStatus = "order_create_status"
      case unreadCount = "unread_count"
  }
}

