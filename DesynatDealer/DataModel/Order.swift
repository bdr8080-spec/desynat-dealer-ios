//
//  Order.swift
//  TLP-APP
//
//  Created by Mohd Faizan on 07/10/25.
//

import Foundation

struct SalesOrderModel: Codable {
    let id: Int?
    let projectNO: Int?
    let balanceDays: Int?
    let condition: String?
    let type: Int?
    let soType: String?
    let date: String?
    let time: String?
    let ei: Int?
    let remarks: String?
    let employeeName: String?
    let empMobile: String?
    let customerNameId: Int?
    let customerAddressID: Int?
    let contactPersonID: Int?
    let companyid: Int?
    let addressDetails: String?
    let gstNo: String?
    let personDetails: String?
    let mobile: String?
    let customerDetails: String?
    let personEmail: String?
    let image: String?
    let personName: String?
    let personEmailid: String?
    let personMobile: String?
    let eid: Int?
    let status: Int?
    let statusName: String?
    let category: Int?
    let paymentTerm: String?
    let sno: Int?
    let offerNo: String?
    let totalPrice: Double?
    let campaignName: String?
    let source: String?
    let withGST: Int?
    let totalPayments: Double?
    let bomValue: Double?
    let issueValue: Double?
    let bomBalance: Double?
    let completeRatio: Double?
    let orderBalance: Double?
    let fy: Int?
    let salesPerson: Int?
    let handlePerson: String?
    let orderType: Int?
    let orderTypeDetails: String?

    // Optional fields 1-40
    let optional1: String?
    let optional2: String?
    let optional3: String?
    let optional4: String?
    let optional5: String?
    let optional6: String?
    let optional7: String?
    let optional8: String?
    let optional9: String?
    let optional10: String?
    let optional11: String?
    let optional12: String?
    let optional13: String?
    let optional14: String?
    let optional15: String?
    let optional16: String?
    let optional17: String?
    let optional18: String?
    let optional19: String?
    let optional20: String?
    let optional21: String?
    let optional22: String?
    let optional23: String?
    let optional24: String?
    let optional25: String?
    let optional26: String?
    let optional27: String?
    let optional28: String?
    let optional29: String?
    let optional30: String?
    let optional31: String?
    let optional32: String?
    let optional33: String?
    let optional34: String?
    let optional35: String?
    let optional36: String?
    let optional37: String?
    let optional38: String?
    let optional39: String?
    let optional40: String?

    let branchName: String?
    let branchid: Int?
    let currency: String?
    let rate: Double?
    let address: String?
    let country: String?
    let countryid: Int?
    let countryCode: String?
    let stateid: Int?
    let stateName: String?
    let cityid: Int?
    let cityName: String?

    let head: Int?
    let headName: String?
    let closerMonth: String?
    let revenue: Double?
    let revenuePercentage: String?

    let leadPurpose: String?
    let project: String?
    let userName: String?
    let formats: String?
    let decimalPlace: Int?
    let approved: Int?
    let approvalDate: String?
    let approvalTime: String?
    let fyName: String?
    let fid: String?
    let designuploadApprovalStatus: String?
    let dispatchStatus: String?
    let dispatchApprove: String?
    let saleStatus: String?
    let dcStatus: String?
    let technicalDocs: String?
    let bomStatus: String?

    // Technical Options
    let technicalOption1: String?
    let technicalOption2: String?
    let technicalOption3: String?
    let technicalOption4: String?
    let technicalOption5: String?
    let technicalOption6: String?
    let technicalOption7: String?
    let technicalOption8: String?
    let technicalOption9: String?
    let technicalOption10: String?
    let technicalOption11: String?
    let technicalOption12: String?
    let technicalOption13: String?
    let technicalOption14: String?
    let technicalOption15: String?

