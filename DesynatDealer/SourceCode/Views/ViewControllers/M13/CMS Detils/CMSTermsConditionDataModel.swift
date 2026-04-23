//
//  CMSTermsConditionDataModel.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 22/04/26.
//


//
//  CMSTermsConditionDataModel.swift
//  DesynatUser
//
//  Created by  shailendra singh on 17/04/26.
//


import Foundation

// MARK: - CMSTermsConditionDataModel
struct CMSTermsConditionDataModel: Codable {
    let id, type: Int?
    let title, slug, contentEnglish, contentArabic: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, type, title, slug
        case contentEnglish = "content_english"
        case contentArabic = "content_arabic"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
