//
//  AddNewStaffViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 16/04/26.
//

import Foundation

class AddNewStaffViewModel {
    
    private var hostVC: AddNewStaffViewController
    var countryListData: [CountryModel] = []
    var dealerSellersListData: [GetAllSellerData] = []
    
    init(hostVC: AddNewStaffViewController) {
        self.hostVC = hostVC
    }
    
    func countryListApi(){
        WebService.sharedInstance.countryListService { list in
            self.countryListData = list
        }
    }
    
    func getAllAdminModulesRequest(completion: (() -> Void)? = nil) {
        WebService.sharedInstance.getAllSellerModulesService{ [weak self] response in
            guard let self = self else { return }
            dealerSellersListData = response
            completion?()
        }
    }
    
    func validFields() -> Bool {
        var errorMessage: AlertConstant = .none
        
        if hostVC.selectedImageUrl.isEmpty {
            errorMessage = .SelectProfileImage
        }
        
        let fullNameInEnglish = String.getString(hostVC.fullNameInEnglishTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if fullNameInEnglish.isEmpty {
                errorMessage = .enterFullNameEnglish
            }
        }
        
        let fullNameInArabic = String.getString(hostVC.fullNameInArabicTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if fullNameInArabic.isEmpty {
                errorMessage = .enterFullNameArabic
            }
        }
        
        let emailId = String.getString(hostVC.emailTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if emailId.isEmpty {
            errorMessage = .EnterEmail
        }else if !emailId.isValidEmail() {
            errorMessage = .EnterValidEmailAddress
        }
        
        let mobile = String.getString(hostVC.mobileTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if mobile.isEmpty {
            errorMessage = .EnterMobileNumber
        }else if !mobile.isValidPhoneNumber() {
            errorMessage = .validMobileNumber
        }
        
        if hostVC.selectedRoleId == -1 {
            errorMessage = .selectRoleForNotification
        }
        
        let password = String.getString(hostVC.passwordTxtField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if password.isEmpty {
                errorMessage = .EnterPassword
            }
        }
        
        let confirmPassword = String.getString(hostVC.confirmPasswortTxtField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if confirmPassword.isEmpty {
                errorMessage = .EnterConfirmPassword
            }
        }
        
        if errorMessage == .none {
            if password != confirmPassword {
                errorMessage = .PasswordNotMatched
            }
        }
        
        if errorMessage == .none {
            if hostVC.moduleSelctedData.isEmpty {
                errorMessage = .selectModule
            }
        }
        
        if errorMessage != .none {
            hostVC.showAlert(msg: errorMessage.rawValue)
        }
        
        hostVC.view.endEditing(true)
        return errorMessage == .none
    }
    
    
    func addNewStaff() {
        let modulesArray = hostVC.moduleSelctedData.map { module in
            return [
                "id": module.moduleId,
                "can_view": module.viewSelcted,
                "can_action": module.actionIsSelected
            ]
        }
        
        let param: [String: Any] = ["profile_pic": hostVC.selectedImageUrl,
                                    "full_name": hostVC.fullNameInEnglishTF.text ?? "",
                                    "name_ar": hostVC.fullNameInArabicTF.text ?? "",
                                    "country_code": hostVC.countryCode,
                                    "mobile": hostVC.mobileTF.text ?? "",
                                    "email": hostVC.emailTF.text ?? "",
                                    "password": hostVC.passwordTxtField.text ?? "",
                                    "select_category": hostVC.selectedRoleId,
                                    "menu_id": modulesArray]
        WebService.sharedInstance.addSellerModulesService(param){ [weak self] response in
            guard let self = self else { return }
            CommonUtils.showToast(message: "Staff is added successfully")
            self.hostVC.navigationController?.popViewController(animated: true)
        }
    }
    
    func editStaffDetails() {
        let modulesArray = hostVC.moduleSelctedData.map { module in
            return [
                "id": module.moduleId,
                "can_view": module.viewSelcted,
                "can_action": module.actionIsSelected
            ]
        }
        
        let param: [String: Any] = ["id": hostVC.staffDetails?.id ?? 0,
                                    "profile_pic": hostVC.selectedImageUrl,
                                    "full_name": hostVC.fullNameInEnglishTF.text ?? "",
                                    "name_ar": hostVC.fullNameInArabicTF.text ?? "",
                                    "country_code": hostVC.countryCode,
                                    "mobile": hostVC.mobileTF.text ?? "",
                                    "email": hostVC.emailTF.text ?? "",
                                    "password": hostVC.passwordTxtField.text ?? "",
                                    "select_category": hostVC.selectedRoleId,
                                    "menu_id": modulesArray]
        WebService.sharedInstance.updateSellerModulesService(param){ [weak self] response in
            guard let self = self else { return }
            CommonUtils.showToast(message: "Staff is updated successfully")
            self.hostVC.navigationController?.popViewController(animated: true)
        }
    }
    
    func getAllRolesRequest() {
        WebService.sharedInstance.getAllRolesService{ [weak self] response in
            guard let self = self else { return }
            self.hostVC.roles = response
            self.hostVC.roleSelectionCollectionView.reloadData()
        }
    }
}