    let code: String?
    let bid: String?
    let branchHeadName: String?
    let shiprocketApplied: String?
    let shiprocketShipmentId: String?
    let shipRocketStatus: String?
    let shipRocketStatusId: String?
    let shipRocketLastCheckDate: String?
    let shipRocketLastChecktime: String?
    let usercomments: String?
    let admincomments: String?
    let totalPurchaseOrder: Int?
    let alternateMobileNo: String?
    let poNumber: String?
    let zonalName: String?
    let districtName: String?
    let adminRemarks: String?
    let landmark: String?
    let village: String?
    let soPrifix: String?
    let totalQty: Int?
    let refQuotNo: String?
    let refIndentId: String?
    let indentDate: String?
    let indentTime: String?
    let indentCreateUser: String?
    let approvedTYpe: String?
    let refPOId: String?
    let poDate: String?
    let poTime: String?
    let poEmployeeName: String?
    let poApproved: String?
    let totalDays: Int?
    let reserveStatus: String?
    let closerState: String?
    let color: String?
    let products: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case projectNO = "ProjectNO"
        case balanceDays = "BalanceDays"
        case condition = "Condition"
        case type = "Type"
        case soType = "SOType"
        case date = "Date"
        case time = "Time"
        case ei = "EI"
        case remarks = "Remarks"
        case employeeName = "EmployeeName"
        case empMobile = "EmpMobile"
        case customerNameId = "CustomerNameId"
        case customerAddressID = "CustomerAddressID"
        case contactPersonID = "ContactPersonID"
        case companyid = "Companyid"
        case addressDetails = "AddressDetails"
        case gstNo = "GSTNo"
        case personDetails = "PersonDetails"
        case mobile = "Mobile"
        case customerDetails = "CustomerDetails"
        case personEmail = "PersonEmail"
        case image = "Image"
        case personName = "PersonName"
        case personEmailid = "PersonEmailid"
        case personMobile = "PersonMobile"
        case eid = "eid"
        case status = "Status"
        case statusName = "StatusName"
        case category = "Category"
        case paymentTerm = "PaymentTerm"
        case sno = "Sno"
        case offerNo = "OfferNo"
        case totalPrice = "TotalPrice"
        case campaignName = "CampaignName"
        case source = "Source"
        case withGST = "WithGST"
        case totalPayments = "TotalPayments"
        case bomValue = "BomValue"
        case issueValue = "IssueValue"
        case bomBalance = "BomBalance"
        case completeRatio = "CompleteRatio"
        case orderBalance = "OrderBalance"
        case fy = "fy"
        case salesPerson = "SalesPerson"
        case handlePerson = "HandlePerson"
        case orderType = "OrderType"
        case orderTypeDetails = "OrderTypeDetails"
        
        case optional1 = "Optional1"
        case optional2 = "Optional2"
        case optional3 = "Optional3"
        case optional4 = "Optional4"
        case optional5 = "Optional5"
        case optional6 = "Optional6"
        case optional7 = "Optional7"
        case optional8 = "Optional8"
        case optional9 = "Optional9"
        case optional10 = "Optional10"
        case optional11 = "Optional11"
        case optional12 = "Optional12"
        case optional13 = "Optional13"
        case optional14 = "Optional14"
        case optional15 = "Optional15"
        case optional16 = "Optional16"
        case optional17 = "Optional17"
        case optional18 = "Optional18"
        case optional19 = "Optional19"
        case optional20 = "Optional20"
        case optional21 = "Optional21"
        case optional22 = "Optional22"
        case optional23 = "Optional23"
        case optional24 = "Optional24"
        case optional25 = "Optional25"
        case optional26 = "Optional26"
        case optional27 = "Optional27"
        case optional28 = "Optional28"
        case optional29 = "Optional29"
        case optional30 = "Optional30"
        case optional31 = "Optional31"
        case optional32 = "Optional32"
        case optional33 = "Optional33"
        case optional34 = "Optional34"
        case optional35 = "Optional35"
        case optional36 = "Optional36"
        case optional37 = "Optional37"
        case optional38 = "Optional38"
        case optional39 = "Optional39"
        case optional40 = "Optional40"
        
        case branchName = "BranchName"
        case branchid = "Branchid"
        case currency = "Currency"
        case rate = "Rate"
        case address = "Address"
        case country = "Country"
        case countryid = "Countryid"
        case countryCode = "CountryCode"
        case stateid = "Stateid"
        case stateName = "StateName"
        case cityid = "Cityid"
        case cityName = "CityName"
        
        case head = "Head"
        case headName = "HeadName"
        case closerMonth = "CloserMonth"
        case revenue = "Revenue"
        case revenuePercentage = "Revenue %"
        case leadPurpose = "LeadPurpose"
        case project = "Project"
        case userName = "UserName"
        case formats = "Formats"
        case decimalPlace = "DecimalPlace"
        case approved = "Approved"
        case approvalDate = "ApprovalDate"
        case approvalTime = "ApprovalTime"
        case fyName = "FyName"
        case fid = "fid"
        case designuploadApprovalStatus = "DesignuploadApprovalStatus"
        case dispatchStatus = "DispatchStatus"
        case dispatchApprove = "DispatchApprove"
        case saleStatus = "SAleStatus"
        case dcStatus = "DCStatus"
        case technicalDocs = "TechnicalDocs"
        case bomStatus = "BomStatus"

