//
//  LoginViewModel.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 28/10/25.
//

import Foundation
import UIKit

class LoginViewModel: NSObject {
    
    private var loginHostVC: LoginViewController
    var countryList:[CountryModel] = []
    
    init(loginHostVC: LoginViewController) {
        self.loginHostVC = loginHostVC
    }
    
    func validFields() -> Bool {
        var errorMessage: AlertConstant = .none
        let input = String.getString(loginHostVC.emailTextField.text).trimmingCharacters(in: .whitespacesAndNewlines)
        
        if input.isEmpty {
            errorMessage = .EnterEmailOrMobileNumber
        } else if input.isEmail() {
            if !input.isValidEmail() {
                errorMessage = .EnterValidEmailAddress
            }
        } else if input.isPhoneNumber() {
            if !input.isValidPhoneNumber() {
                errorMessage = .validMobileNumber
            }
        } else {
            errorMessage = .EnterValidEmailorMobile
        }
        
        let password = String.getString(loginHostVC.txtPassword.text).trimmingCharacters(in: .whitespacesAndNewlines)
        
        if errorMessage == .none {
            if password.isEmpty {
                errorMessage = .EnterPassword
            }
//          else if !password.isValidPassword() {
//                errorMessage = .InvalidPasswordFormat
//            }
        }
        
        if errorMessage != .none {
            loginHostVC.showAlert(msg: errorMessage.rawValue)
        }
        
        loginHostVC.view.endEditing(true)
        return errorMessage == .none
    }
    
    func loginApi() {
        let params: [String:Any] = [
            APIKeys.countryCode:loginHostVC.countryCode,
            APIKeys.emailMobile:loginHostVC.emailTextField.text ?? "",
            APIKeys.password: loginHostVC.txtPassword.text ?? "",
            APIKeys.type:loginHostVC.type,
            "lang": LanguageManager.currentLanguageCode,
            "device_type": 1,//0 web 1 ios 2 andriod
            "fcm_token": kSharedUserDefaults.retrieveModelFor(key: .deviceToken, model: String.self) ?? "",
        ]
        WebService.sharedInstance.loginService(withParams: params) { (response) in
            if response.type == "0" {
                if response.storeInformation == "0" {
                    let vc = StoreInformationViewController.instantiate(fromAppStoryboard: .Main)
                    vc.userId = response.id ?? 0
                    self.loginHostVC.navigationController?.pushViewController(vc, animated: true)
                    return
                } else if response.bankInformation == "0" {
                    let vc = UploadDocumnetViewController.instantiate(fromAppStoryboard: .Main)
                    vc.userId = "\(response.id ?? 0)"
                    self.loginHostVC.navigationController?.pushViewController(vc, animated: true)
                } else if response.adminVerify == "0" {
                    let vc = SummaryViewController.instantiate(fromAppStoryboard: .Main)
                    vc.userId = "\(response.id ?? 0)"
                    self.loginHostVC.navigationController?.pushViewController(vc, animated: true)
                } else if response.adminVerify == "1" {
                    kSharedSceneDelegate.navigateToLoginVC()
                    CommonUtils.showToast(message: "Your account registration is under review")
                } else if response.adminVerify == "2" {
                    UserDefaults.standard.setValue("Yes", forKey:"isLogin")
                    kSharedUserDefaults.setSubAdminActionDashboardAccess(hasActionDashboardAccess: true)
                    if response.subcriptionPlanCheck == "1" {
                        kSharedSceneDelegate.navigateToDealerHomeVc()
                    } else {
                        kSharedSceneDelegate.navigateToSubscriptionView(userId: "\(response.id ?? 0)")
                    }
                } else if response.adminVerify == "4"{
                    let vc = UploadDocumnetViewController.instantiate(fromAppStoryboard: .Main)
                    vc.userId = "\(response.id ?? 0)"
                    self.loginHostVC.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                UserDefaults.standard.setValue("Yes", forKey:"isLogin")
                DispatchQueue.main.async {
                    if response.roleAction?.first?.menuID == 1 {
                        kSharedUserDefaults.setSubAdminUserHasDashboardAccess(hasDashboardAccess: true)
                        if response.roleAction?.first?.menuID == 1 && response.roleAction?.first?.canAction == 1 {
                            kSharedUserDefaults.setSubAdminActionDashboardAccess(hasActionDashboardAccess: true)
                        }
                        kSharedSceneDelegate.navigateToDashboardHomeVc()
                    } else {
                        kSharedSceneDelegate.navigateToSideMenuVc()
                    }
                }
            }
        }
    }
    
    
    func countryListApi(){
        WebService.sharedInstance.countryListService { list in
            self.countryList = list
        }
    }
}

