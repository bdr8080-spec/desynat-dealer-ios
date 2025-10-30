import Foundation
import Alamofire
import UIKit

struct MultipartUpload {
    
    enum Mime:String {
        case Video = "video/mp4"
        case image = "image/jpeg"
        case pdf   = "application/pdf"
    }
    
    var fileName:String
    var file:Any
    var mimeType:Mime
    
    init(fileName: String, file: Any, mimeType: Mime) {
        self.fileName = fileName
        self.file = file
        self.mimeType = mimeType
    }
}

enum NetworkError: Error {
    case noResponseData
    case invalidResponse(ErrorResponse?)
    case noStatusCode
    case sessionExpired
    case noNetwork
    case decoding(Error?)
    case custom(code:Int?)
}

extension NetworkError : LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .noResponseData:
            return NSLocalizedString(AlertConstant.noResponse.value().localiz(), comment: "")
        case .invalidResponse(let err):
            return NSLocalizedString(err?.message ?? AlertConstant.wentWrong.value().localiz(), comment: "")
        case .sessionExpired:
            return NSLocalizedString(AlertConstant.sessionExpired.value().localiz(), comment: "")
        case .noStatusCode:
            return NSLocalizedString(AlertConstant.noStatusCode.value().localiz(), comment: "")
        case .noNetwork:
            return NSLocalizedString(AlertConstant.noInternet.value().localiz(), comment: "")
        case .decoding(let err):
            return NSLocalizedString(err?.localizedDescription ?? AlertConstant.decodingError.value().localiz(), comment: "")
        case .custom(code: let code):
            if code == 1 {
                return NSLocalizedString(AlertConstant.imageMimeNotSame.value().localiz(), comment: "")
            } else {
                return NSLocalizedString(AlertConstant.videoMimeNotSame.value().localiz(), comment: "")
            }
        }
    }
}

struct BaseResponse<T: Decodable>: Decodable {
    var data: T
    var code:HTTPStatusCode?
    var success: Bool?
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case data
        case success
        case message
    }
}

struct ErrorResponse: Decodable {
    var code:HTTPStatusCode?
    var detail:[ErrorDetailResponse]?
    var error: String?
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case code, error, message
        case detail = "details"
    }
}

struct ErrorDetailResponse: Decodable {
    var message:String?
}


enum HTTPStatusCode: Int, Decodable {
    case NoNetwork                = 00
    case SUCCESS                  = 200
    case CREATED                  = 201
    case ACCEPTED                 = 202
    case NO_CONTENT               = 204
    case UNAUTHORIZED             = 401
    case BAD_REQUEST              = 400
    case FORBIDDEN                = 403
    case NOT_FOUND                = 404
    case METHOD_NOT_ALLOWED       = 405
    case DATA_EXIST               = 406
    case CONFLICT                 = 409
    case INTERNAL_SERVER_ERROR    = 500
    
    static let Sucess = [SUCCESS, CREATED, ACCEPTED, NO_CONTENT]
    static let Failure = [BAD_REQUEST, FORBIDDEN, NOT_FOUND, METHOD_NOT_ALLOWED, DATA_EXIST, CONFLICT, INTERNAL_SERVER_ERROR]
}
