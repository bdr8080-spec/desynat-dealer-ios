//
//  UploadDocumentModel.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 03/11/25.
//



// MARK: - BankInfoModel
struct UploadDocumentModel: Codable {
    let userID: String?
    let type: String?
    let accountType: String?
    let iban: String?
    let swift: String?
    let bankName: String?
    let accountHolderName: String?
    let uploadProof: String?
    let updatedAt: String?
    let createdAt: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case type
        case accountType = "account_type"
        case iban
        case swift
        case bankName = "bank_name"
        case accountHolderName = "account_holder_name"
        case uploadProof = "upload_proof"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
}

