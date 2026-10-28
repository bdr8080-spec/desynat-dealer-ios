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
        Shimmer.shared.show(show: true)
        let multiPart:MultipartUpload = MultipartUpload(fileName:"image", file: image, mimeType: .image)
        NetworkManager.shared.requestMultiPart(url: .endpoint(.uploadImage), assets: [multiPart], model:UploadImageModel.self) { result, code in
            Shimmer.shared.show(show: false)
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
    
    func uploadWithResolutionPromotional(withParams file:MultipartUpload,
                                completion:@escaping (_ url:String, _ msg:String?, _ code:HTTPStatusCode?)-> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.requestMultiPart(url: .endpoint(.uploadWithResolutionPromotional), assets: [file], model: UploadFileDataModel.self) { result, code in
            Shimmer.shared.show(show: false)
            self.evaluateWebServiceResponse(response: result) { response, message, error in
                if let url = response?.url {
                    completion(url, message, code)
                } else if let error {
                    UIApplication.shared.topViewController()?.showAlert(msg: error)
                }
            }
        }
    }
    
    // M8 Live Coverage Request
    func getLiveCoverageRequest(param: [String :Any], completion:@escaping (_ user: LiveCoverageRequestDataModel)-> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.getliveCoverageRequest), requestMethod: .get, requestParams: param, requestModel: LiveCoverageRequestDataModel.self) { result, code in
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
    
    func cancelLiveCoverageRequest(param: [String :Any], completion:@escaping (_ user: EmptyModel)-> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.cancelLiveCoverageRequest), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
    
    func getTimeSlotsRequest(param: [String :Any], completion:@escaping (_ user: [GetTimeSlotsDataModel])-> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.getTimeSlotsRequest), requestMethod: .get, requestParams: param, requestModel: [GetTimeSlotsDataModel].self) { result, code in
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
    
    func sendTimeSlotsRequest(param: [String :Any], completion:@escaping (_ user: EmptyModel)-> Void) {
        Shimmer.shared.show(show: true)
        NetworkManager.shared.request(withAPI:.endpoint(.sendLiveCoverageRequest), requestMethod: .post, requestParams: param, requestModel: EmptyModel.self) { result, code in
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
