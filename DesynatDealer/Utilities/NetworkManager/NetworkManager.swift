import Foundation
import Alamofire
import UIKit

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    typealias ResultHandler<T:Decodable> = (_ result:Result<T, NetworkError>, _ code:HTTPStatusCode?) -> Void
    
    /// Request Network API
    /// - Parameters:
    ///   - url: pass network url
    ///   - method: method for network API
    ///   - param: Optional Value, pass paramater in dictionay format
    ///   - model: model to parse
    ///   - completion: ResultHandler, will provide sucess/failure
    func request<T: Decodable>(withAPI apiName: NetworkURL, 
                               requestMethod method: HTTPMethod = .get,
                               requestParams params: Dictionary<String, Any>? = nil,
                               encoding:ParameterEncoding? = URLEncoding.default,
                               requestModel model: T.Type,kkk
                               completion: @escaping ResultHandler<BaseResponse<T>>) {
        
        guard NetworkReachabilityManager()?.isReachable == true else {
            completion(.failure(.noNetwork), nil)
            return
        }
        
        let header = getHeaders()
        
        var url = ""
        switch apiName {
        case .endpoint(let networkEndPoint):
            url = networkEndPoint.withBaseURL()
        case .custom(let string):
            url = BaseURL.value() + string
        }
        let printableParams: String = self.getPrintableParamsFromJson(postData: params ?? [:])
        printInConsole("Header: \(header)")
        printInConsole("Connecting to Host with URL \(url) with parameters: \(printableParams)")
        
        AF.request(url, method: method, parameters: params, encoding: encoding ?? URLEncoding.default, headers: header){ $0.timeoutInterval = 20.0 }.responseDecodable(of: BaseResponse<T>.self) { response in
            
            printInConsole(response.debugDescription)
            let status = HTTPStatusCode(rawValue: response.response?.statusCode ?? 200) ?? .FORBIDDEN
            
            switch response.result {
            case .success(let result):
                if HTTPStatusCode.Sucess.contains(status) {
                    completion(.success(result), status)
                } else {
                    if status == .UNAUTHORIZED {
                        completion(.failure(.sessionExpired), status)
                    } else {
                        self.ErrorResponseHandle(response: response.data) { errResponse in
                            completion(.failure(.invalidResponse(errResponse)), status)
                        }
                    }
                }
            case .failure(let err):
                if status == .UNAUTHORIZED {
                    completion(.failure(.sessionExpired), status)
                } else if HTTPStatusCode.Failure.contains(status) {
                    self.ErrorResponseHandle(response: response.data) { errResponse in
                        completion(.failure(.invalidResponse(errResponse)), status)
                    }
                } else {
                    completion(.failure(.decoding(err)), status)
                }
            }
        }
    }
    
    /// Request Multi part, upload Images/Videos
    /// - Parameters:
    ///   - url: network URL
    ///   - param: Optional Value, pass paramater in dictionay format
    ///   - model: model to parse
    ///   - handleErr: Wether Network Support will handle error on its own
    ///   - completion: ResultHandler, will provide sucess/failure
    public func requestMultiPart<T:Decodable> (url: NetworkURL, 
                                               assets: [MultipartUpload],
                                               param:Dictionary<String, Any>? = nil,
                                               model: T.Type,
                                               completion: @escaping ResultHandler<BaseResponse<T>>) {
        guard NetworkReachabilityManager()?.isReachable == true else {
            completion(.failure(.noNetwork), nil)
            return
        }
        let header = getHeaders()
        
        var networkUrl = ""
        switch url {
        case .endpoint(let networkEndPoint):
            networkUrl = networkEndPoint.withBaseURL()
        case .custom(let string):
            networkUrl = BaseURL.value() + string
        }
        
        AF.upload(multipartFormData: { multipartFormData in
            assets.forEach { uploadData in
                if uploadData.mimeType == .image {
                    print("FILE NAME\(uploadData.file as? UIImage)")
                    print("FILE NAME\(uploadData.file)")
                    print("FILE NAME\(uploadData)")
                    if let file = uploadData.file as? UIImage, let imageData = file.jpegData(compressionQuality: 0.4) {
                        multipartFormData.append(imageData, withName: uploadData.fileName, fileName: "\(UUID().uuidString).jpeg", mimeType: uploadData.mimeType.rawValue)
                    } else {
                        completion(.failure(.custom(code: 1)), nil)
                    }
                    
                } else if uploadData.mimeType == .Video {
                    
                    if let file = uploadData.file as? URL {
                        multipartFormData.append(file, withName: uploadData.fileName, fileName: "\(UUID().uuidString).mp4", mimeType: uploadData.mimeType.rawValue)
                    } else {
                        completion(.failure(.custom(code: 2)), nil)
                    }
                }
            }
            if let param {
                for (key, value) in param {
                    if let temp = value as? String {
                        multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? Int {
                        multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? NSArray {
                        temp.forEach({ element in
                            let keyObj = key + "[]"
                            if let string = element as? String {
                                multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                            } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        })
                    }
                }
            }
        }, to: networkUrl, headers: header).responseDecodable(of: BaseResponse<T>.self) { response in
            
            printInConsole(response.debugDescription)
            let status = HTTPStatusCode(rawValue: response.response?.statusCode ?? 200) ?? .FORBIDDEN
            
            switch response.result {
            case .success(let result):
                if HTTPStatusCode.Sucess.contains(status) {
                    completion(.success(result), status)
                } else {
                    if status == .UNAUTHORIZED {
                        completion(.failure(.sessionExpired), status)
                    } else {
                        self.ErrorResponseHandle(response: response.data) { errResponse in
                            completion(.failure(.invalidResponse(errResponse)), status)
                        }
                    }
                }
            case .failure(let err):
                completion(.failure(.decoding(err)), status)
            }
        }
    }
    
    /// returns header details
    private func getHeaders() -> HTTPHeaders {
        var headers: HTTPHeaders = []
        if let accessToken = kSharedUserDefaults.getStringFor(key: .accessToken) {
            let bearerToken = "Bearer \(accessToken)"
            headers.add(HTTPHeader(name: APIKeys.accessToken, value: bearerToken))
        }
        
        //Add Session Token
        if let sessionToken = kSharedUserDefaults.getStringFor(key: .sessionToken) {
            headers.add(name: "session_token", value: sessionToken)
        }
    
        return headers
    }
    
    private func ErrorResponseHandle(response:Data?,
                                     completion: @escaping (ErrorResponse?)->Void) {
        do {
            if let jsonResponse = response {
                let responseObj = try JSONDecoder().decode(ErrorResponse.self, from: jsonResponse)
                completion(responseObj)
            } else {
                completion(nil)
                return
            }
        } catch {
            completion(nil)
        }
    }
    
    private func getPrintableParamsFromJson(postData: Dictionary<String, Any>) -> String  {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: postData, options: JSONSerialization.WritingOptions.prettyPrinted)
            let theJSONText = String(data: jsonData, encoding: String.Encoding.ascii)
            return theJSONText ?? ""
        } catch let error as NSError {
            print( error)
            return ""
        }
    }
}
