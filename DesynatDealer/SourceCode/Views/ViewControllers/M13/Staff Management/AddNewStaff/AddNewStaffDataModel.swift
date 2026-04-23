//
//  AddNewStaffDataModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 20/04/26.
//

import Foundation

// MARK: - GetAllAdminModulesDataModel
struct GetAllAdminModulesDataModel: Codable {
    let id: Int?
    let name, displayName: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case displayName = "display_name"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

