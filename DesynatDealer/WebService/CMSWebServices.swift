//
//  CMSWebServices.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 22/04/26.
//

import Foundation
import Alamofire
import UIKit
extension WebService {
    
    func getTermsConditionService(parameter:[String:Any],completion: @escaping(CMSTermsConditionDataModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.termsAndCondition),requestMethod: .get, requestParams: parameter,requestModel: CMSTermsConditionDataModel.self) { result, code in
            Shimmer.shared.show(show: false)
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
    func getReturnPolicyService(parameter:[String:Any],completion: @escaping(CMSTermsConditionDataModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.returnPolicy),requestMethod: .get, requestParams: parameter,requestModel: CMSTermsConditionDataModel.self) { result, code in
            Shimmer.shared.show(show: false)
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
    
    func getAboutUsPolicyService(parameter:[String:Any],completion: @escaping(CMSTermsConditionDataModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.aboutUs),requestMethod: .get, requestParams: parameter,requestModel: CMSTermsConditionDataModel.self) { result, code in
            Shimmer.shared.show(show: false)
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
    func getCancellationPolicyService(parameter:[String:Any],completion: @escaping(CMSTermsConditionDataModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.cancellationPolicy),requestMethod: .get, requestParams: parameter,requestModel: CMSTermsConditionDataModel.self) { result, code in
            Shimmer.shared.show(show: false)
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
    
    func getExchangePolicyService(parameter:[String:Any],completion: @escaping(CMSTermsConditionDataModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.exchangePolicy),requestMethod: .get, requestParams: parameter,requestModel: CMSTermsConditionDataModel.self) { result, code in
            Shimmer.shared.show(show: false)
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
    
    
    
    func getFaqService(parameter:[String:Any],completion: @escaping([FAQListDataModel]) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getFAQ),requestMethod: .get, requestParams: parameter,requestModel: [FAQListDataModel].self) { result, code in
            Shimmer.shared.show(show: false)
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
    func updatePushNotificationSettingService(completion: @escaping(NotificationDataModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.pushNotificationOnOff),requestMethod: .post, requestModel: NotificationDataModel.self) { result, code in
            Shimmer.shared.show(show: false)
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
    
    func updateInAppNotificationSettingService(completion: @escaping(NotificationDataModel) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.inAppNotificationOnOff),requestMethod: .post, requestModel: NotificationDataModel.self) { result, code in
            Shimmer.shared.show(show: false)
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
    
    func getRefundManagementRequest(param: [String :Any], completion:@escaping (_ user: RefundManagementDataModel)-> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.getRefundOrder), requestMethod: .get, requestParams: param, requestModel: RefundManagementDataModel.self) { result, code in
            Shimmer.shared.show(show: false)
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
    
    func getOrdersCountDetails(completion:@escaping (_ user: Int)-> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getNewOrderCount), requestMethod: .get, requestModel: Int.self) { result, code in
            Shimmer.shared.show(show: false)
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
    
    func readOrderCount(completion:@escaping (_ user: EmptyModel)-> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.readNewOrderCount), requestMethod: .post, requestModel: EmptyModel.self) { result, code in
            Shimmer.shared.show(show: false)
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
