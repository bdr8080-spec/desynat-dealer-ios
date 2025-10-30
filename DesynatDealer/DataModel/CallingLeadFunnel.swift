//
//  CallingLeadFunnel.swift
//  TLP-APP
//
//  Created by Mohd Faizan on 25/06/25.
//

import Foundation


struct CallingLeadFunnelModel:Codable{
    let userwise:[UserWise]?
    let datewise:[DateWise]?
}

struct UserWise:Codable{
    let Id:Int?
    let Name:String?
    let TotalInterested:Int?
    let TotalNotInterested:Int?
    let CallAttempted:Int?
    let DND:Int?
    let InvalidNumber:Int?
    let TotalLead:Int?
    let Pending:Int?
    let NotAssigned:Int?
}

struct DateWise:Codable{
    let Dates:String?
    let Date:String?
    let TotalInterested:Int?
    let TotalNotInterested:Int?
    let CallAttempted:Int?
    let DND:Int?
    let InvalidNumber:Int?
    let TotalLead:Int?
    let Pending:Int?
    let NotAssigned:Int?
}

struct EmployeeListModel:Codable{
    let Id:Int?
    let Name:String?
}

struct CountryListModel:Codable{
    let Id:Int?
    let Name:String?
    let Code:String?
}

struct StateListModel:Codable{
    let Id:Int?
    let name:String?
}

struct CityListModel:Codable{
    let id:Int?
    let name:String?
}

struct CommunityListModel:Codable{
    let id:Int?
    let name:String?
}

struct ProjectListModel:Codable{
    let id:Int?
    let name:String?
}

struct LeadTypeListModel:Codable{
    let id:Int?
    let name:String?
}

struct StatusListModel:Codable{
    let value:Int?
    let text:String?
}

struct SortByListModel:Codable{
    let Value:String?
    let Text:String?
}

struct CallingLeadListModel: Codable {
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
    let ei:Int?
    let eid: Int?
    let users: String?
    let assignDate: String?
    let assignBy:Int?
    let assignToName: String?
    let assignByName: String?
    let countryId: Int?
    let country: String?
    let stateId: Int?
    let state: String?
    let cityId: Int?
    let city: String?
    let zonalId: Int?
    let community: String?
    let districtId: Int?
    let district: String?
    let tehsilId: Int?
    let tahshil: String?
    let blockId: Int?
    let blocks: String?
    let leadType: String?
    let leadTypeId: Int?

    enum CodingKeys: String, CodingKey {
        case id
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
        case eid = "eid"
        case users = "Users"
        case assignDate = "AssignDate"
        case assignBy = "AssignBy"
        case assignToName = "AssignToName"
        case assignByName = "AssignByName"
        case countryId = "Countryid"
        case country = "Country"
        case stateId = "StateId"
        case state = "State"
        case cityId = "CityId"
        case city = "City"
        case zonalId = "ZonalId"
        case community = "Community"
        case districtId = "DistrictId"
        case district = "District"
       // case project = "Project"
        case tehsilId = "TehsilId"
        case tahshil = "Tahshil"
        case blockId = "BlockId"
        case blocks = "Blocks"
        case leadType = "LeadType"
        case leadTypeId = "leadtypeid"
    }
}

struct ReportingManagerListModel:Codable{
    let Id:Int?
    let Name:String?
}

struct CompanyLeaveModel:Codable{
    let Id:Int?
    let Leave:String?
    let TotalDays:Int?
    let Taken:Int?
}

struct PersonalDetailsModel:Codable{
    let id:Int?
    let name:String?
    let gender:String?
    let mobile:String?
    let emailID:String?
    let image:String?
    let address:String?
    let permanentAddress:String?
    let loginid:String?
    let password:String?
    let department:String?
    let designation:String?
    let pfNo:String?
    let dob:String?
    let branchName:String?
    let type:String?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "Name"
        case gender = "Gender"
        case mobile = "Mobile"
        case emailID = "EmailID"
        case image = "Image"
        case address = "Address"
        case permanentAddress = "PermanentAddress"
        case loginid = "Loginid"
        case password = "Password"
        case department = "Department"
        case designation = "Designation"
        case pfNo = "PFNo"
        case dob = "DOB"
        case branchName = "BranchName"
        case type = "Type"
        
    }
}

struct SalaryDetailsModel: Codable {
    let id: Int?
    let date: String?
    let prepareDate: String?
    let distributeDate: String?
    let basicSalary: Double?
    let da: Double?
    let medical: Double?
    let conveyance: Double?
    let hra: Double?
    let lta: Double?
    let childrenEducation: Double?
    let childrenHostal: Double?
    let mobile: Double?
    let carMaintenance: Double?
    let driverSalary: Double?
    let books: Double?
    let special: Double?
    let overtime: Double?
    let pf: Double?
    let esic: Double?
    let professionalTax: Double?
    let labourWelfarefund: Double?
    let monthlyBonous: Double?
    let yearlyBonous: Double?
    let persentDay: Int?
    let absentDay: Int?
    let totalOvertime: Double?
    let lateTime: Double?
    let cost: Double?
    let otAmount: Double?
    let loan: Double?
    let late: Double?
    let absent: Double?
    let totalExpense: Double?
    let grossSalary: Double?
    let deduction: Double?
    let otherDeduction: Double?
    let sid: Int?
    let leave: Int?
    let totalSalary: Double?
    let year: Int?
    let month: Int?
    let status: Int?
    let ei: Double?
    let companyid: Int?
    let users: String?
    let typeOfUser: String?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case date = "Date"
        case prepareDate = "PrepareDate"
        case distributeDate = "DistributeDate"
        case basicSalary = "BasicSalary"
        case da = "DA"
        case medical = "Medical"
        case conveyance = "Conveyance"
        case hra = "HRA"
        case lta = "LTA"
        case childrenEducation = "ChildrenEducation"
        case childrenHostal = "ChildrenHostal"
        case mobile = "Mobile"
        case carMaintenance = "CarMaintenance"
        case driverSalary = "DriverSalary"
        case books = "Books"
        case special = "Special"
        case overtime = "Overtime"
        case pf = "Pf"
        case esic = "ESIC"
        case professionalTax = "ProfessionalTax"
        case labourWelfarefund = "LabourWelfarefund"
        case monthlyBonous = "MonthlyBonous"
        case yearlyBonous = "YearlyBonous"
        case persentDay = "PersentDay"
        case absentDay = "AbsentDay"
        case totalOvertime = "TotalOvertime"
        case lateTime = "LateTime"
        case cost = "Cost"
        case otAmount = "OTAmount"
        case loan = "Loan"
        case late = "Late"
        case absent = "Absent"
        case totalExpense = "TotalExpense"
        case grossSalary = "GrossSalary"
        case deduction = "Deduction"
        case otherDeduction = "OtherDeduction"
        case sid = "Sid"
        case leave = "Leave"
        case totalSalary = "TotalSalary"
        case year = "Year"
        case month = "Month"
        case status = "Status"
        case ei = "ei"
        case companyid = "Companyid"
        case users = "Users"
        case typeOfUser = "TypeOfUser"
    }
}

struct DocumentsDetailsModel:Codable{
    let Id:Int?
    let FileType:String?
    let FileUrl:String?
}

struct CallingDashboardModel:Codable{
    let Count:Int?
    let Value:Int?
    let Text:String?
    var Description:String?
}

struct FieldDataModel:Codable{
    var Value:String?
}
