//
//  AuthenticationWebService.swift
//  CurveUserApp
//
//  Created by fluper on 01/05/24.
//

import Foundation
import UIKit
import Alamofire

extension WebService {
    func signUpService(withParams dictParams: Dictionary<String, Any>,
                      completion:@escaping (_ user:SignUpModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.createAccount), requestMethod: .post, requestParams: dictParams,encoding: JSONEncoding.default, requestModel:SignUpModel.self) { result, code in
            
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                
                //kSharedUserDefaults.saveValue(Key: .accessToken, value: String.getString(user.access_token))
               // kSharedUserDefaults.saveModelFor(key: .user, value: user)
              //  Global.shared.user = user
                CommonUtils.showToast(message: message ?? "OTP sent succesfully")
                completion(user)
            }
        }
    }
    
    func otpVerificationService(withParams dictParams: Dictionary<String, Any>,
                      completion:@escaping (_ user:User)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.otpVerification), requestMethod: .post, requestParams: dictParams,encoding: JSONEncoding.default,requestModel:User.self) { result, code in
            
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                kSharedUserDefaults.saveValue(Key: .accessToken, value: String.getString(user.accessToken))
                print(user)
                kSharedUserDefaults.saveModelFor(key:.user, value: user)
                CommonUtils.showToast(message: "OTP verify succesfully")
                completion(user)
            }
        }
    }
    
    func resendOtpService(withParams dictParams: Dictionary<String, Any>,
                      completion:@escaping (_ user:User)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.resendOtp), requestMethod: .post, requestParams: dictParams,encoding: JSONEncoding.default,requestModel:User.self) { result, code in
            
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                kSharedUserDefaults.saveValue(Key: .accessToken, value: String.getString(user.accessToken))
                print(user)
                kSharedUserDefaults.saveModelFor(key:.user, value: user)
                CommonUtils.showToast(message: "OTP resent succesfully")
                completion(user)
            }
        }
    }
    
    func storeInformationService(withParams dictParams: Dictionary<String, Any>,
                      completion:@escaping (_ user:StoreInfoModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.storeInformation), requestMethod: .post, requestParams: dictParams,encoding: JSONEncoding.default,requestModel:StoreInfoModel.self) { result, code in
            
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
               // kSharedUserDefaults.saveValue(Key: .accessToken, value: String.getString(user.access_token))
                print(user)
                //kSharedUserDefaults.saveModelFor(key:.user, value: user)
                CommonUtils.showToast(message: message ?? "Bank Store information Save succesfully")
                completion(user)
            }
        }
    }
    
    func uploadDocumentService(withParams dictParams: Dictionary<String, Any>,
                               completion:@escaping (_ user:UploadDocumentModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.uploadDocument), requestMethod: .post, requestParams: dictParams,encoding: JSONEncoding.default,requestModel:UploadDocumentModel.self) { result, code in
            
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                // kSharedUserDefaults.saveValue(Key: .accessToken, value: String.getString(user.access_token))
                print(user)
                //kSharedUserDefaults.saveModelFor(key:.user, value: user)
                CommonUtils.showToast(message: message ?? "Documents and bank details save succesfully")
                completion(user)
            }
        }
    }
    
    func summaryService(withParams dictParams: Dictionary<String, Any>,
                      completion:@escaping (_ user:SummaryModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.summary), requestMethod: .post, requestParams: dictParams,encoding: JSONEncoding.default,requestModel:SummaryModel.self) { result, code in
            
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
               // kSharedUserDefaults.saveValue(Key: .accessToken, value: String.getString(user.access_token))
                print(user)
              //  kSharedUserDefaults.saveModelFor(key:.user, value: user)
                CommonUtils.showToast(message: message ?? "")
                completion(user)
            }
        }
    }
    
    func submitSummaryService(withParams dictParams: Dictionary<String, Any>,
                      completion:@escaping (_ user:User)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.submitSummary), requestMethod: .post, requestParams: dictParams,encoding: JSONEncoding.default,requestModel:User.self) { result, code in
            
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
               // kSharedUserDefaults.saveValue(Key: .accessToken, value: String.getString(user.access_token))
                print(user)
                //kSharedUserDefaults.saveModelFor(key:.user, value: user)
                CommonUtils.showToast(message: message ?? "")
                completion(user)
            }
        }
    }
    
    
    func loginService(withParams dictParams: Dictionary<String, Any>,
                      completion:@escaping (_ user:User)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.login), requestMethod: .post, requestParams: dictParams,encoding: JSONEncoding.default,requestModel:User.self) { result, code in
            
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                kSharedUserDefaults.saveValue(Key: .accessToken, value: String.getString(user.accessToken))
                kSharedUserDefaults.saveModelFor(key:.user, value: user)
                CommonUtils.showToast(message: message ?? "")
                completion(user)
            }
        }
    }
    
    func forgotPasswordService(withParams dictParams: Dictionary<String, Any>,
                      completion:@escaping (_ user:User)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.forgotPassword), requestMethod: .post, requestParams: dictParams,encoding: JSONEncoding.default,requestModel:User.self) { result, code in
            
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
               // kSharedUserDefaults.saveValue(Key: .accessToken, value: String.getString(user.access_token))
                print(user)
                kSharedUserDefaults.saveModelFor(key:.user, value: user)
                CommonUtils.showToast(message: message ?? "")
                completion(user)
            }
        }
    }
    
    func createPasswordService(withParams dictParams: Dictionary<String, Any>,
                      completion:@escaping (_ user:User)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.createAccount), requestMethod: .post, requestParams: dictParams,encoding: JSONEncoding.default,requestModel:User.self) { result, code in
            
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
               // kSharedUserDefaults.saveValue(Key: .accessToken, value: String.getString(user.access_token))
                print(user)
                kSharedUserDefaults.saveModelFor(key:.user, value: user)
                CommonUtils.showToast(message: message ?? "")
                completion(user)
            }
        }
    }
    
    func logoutService(completion:@escaping (_ user:EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.logout), requestMethod: .get,requestModel:EmptyModel.self) { result, code in
            
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
               // kSharedUserDefaults.saveValue(Key: .accessToken, value: String.getString(user.access_token))
                print(user)
                //kSharedUserDefaults.saveModelFor(key:.user, value: user)
                CommonUtils.showToast(message: message ?? "")
                completion(user)
            }
        }
    }
    
    func countryListService(completion:@escaping (_ user:[CountryModel])-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.country), requestMethod: .get,requestModel:[CountryModel].self) { result, code in
            
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(user)
            }
        }
    }
    
    func getPlansListService(completion:@escaping (_ user:[GetPlansSubscriptionModel])-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.getPlans), requestMethod: .get,requestModel:[GetPlansSubscriptionModel].self) { result, code in
            
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(user)
            }
        }
    }
    
    func purchasePlansListService(param: [String: Any], completion:@escaping (_ user:PurchasePlanDataModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.purchasePlan), requestMethod: .post, requestParams: param, requestModel:PurchasePlanDataModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(user)
            }
        }
    }
    
    func completePurchasePlansListService(param: [String: Any], completion:@escaping (_ user:PurchasePlanDataModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.subcriptionPlan), requestMethod: .post, requestParams: param, requestModel:PurchasePlanDataModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(user)
            }
        }
    }
    
}
