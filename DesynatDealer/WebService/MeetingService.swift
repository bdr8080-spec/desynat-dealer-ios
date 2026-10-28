//
//  MeetingService.swift
//  TLP-APP
//
//  Created by Mohd Faizan on 01/08/25.
//

import Foundation
import UIKit
import Alamofire

extension WebService{
    func goToLiveStream(param: [String:Any], completion:@escaping (_ user: AgroaTokenDataModel)-> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.goLive), requestMethod: .post, requestParams: param, requestModel: AgroaTokenDataModel.self) { result, code in
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
    
    func delaersLiveService(completion: @escaping([ShowLiveEvenetsDataModel]) -> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI: .endpoint(.getDealersLiveList), requestMethod: .get, requestModel: [ShowLiveEvenetsDataModel].self) { result, code in
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
    
    func getAllLiveStramingService(completion:@escaping (_ user: LiveStramingDataModel)-> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.liveRoomRecordForAgroa), requestMethod: .get, requestModel: LiveStramingDataModel.self) { result, code in
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
    
    func getAllTransactionsServices(param: [String: Any], completion:@escaping (_ user: AllTransactionPayoutModel)-> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.getAllTransactions), requestMethod: .get, requestParams: param, requestModel: AllTransactionPayoutModel.self) { result, code in
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
    
    func getAllMyPayoutsServices(param: [String: Any], completion:@escaping (_ user: MyPayoutDataModel)-> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.myPayoutList), requestMethod: .get, requestParams: param, requestModel: MyPayoutDataModel.self) { result, code in
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

