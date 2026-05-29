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
//                print(user)
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
//                print(user)
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
//                print(user)
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
//                print(user)
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
//                print(user)
                //  kSharedUserDefaults.saveModelFor(key:.user, value: user)
                //                CommonUtils.showToast(message: message ?? "")
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
//                print(user)
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
//                print(user)
                kSharedUserDefaults.saveModelFor(key:.user, value: user)
                CommonUtils.showToast(message: "OTP sent succesfully")
                completion(user)
            }
        }
    }
    
    func createPasswordService(withParams dictParams: Dictionary<String, Any>,
                               completion:@escaping (_ user:User)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.createPassword), requestMethod: .post, requestParams: dictParams,encoding: JSONEncoding.default,requestModel:User.self) { result, code in
            
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message,error in
                guard let user = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                // kSharedUserDefaults.saveValue(Key: .accessToken, value: String.getString(user.access_token))
//                print(user)
                kSharedUserDefaults.saveModelFor(key:.user, value: user)
                CommonUtils.showToast(message: message ?? "")
                completion(user)
            }
        }
    }
    
    func logoutService(completion:@escaping (_ user: EmptyModel)-> Void) {
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
    
//    func completePurchasePlansListService(param: [String: Any], completion:@escaping (_ user:PurchasePlanDataModel)-> Void) {
//        CommonUtils.showHud(show: true)
//        NetworkManager.shared.request(withAPI:.endpoint(.subcriptionPlan), requestMethod: .post, requestParams: param, requestModel:PurchasePlanDataModel.self) { result, code in
//            CommonUtils.showHud(show: false)
//            self.evaluateWebServiceResponse(response: result) { response, message,error in
//                guard let user = response else {
//                    if let error {
//                        UIApplication.shared.topViewController()?.showAlert(msg: error)
//                    }
//                    return
//                }
//                completion(user)
//            }
//        }
//    }
    
    func completePurchasePlansListService(
        param: [String: Any],
        completion: @escaping (_ user: PurchasePlanDataModel?, _ error: String?) -> Void
    ) {
        
        CommonUtils.showHud(show: true)
        
        NetworkManager.shared.request(
            withAPI: .endpoint(.subcriptionPlan),
            requestMethod: .post,
            requestParams: param,
            requestModel: PurchasePlanDataModel.self
        ) { result, code in
            
            CommonUtils.showHud(show: false)
            
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                
                guard let user = response else {
                    completion(nil, error ?? message ?? "Something went wrong")
                    return
                }
                
                completion(user, nil)
            }
        }
    }
    
    func storeStatusUpdateService(completion: @escaping (StoreAvailabilityStatusModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.updateStoreStatus), requestMethod: .get, requestModel: StoreAvailabilityStatusModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
    
    func getCountOfNotificationForService(completion:@escaping (_ user: NotificationCountDataModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.countOfNotifcation), requestMethod: .get,requestModel: NotificationCountDataModel.self) { result, code in
            
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
    
    func getCategoriesService(completion:@escaping (_ user:[CategoryDataModel])-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.getCategoryList), requestMethod: .get,requestModel:[CategoryDataModel].self) { result, code in
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
    
    func getSubCategoriesService(param: [String:Any], completion:@escaping (_ user:[SubCategoryDataModel])-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.getSubCategoryList), requestMethod: .get, requestParams: param, requestModel:[SubCategoryDataModel].self) { result, code in
            
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
    
    func getBrandService(completion:@escaping (_ user: [BrandsListDataModel])-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.getBrandsList), requestMethod: .get, requestModel:[BrandsListDataModel].self) { result, code in
            
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
    
    func getColorsListService(completion:@escaping (_ user: [ColorsLisDataModel])-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.getColorsList), requestMethod: .get, requestModel:[ColorsLisDataModel].self) { result, code in
            
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
    
    func getSizeListService(completion:@escaping (_ user: [SizeListDataModel])-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.getSizesList), requestMethod: .get, requestModel:[SizeListDataModel].self) { result, code in
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
    
    func addProductService(param: [String :Any], completion:@escaping (_ user: EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.requestForAddingProduct(withAPI:.endpoint(.addProduct), requestMethod: .post, requestParams: param, requestModel:EmptyModel.self) { result, code in
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
    
    func getProductsListServices(param: [String :Any], completion:@escaping (_ user: ProductsListDataModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.getProductsList), requestMethod: .post, requestParams: param, requestModel:ProductsListDataModel.self) { result, code in
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
    
    func updateProductActiveStatus(param: [String :Any], completion:@escaping (_ user: EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.productsActiveStatus), requestMethod: .put, requestParams: param, requestModel:EmptyModel.self) { result, code in
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
    
    func getProductDetailsService(param: [String:Any], completion:@escaping (_ user:ProductsList)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.getProductsDetails), requestMethod: .post, requestParams: param, requestModel:ProductsList.self) { result, code in
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
    
    func deleteProductDetailsService(param: [String:Any], completion:@escaping (_ user:EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.deleteProductsDetails), requestMethod: .delete, requestParams: param, requestModel:EmptyModel.self) { result, code in
            
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
    
    func editProductService(param: [String :Any], completion:@escaping (_ user: EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.requestForAddingProduct(withAPI:.endpoint(.editProductsDetails), requestMethod: .post, requestParams: param, requestModel:EmptyModel.self) { result, code in
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
    
    func getDelearProfileService(completion: @escaping (User) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getSellerProfile), requestMethod: .post, requestModel: User.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
    
    func getUserProfile(completion: @escaping (SellerProfileDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getProfile), requestMethod: .get, requestModel: SellerProfileDataModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
    
    func getMyHighLights(param: [String: Any], completion: @escaping (GetHighLightsDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getMyHighlight), requestMethod: .get,requestParams: param, requestModel: GetHighLightsDataModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
    
    func getMyAllHighLights(completion: @escaping ([GetHighLightsList]) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getMyHighlight), requestMethod: .get, requestModel: [GetHighLightsList].self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
    
    func deleteMyHighLights(param: [String: Any], completion: @escaping (EmptyModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.deleteHightLight), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
    
    func deleteMyStory(param: [String: Any], completion: @escaping (EmptyModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.deleteStory), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
    
    func getMyReels(param: [String: Any], completion: @escaping (GetMyReelsDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getMyReels), requestMethod: .get,requestParams: param, requestModel: GetMyReelsDataModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
    
    func updateStoreInformationRequest(param: [String: Any], completion: @escaping (EmptyModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.updateStoreInformation), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
    
    func updateBankInformationRequest(param: [String: Any], completion: @escaping (EmptyModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.updateBankInformation), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
    
    func getInventoryListServices(param: [String :Any], completion:@escaping (_ user: InventoryListDataModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.allInventoryList), requestMethod: .post, requestParams: param, requestModel:InventoryListDataModel.self) { result, code in
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
    
    func updateInventoryActiveStatus(param: [String :Any], completion:@escaping (_ user: EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.productsActiveStatus), requestMethod: .put, requestParams: param, requestModel:EmptyModel.self) { result, code in
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
    
    func updateInventoryDetails(param: [String :Any], completion:@escaping (_ user: EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.updateInventoryDetails), requestMethod: .put, requestParams: param, requestModel:EmptyModel.self) { result, code in
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
    
    func updateAffiliated(param: [String :Any], completion:@escaping (_ user: EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.updateAffiliatedValue), requestMethod: .put, requestParams: param, requestModel:EmptyModel.self) { result, code in
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
    
    func getBanners(param: [String :Any], completion:@escaping (_ user: [BannerModel])-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.getBanners), requestMethod: .post, requestParams: param, requestModel: [BannerModel].self) { result, code in
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
    
    func addBanners(param: [String :Any], completion:@escaping (_ user: BannerModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.addBanner), requestMethod: .post, requestParams: param, requestModel: BannerModel.self) { result, code in
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
    
    func getBannerPrice(param: [String :Any], completion:@escaping (_ user: [PriceModel])-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.getBannerPrice), requestMethod: .post, requestParams: param, requestModel: [PriceModel].self) { result, code in
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
    
    func bannerPayment(param: [String: Any], completion:@escaping (_ user: PurchasePlanDataModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.bannerPayment), requestMethod: .post, requestParams: param, requestModel: PurchasePlanDataModel.self) { result, code in
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
    
    func getOrdersListServices(param: [String :Any], completion:@escaping (_ user: OrdersListDataModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.ordersList), requestMethod: .post, requestParams: param, requestModel:OrdersListDataModel.self) { result, code in
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
    
    func ordersDetails(param: [String :Any], completion:@escaping (_ user: OrdersListData)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.singleOrderDetails), requestMethod: .post, requestParams: param, requestModel:OrdersListData.self) { result, code in
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
    
    func updateOrdersStatus(param: [String :Any], completion:@escaping (_ user: EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.updateOrderStatus), requestMethod: .post, requestParams: param, requestModel:EmptyModel.self) { result, code in
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
    
    func updateOrdersStatusForExchnageAndReturn(param: [String :Any], completion:@escaping (_ user: EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.updateReturnExchangeStatus), requestMethod: .post, requestParams: param, requestModel:EmptyModel.self) { result, code in
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
    
    //Chat Module
    func getAllChatsList(param: [String: Any], completion:@escaping (_ user: [ChatInboxListModel])-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getAllChatsRecord), requestMethod: .post, requestParams: param, requestModel:[ChatInboxListModel].self) { result, code in
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
    
    func singleChatDetails(param: [String: Any], completion:@escaping (_ user: ChatDetailsDataModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getSingleChats), requestMethod: .post, requestParams: param, requestModel:ChatDetailsDataModel.self) { result, code in
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
    
    func markAllchatThread(param: [String: Any], completion:@escaping (_ user: EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.markAllchatThread), requestMethod: .post, requestParams: param, requestModel:EmptyModel.self) { result, code in
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
    
    func sendNotificationDetails(param: [String: Any], completion:@escaping (_ user: EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.sendNotification), requestMethod: .post, requestParams: param, requestModel:EmptyModel.self) { result, code in
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
    
    func sendMessageInChat(param: [String: Any], completion:@escaping (_ user: SendMessageInChatDataModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.sendInMessageChat), requestMethod: .post, requestParams: param, requestModel: SendMessageInChatDataModel.self) { result, code in
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
    
    func sendQuotatioRequest(param: [String: Any], completion:@escaping (_ user: SendQuotationDataModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.qutationChatEdit), requestMethod: .post, requestParams: param, requestModel:SendQuotationDataModel.self) { result, code in
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
    
    func getDealsListRequest(param: [String: Any], completion:@escaping (_ user: DealsListDataModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getAllDealsList), requestMethod: .post, requestParams: param, requestModel: DealsListDataModel.self) { result, code in
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
    
    func getDealDetailsRequest(param: [String: Any], completion:@escaping (_ user: DealsDetailsDataModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getDealsDetails), requestMethod: .post, requestParams: param, requestModel: DealsDetailsDataModel.self) { result, code in
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
    
    func addProductsInDeal(param: [String: Any], completion:@escaping (_ user: EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.addProductsInDeals), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
    
    func deleteProductsInDeal(param: [String: Any], completion:@escaping (_ user: EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.removeProductsInDeals), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
    
    func getAllSellerModulesService(completion: @escaping ([GetAllSellerData]) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getAllSeller), requestMethod: .get, requestModel: [GetAllSellerData].self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
    
    func addSellerModulesService(_ param:[String:Any],completion: @escaping (EmptyModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.addSeller), requestMethod: .post, requestParams: param,encoding: JSONEncoding.default, requestModel: EmptyModel.self) { result, code in
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
    
    func updateSellerModulesService(_ param:[String:Any],completion: @escaping (EmptyModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.editSeller), requestMethod: .post, requestParams: param,encoding: JSONEncoding.default, requestModel: EmptyModel.self) { result, code in
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
    
    func getSingleStaffDetailService(_ param:[String:Any],completion: @escaping (StaffDetails) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getSingleStaffDetail), requestMethod: .post, requestParams: param, requestModel: StaffDetails.self) { result, code in
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
    
    func deleteStaffService(_ param:[String:Any],completion: @escaping ([GetAllSellerData]) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.deleteStaff), requestMethod: .post, requestParams: param, requestModel: [GetAllSellerData].self) { result, code in
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
    
    func updateActiveInactiveStaffDetailService(_ param:[String:Any],completion: @escaping (StaffDetails) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.activeInactiveStaff), requestMethod: .post, requestParams: param, requestModel: StaffDetails.self) { result, code in
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
    
    func getAllRolesService(completion: @escaping ([GetAllStaffRoles]) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getAllRoles), requestMethod: .get, requestModel: [GetAllStaffRoles].self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
    
    func getAllStaffListService(param: [String:Any], completion: @escaping (StaffManagementDataModel) -> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getAllStaff), requestMethod: .post, requestParams: param, requestModel: StaffManagementDataModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                guard let response = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                completion(response)
            }
        }
    }
}
