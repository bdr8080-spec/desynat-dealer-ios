//
//  FAQListDataModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 16/03/26.
//

import Foundation

// MARK: - FAQListDataModel
struct FAQListDataModel: Codable {
    let id, type: Int?
    let questionEnglish, answerEnglish, questionArabic, answerArabic: String?
    let status: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, type
        case questionEnglish = "question_english"
        case answerEnglish = "answer_english"
        case questionArabic = "question_arabic"
        case answerArabic = "answer_arabic"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
