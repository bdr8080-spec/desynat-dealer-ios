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
    
    
}
