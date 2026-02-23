////
////  ProfileWebService.swift
////  Sharekni
////
////  Created by Meet Goti on 02/01/24.
////
//
import Foundation
import Alamofire
import UIKit

extension WebService {
    func uploadImage(withParams image: UIImage,
                     completion:@escaping (_ profileURL:UploadImageModel)-> Void) {
        CommonUtils.showHud(show: true)
        let multiPart:MultipartUpload = MultipartUpload(fileName:"image", file: image, mimeType: .image)
        NetworkManager.shared.requestMultiPart(url: .endpoint(.uploadImage), assets: [multiPart], model:UploadImageModel.self) { result, code in
            CommonUtils.showHud(show: false)
            self.evaluateWebServiceResponse(response: result) { response,message ,error in
                guard let profileURLString = response else {
                    if let error {
                        UIApplication.shared.topViewController()?.showAlert(msg: error)
                    }
                    return
                }
                DispatchQueue.main.async {
                    completion(profileURLString)
                }
            }
        }
    }
    
    // M8 Live Coverage Request
    func getLiveCoverageRequest(param: [String :Any], completion:@escaping (_ user: LiveCoverageRequestDataModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.getliveCoverageRequest), requestMethod: .get, requestParams: param, requestModel: LiveCoverageRequestDataModel.self) { result, code in
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
    
    func cancelLiveCoverageRequest(param: [String :Any], completion:@escaping (_ user: EmptyModel)-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.cancelLiveCoverageRequest), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
    
    func getTimeSlotsRequest(param: [String :Any], completion:@escaping (_ user: [GetTimeSlotsDataModel])-> Void) {
        CommonUtils.showHud(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.getTimeSlotsRequest), requestMethod: .get, requestParams: param, requestModel: [GetTimeSlotsDataModel].self) { result, code in
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
    
    func sendTimeSlotsRequest(param: [String :Any], completion:@escaping (_ user: EmptyModel)-> Void) {
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
