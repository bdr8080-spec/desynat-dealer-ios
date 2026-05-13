import Foundation
import AVFoundation
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
                               requestModel model: T.Type,
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
                            if status == .NO_ACTIVE_PLAN {     // 👈 NEW CONDITION
                                self.ErrorResponseHandle(response: response.data) { errResponse in
                                    
                                    // Show popup globally
                                    DispatchQueue.main.async {
                                        UIApplication.shared.topViewController()?
                                            .showNoActivePlanToast(message: errResponse?.message ?? "")
                                    }
                                    
                                    // DO NOT send failure — avoid double popup
                                    return
                                }
                                
                            }
                            completion(.failure(.invalidResponse(errResponse)), status)
                        }
                    }
                }
            case .failure(let err):
                if status == .UNAUTHORIZED {
                    completion(.failure(.sessionExpired), status)
                } else if status == .NO_ACTIVE_PLAN {     // 👈 NEW CONDITION
                    self.ErrorResponseHandle(response: response.data) { errResponse in
                        
                        // Show popup globally
                        DispatchQueue.main.async {
                            UIApplication.shared.topViewController()?
                                .showNoActivePlanToast(message: errResponse?.message ?? "")
                        }
                        
                        // DO NOT send failure — avoid double popup
                        return
                    }
                    
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
    
    
    
    public func requestMultiPartForPdfImageVideoGif<T:Decodable> (url: NetworkURL,
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
                switch uploadData.mimeType {
                case .image:
                    if let file = uploadData.file as? UIImage, let imageData = file.jpegData(compressionQuality: 0.4) {
                        multipartFormData.append(imageData, withName: uploadData.fileName, fileName: "\(UUID().uuidString).jpeg", mimeType: uploadData.mimeType.rawValue)
                    } else {
                        completion(.failure(.custom(code: 1)), nil)
                    }
                    
                case .Video:
                    if let file = uploadData.file as? URL {
                        multipartFormData.append(file, withName: uploadData.fileName, fileName: "\(UUID().uuidString).mp4", mimeType: uploadData.mimeType.rawValue)
                    } else {
                        completion(.failure(.custom(code: 2)), nil)
                    }
                    
                case .gif:
                    if let data = uploadData.file as? Data {
                        multipartFormData.append(
                            data,
                            withName: uploadData.fileName,
                            fileName: "\(UUID().uuidString).gif",
                            mimeType: uploadData.mimeType.rawValue
                        )
                    } else {
                        completion(.failure(.custom(code: 4)), nil)
                    }
                    
                    
                case .pdf:  // ← Add PDF support
                    if let file = uploadData.file as? URL {
                        multipartFormData.append(file, withName: uploadData.fileName, fileName: file.lastPathComponent, mimeType: "application/pdf")
                    } else if let data = uploadData.file as? Data {
                        multipartFormData.append(data, withName: uploadData.fileName, fileName: "\(UUID().uuidString).pdf", mimeType: "application/pdf")
                    } else {
                        completion(.failure(.custom(code: 3)), nil)
                    }
                }
                
                
            }
            
            // Append other params
            if let param {
                for (key, value) in param {
                    if let temp = value as? String {
                        multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                    } else if let temp = value as? Int {
                        multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                    } else if let temp = value as? NSArray {
                        temp.forEach { element in
                            let keyObj = key + "[]"
                            if let string = element as? String {
                                multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                            } else if let num = element as? Int {
                                multipartFormData.append("\(num)".data(using: .utf8)!, withName: keyObj)
                            }
                        }
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
                if status == .UNAUTHORIZED {
                    completion(.failure(.sessionExpired), status)
                } else if status == .NO_ACTIVE_PLAN {     // 👈 NEW CONDITION
                    self.ErrorResponseHandle(response: response.data) { errResponse in
                        
                        // Show popup globally
                        DispatchQueue.main.async {
                            UIApplication.shared.topViewController()?
                                .showNoActivePlanToast(message: errResponse?.message ?? "")
                        }
                        
                        // DO NOT send failure — avoid double popup
                        return
                    }
                    
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
    
    func requestForAddingProduct<T: Decodable>(withAPI apiName: NetworkURL,
                                               requestMethod method: HTTPMethod = .get,
                                               requestParams params: Dictionary<String, Any>? = nil,
                                               encoding:ParameterEncoding? = JSONEncoding.default,
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
                } else if status == .NO_ACTIVE_PLAN {     // 👈 NEW CONDITION
                    self.ErrorResponseHandle(response: response.data) { errResponse in
                        
                        // Show popup globally
                        DispatchQueue.main.async {
                            UIApplication.shared.topViewController()?
                                .showNoActivePlanToast(message: errResponse?.message ?? "")
                        }
                        
                        // DO NOT send failure — avoid double popup
                        return
                    }
                    
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
    ///
    
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
                if status == .UNAUTHORIZED {
                    completion(.failure(.sessionExpired), status)
                } else if status == .NO_ACTIVE_PLAN {     // 👈 NEW CONDITION
                    self.ErrorResponseHandle(response: response.data) { errResponse in
                        
                        // Show popup globally
                        DispatchQueue.main.async {
                            UIApplication.shared.topViewController()?
                                .showNoActivePlanToast(message: errResponse?.message ?? "")
                        }
                        
                        // DO NOT send failure — avoid double popup
                        return
                    }
                    
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
        
        headers.add(
            name: "Accept-Language",
            value: AppLanguageManager.shared.currentLanguage == .ar ? "ar" : "en"
        )
        
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
    
    public func requestMultiPartForVideoAndAudio<T: Decodable>(
        url: NetworkURL,
        assets: [MultipartUpload],
        param: Dictionary<String, Any>? = nil,
        model: T.Type,
        completion: @escaping ResultHandler<BaseResponse<T>>
    ) {
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
            
            let fieldName = "file"
            
            for uploadData in assets {
                var fileName: String
                var mimeTypeString: String
                var dataToUpload: Data?
                
                switch uploadData.mimeType {
                    
                    // --------------------------------------------
                    // MARK: IMAGE
                    // --------------------------------------------
                case .image:
                    mimeTypeString = "image/jpeg"
                    fileName = "\(UUID().uuidString).jpeg"
                    
                    if let image = uploadData.file as? UIImage,
                       let imageData = image.jpegData(compressionQuality: 0.7) {
                        dataToUpload = imageData
                    }
                    else if let data = uploadData.file as? Data {
                        dataToUpload = data
                    }
                    
                    // --------------------------------------------
                    // MARK: VIDEO (Compression Added Here)
                    // --------------------------------------------
                case .Video:
                    mimeTypeString = "video/mp4"
                    fileName = "\(UUID().uuidString).mp4"
                    
                    // If URL → compress synchronously
                    if let url = uploadData.file as? URL {
                        
                        let compressedURL = self.compressVideoSync(inputURL: url) ?? url
                        
                        // PRINT COMPRESSED SIZE
//                        if let size = try? Data(contentsOf: compressedURL).count {
//                            let kb = Double(size) / 1024.0
//                            let mb = kb / 1024.0
//                            print("📉 Compressed Video Size:")
//                            print("➡ Bytes: \(size)")
//                            print("➡ KB: \(String(format: "%.2f", kb)) KB")
//                            print("➡ MB: \(String(format: "%.2f", mb)) MB")
//                        }
                        
                        multipartFormData.append(
                            compressedURL,
                            withName: fieldName,
                            fileName: fileName,
                            mimeType: mimeTypeString
                        )
                        
                        continue
                    }
                    
                    // If Data → write temp file → compress
                    else if let data = uploadData.file as? Data {
                        
                        let tempURL = FileManager.default
                            .temporaryDirectory
                            .appendingPathComponent("raw_\(UUID().uuidString).mp4")
                        
                        try? data.write(to: tempURL)
                        
                        let compressedURL = self.compressVideoSync(inputURL: tempURL) ?? tempURL
                        
                        // PRINT COMPRESSED SIZE
//                        if let size = try? Data(contentsOf: compressedURL).count {
//                            let kb = Double(size) / 1024.0
//                            let mb = kb / 1024.0
//                            print("📉 Compressed Video Size:")
//                            print("➡ Bytes: \(size)")
//                            print("➡ KB: \(String(format: "%.2f", kb)) KB")
//                            print("➡ MB: \(String(format: "%.2f", mb)) MB")
//                        }
                        
                        multipartFormData.append(
                            compressedURL,
                            withName: fieldName,
                            fileName: fileName,
                            mimeType: mimeTypeString
                        )
                        
                        continue
                    }
                    // --------------------------------------------
                    // MARK: PDF
                    // --------------------------------------------
                case .pdf:
                    mimeTypeString = "application/pdf"
                    fileName = "\(UUID().uuidString).pdf"
                    
                    if let url = uploadData.file as? URL {
                        multipartFormData.append(
                            url,
                            withName: fieldName,
                            fileName: url.lastPathComponent,
                            mimeType: mimeTypeString
                        )
                        continue
                    } else if let data = uploadData.file as? Data {
                        dataToUpload = data
                    }
                    
                default:
                    completion(.failure(.custom(code: 999)), nil)
                    return
                }
                
                // Append raw Data (only images & pdf)
                if let data = dataToUpload {
                    multipartFormData.append(
                        data,
                        withName: fieldName,
                        fileName: fileName,
                        mimeType: mimeTypeString
                    )
                } else {
                    completion(.failure(.custom(code: 888)), nil)
                    return
                }
            }
            
            // TEXT PARAMS (unchanged)
            if let param = param {
                for (key, value) in param {
                    if let stringValue = value as? String {
                        multipartFormData.append(stringValue.data(using: .utf8)!, withName: key)
                    } else if let intValue = value as? Int {
                        multipartFormData.append("\(intValue)".data(using: .utf8)!, withName: key)
                    } else if let arrayValue = value as? NSArray {
                        let arrayKey = key + "[]"
                        for element in arrayValue {
                            if let str = element as? String {
                                multipartFormData.append(str.data(using: .utf8)!, withName: arrayKey)
                            } else if let num = element as? Int {
                                multipartFormData.append("\(num)".data(using: .utf8)!, withName: arrayKey)
                            }
                        }
                    }
                }
            }
            
        }, to: networkUrl, headers: header)
        .responseDecodable(of: BaseResponse<T>.self) { response in
            
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
                } else if status == .NO_ACTIVE_PLAN {     // 👈 NEW CONDITION
                    self.ErrorResponseHandle(response: response.data) { errResponse in
                        
                        // Show popup globally
                        DispatchQueue.main.async {
                            UIApplication.shared.topViewController()?
                                .showNoActivePlanToast(message: errResponse?.message ?? "")
                        }
                        
                        // DO NOT send failure — avoid double popup
                        return
                    }
                    
                } else if HTTPStatusCode.Failure.contains(status) {
                    self.ErrorResponseHandle(response: response.data) { errResponse in
                        completion(.failure(.invalidResponse(errResponse)), status)
                    }
                } else {
                    if status == .NO_ACTIVE_PLAN {     // 👈 NEW CONDITION
                        self.ErrorResponseHandle(response: response.data) { errResponse in
                            
                            // Show popup globally
                            DispatchQueue.main.async {
                                UIApplication.shared.topViewController()?
                                    .showNoActivePlanToast(message: errResponse?.message ?? "")
                            }
                            
                            // DO NOT send failure — avoid double popup
                            return
                        }
                    }
                    completion(.failure(.decoding(err)), status)
                }
            }
        }
    }
    
    func compressVideoSync(inputURL: URL) -> URL? {
        let asset = AVURLAsset(url: inputURL)
        guard let export = AVAssetExportSession(asset: asset,
                                                presetName: AVAssetExportPresetMediumQuality)
        else { return nil }
        
        let outputURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("compressed_\(UUID().uuidString).mp4")
        
        export.outputURL = outputURL
        export.outputFileType = .mp4
        export.shouldOptimizeForNetworkUse = true
        
        let semaphore = DispatchSemaphore(value: 0)
        
        export.exportAsynchronously {
            semaphore.signal()
        }
        
        // Block current thread, NOT main/UI thread.
        semaphore.wait()
        
        return export.status == .completed ? outputURL : nil
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