        case technicalOption1 = "TechnicalOption1"
        case technicalOption2 = "TechnicalOption2"
        case technicalOption3 = "TechnicalOption3"
        case technicalOption4 = "TechnicalOption4"
        case technicalOption5 = "TechnicalOption5"
        case technicalOption6 = "TechnicalOption6"
        case technicalOption7 = "TechnicalOption7"
        case technicalOption8 = "TechnicalOption8"
        case technicalOption9 = "TechnicalOption9"
        case technicalOption10 = "TechnicalOption10"
        case technicalOption11 = "TechnicalOption11"
        case technicalOption12 = "TechnicalOption12"
        case technicalOption13 = "TechnicalOption13"
        case technicalOption14 = "TechnicalOption14"
        case technicalOption15 = "TechnicalOption15"

        case code = "Code"
        case bid = "bid"
        case branchHeadName = "BranchHeadName"
        case shiprocketApplied = "ShiprocketApplied"
        case shiprocketShipmentId = "ShiprocketShipmentId"
        case shipRocketStatus = "ShipRocketStatus"
        case shipRocketStatusId = "ShipRocketStatusId"
        case shipRocketLastCheckDate = "ShipRocketLastCheckDate"
        case shipRocketLastChecktime = "ShipRocketLastChecktime"
        case usercomments = "usercomments"
        case admincomments = "admincomments"
        case totalPurchaseOrder = "TotalPurchaseOrder"
        case alternateMobileNo = "AlternateMobileNo"
        case poNumber = "PONumber"
        case zonalName = "ZonalName"
        case districtName = "DistrictName"
        case adminRemarks = "AdminRemarks"
        case landmark = "Landmark"
        case village = "Village"
        case soPrifix = "SOPrifix"
        case totalQty = "TotalQty"
        case refQuotNo = "RefQuotNo"
        case refIndentId = "RefIndentId"
        case indentDate = "IndentDate"
        case indentTime = "IndentTime"
        case indentCreateUser = "IndentCreateUser"
        case approvedTYpe = "ApprovedTYpe"
        case refPOId = "RefPOId"
        case poDate = "PoDate"
        case poTime = "PoTime"
        case poEmployeeName = "POEmployeeName"
        case poApproved = "POApproved"
        case totalDays = "TotalDays"
        case reserveStatus = "ReserveStatus"
        case closerState = "CloserState"
        case color = "Color"
        case products = "Products"
    }
}

struct InventoryModel: Codable {
    let id: Int?
    let sno: Int?
    let model: String?
    let brand: String?
    let hsn: String?
    let name: String?
    let code: String?
    let purchasePrice: Double?
    let price: Double?
    let discount: Double?
    let gst: Double?
    let pGroup: String?
    let sec: String?
    let affectInventory: Bool?
    let minStock: Int?
    
    // Optional Fields 1 - 30
    let optional1: String?
    let optional2: String?
    let optional3: String?
    let optional4: String?
    let optional5: String?
    let optional6: String?
    let optional7: String?
    let optional8: String?
    let optional9: String?
    let optional10: String?
    let optional11: String?
    let optional12: String?
    let optional13: String?
    let optional14: String?
    let optional15: String?
    let optional16: String?
    let optional17: String?
    let optional18: String?
    let optional19: String?
    let optional20: String?
    let optional21: String?
    let optional22: String?
    let optional23: String?
    let optional24: String?
    let optional25: String?
    let optional26: String?
    let optional27: String?
    let optional28: String?
    let optional29: String?
    let optional30: String?

    let companyId: Int?
    let companyCode: String?
    let description: String?
    let ei: Int?
    let serialize: String?
    let oemId: Int?
    let openingStock: Int?
    let date: String?
    let productType: Int?
    let image: String?
    let branch: String?
    let branchId: Int?
    let unit: String?
    let unitName: String?
    let subUnitName: String?
    let category: String?
    let categoryType: Int?
    let bomValue: Double?
    let enableDailyProduction: Bool?
    let productionQty: Int?
    let assetsTypeDetails: String?
    let assetsType: Int?
    let regularProduction: String?
    let showToSalesTeam: String?
    let showToFranchise: String?
    let status: String?
    let partCategory: String?
    let qualityCheck: String?
    let warranty: String?
    let onRent: String?
    let rentStatus: String?
    let po: Int?
    let showSales: Bool?
    let grn: String?
    let sale: String?
    let dc: String?
    let issue: Int?
    let reserve: Int?
    let stock: Int?
    let balanceSo: Int?
    let indent: String?
    let mrp: Double?
    let groupName: String?
    let formats: String?
    let price1: Double?
    let price2: Double?
    let price3: Double?
    let price4: Double?
    let price5: Double?
    let price6: Double?
    let empUsers: String?
    let brandName: String?
    let vid: String?
    let contractStatus: String?
    let manageContract: Bool?
    let eid: Int?
    let subUnit: String?
    let country: String?
    let countryId: Int?
    let calculateWay: String?
    let size: String?
    let sizeId: Int?
    let conversion: Int?
    let salesOrder: Int?
    let totalStock: Int?
    let priceDS: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case sno = "Sno"
        case model = "Model"
        case brand = "Brand"
        case hsn = "HSN"
        case name = "Name"
        case code = "Code"
        case purchasePrice = "PurchasePrice"
        case price = "Price"
        case discount = "Discount"
        case gst = "GST"
        case pGroup = "PGroup"
        case sec = "SEC"
        case affectInventory = "AffectInventory"
        case minStock = "MinStock"

