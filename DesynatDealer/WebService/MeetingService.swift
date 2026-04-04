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
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.goLive), requestMethod: .post, requestParams: param, requestModel: AgroaTokenDataModel.self) { result, code in
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
    
    func getAllLiveStramingService(completion:@escaping (_ user: LiveStramingDataModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.liveRoomRecordForAgroa), requestMethod: .get, requestModel: LiveStramingDataModel.self) { result, code in
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

