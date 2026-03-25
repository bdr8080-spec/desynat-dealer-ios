//
//  SubscribtionAndNotification.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 19/03/26.
//

import Foundation
import UIKit

extension  WebService{
    
//    func getSubscriptionPlanService(completion:@escaping (_ user: EmptyModel)-> Void) {
//        CommonUtils.showHud(show: true)
//        NetworkManager.shared.request(withAPI:.endpoint(.cancelLiveCoverageRequest), requestMethod: .get,  requestModel: EmptyModel.self) { result, code in
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
//    
//    func purchaseSubscriptionPlanService(param: [String :Any], completion:@escaping (_ user: EmptyModel)-> Void) {
//        CommonUtils.showHud(show: true)
//        NetworkManager.shared.request(withAPI:.endpoint(.cancelLiveCoverageRequest), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
    func getNotificationListService(param: [String :Any], completion:@escaping (_ user: NotificationsListDataModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.getNotifications), requestMethod: .get, requestParams: param,  requestModel: NotificationsListDataModel.self) { result, code in
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
    
    func markReadNotificationsService(param: [String :Any], completion:@escaping (_ user: EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.markReadNotification), requestMethod: .post,requestParams: param,  requestModel: EmptyModel.self) { result, code in
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
    
    func markAllReadNotificationsService(param: [String :Any], completion:@escaping (_ user: EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.markAllReadNotification), requestMethod: .post,requestParams: param,  requestModel: EmptyModel.self) { result, code in
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
    
    func getMyPlansListService(param: [String :Any], completion:@escaping (_ user: MySubscriptionPlanDataModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.myPlanList), requestMethod: .get, requestParams: param,  requestModel: MySubscriptionPlanDataModel.self) { result, code in
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
    
    func renewSubscriptionPlanService(param: [String :Any], completion:@escaping (_ user: EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.renewSubcriptionPlanBuy), requestMethod: .post, requestParams: param,  requestModel: EmptyModel.self) { result, code in
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
