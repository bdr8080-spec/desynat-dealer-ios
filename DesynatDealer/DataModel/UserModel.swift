//
//  UserModel.swift
//  Qurtasb2b
//
//  Created by fluper on 24/01/25.

import Foundation

//struct User: Codable {
//    let id: Int?
//    let name: String?
//    let type: String?
//    
//    enum CodingKeys: String, CodingKey {
//        case id = "Id"
//        case name = "Name"
//        case type = "Type"
//    }
//}

struct EmptyModel:Codable{
    
}

struct UpdateAndRemarkModel: Codable {
    let id: Int?
    let date: String?
    let time: String?
    let companyId: Int?
    let customerName: String?
    let customerAddress: String?
    let customerEmail: String?
    let customerMobile: String?
    let remarks: String?
    let optional3: String?
    let optional18: String?
    let callLeadStatus: Int?
    let ei: Int?
    let leadType: Int?
    let assignDate: String?
    let assignBy: Int?
    let countryId: Int?
    let stateId: Int?
    let cityId: Int?
    let districtId: Int?
    let zonalId: Int?
    let tehsilId: Int?
    let blockId: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case date = "Date"
        case time = "Time"
        case companyId = "Companyid"
        case customerName = "CustomerName"
        case customerAddress = "CustomerAddress"
        case customerEmail = "CoustomerEmail"
        case customerMobile = "CoustomerMobile"
        case remarks = "Remarks"
        case optional3 = "Optional3"
        case optional18 = "Optional18"
        case callLeadStatus = "CallLeadStatus"
        case ei = "EI"
        case leadType = "LeadType"
        case assignDate = "AssignDate"
        case assignBy = "AssignBy"
        case countryId = "Countryid"
        case stateId = "StateId"
        case cityId = "CityId"
        case districtId = "DistrictId"
        case zonalId = "ZonalId"
        case tehsilId = "TehsilId"
        case blockId = "BlockId"
    }
}

struct TableCountModel:Codable{
    let Total:Int?
}