        case optional1 = "Optional1"
        case optional2 = "Optional2"
        case optional3 = "Optional3"
        case optional4 = "Optional4"
        case optional5 = "Optional5"
        case optional6 = "Optional6"
        case optional7 = "Optional7"
        case optional8 = "Optional8"
        case optional9 = "Optional9"
        case optional10 = "Optional10"
        case optional11 = "Optional11"
        case optional12 = "Optional12"
        case optional13 = "Optional13"
        case optional14 = "Optional14"
        case optional15 = "Optional15"
        case optional16 = "Optional16"
        case optional17 = "Optional17"
        case optional18 = "Optional18"
        case optional19 = "Optional19"
        case optional20 = "Optional20"
        case optional21 = "Optional21"
        case optional22 = "Optional22"
        case optional23 = "Optional23"
        case optional24 = "Optional24"
        case optional25 = "Optional25"
        case optional26 = "Optional26"
        case optional27 = "Optional27"
        case optional28 = "Optional28"
        case optional29 = "Optional29"
        case optional30 = "Optional30"

        case companyId = "CompanyId"
        case companyCode = "CompanyCode"
        case description = "Description"
        case ei = "EI"
        case serialize = "Serialize"
        case oemId = "OEMId"
        case openingStock = "OpeningStock"
        case date = "Date"
        case productType = "ProductType"
        case image = "Image"
        case branch = "Branch"
        case branchId = "BranchId"
        case unit = "Unit"
        case unitName = "UnitName"
        case subUnitName = "SubUnitName"
        case category = "Category"
        case categoryType = "CategoryType"
        case bomValue = "BOMValue"
        case enableDailyProduction = "EnableDailyProduction"
        case productionQty = "ProductionQty"
        case assetsTypeDetails = "AssetsTypeDetails"
        case assetsType = "AssetsType"
        case regularProduction = "RegularProduction"
        case showToSalesTeam = "ShowToSalesTeam"
        case showToFranchise = "ShowToFranchise"
        case status = "Status"
        case partCategory = "PartCategory"
        case qualityCheck = "QualityCheck"
        case warranty = "Warranty"
        case onRent = "OnRent"
        case rentStatus = "RentStatus"
        case po = "PO"
        case showSales = "ShowSales"
        case grn = "GRN"
        case sale = "Sale"
        case dc = "DC"
        case issue = "Issue"
        case reserve = "Reserve"
        case stock = "Stock"
        case balanceSo = "BalanceSo"
        case indent = "Indent"
        case mrp = "Mrp"
        case groupName = "GroupName"
        case formats = "Formats"
        case price1 = "Price1"
        case price2 = "Price2"
        case price3 = "Price3"
        case price4 = "Price4"
        case price5 = "Price5"
        case price6 = "Price6"
        case empUsers = "EMPUsers"
        case brandName = "BrandName"
        case vid = "VID"
        case contractStatus = "ContractStatus"
        case manageContract = "ManageContract"
        case eid = "EID"
        case subUnit = "SubUnit"
        case country = "Country"
        case countryId = "CountryId"
        case calculateWay = "CalculateWay"
        case size = "Size"
        case sizeId = "SizeId"
        case conversion = "Conversion"
        case salesOrder = "SalesOrder"
        case totalStock = "TotalStock"
        case priceDS = "PriceDS"
    }
}

struct BranchModel:Codable{
    let ID:Int?
    let BranchName:String?
    let City:String?
    let State:String?
    let Country:String?
}

struct EmployeeHeadListModel:Codable{
    let Headid:Int?
    let Name:String?
}
