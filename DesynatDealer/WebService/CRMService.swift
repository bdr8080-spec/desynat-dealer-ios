//
//  CRMService.swift
//  TLP-APP
//
//  Created by Mohd Faizan on 18/07/25.
//

import Foundation
import UIKit
import Alamofire

extension WebService{
    
    func changePasswordService(param: [String :Any], completion:@escaping (_ user: EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.sendLiveCoverageRequest), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
