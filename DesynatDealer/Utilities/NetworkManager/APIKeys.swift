import Foundation

struct APIKeys {
    //Header
    static let accessToken      = "Authorization"
    
    //Signup
    static let profilePic          = "profile_pic"
    static let firstName           = "first_name"
    static let lastName            = "last_name"
    static let countryCode         = "country_code"
    static let mobile              = "mobile"
    static let email               = "email"
    static let password            = "password"
    static let confirmPassword     = "confirm_password"
    static let acceptTerms         = "accept_terms"
    static let deviceType          = "device_type"
    static let deviceToken         = "device_token"
    
    //OTP
    static let userId              = "user_id"
    static let otp                 = "otp"
    static let type                = "type"
    
    //storeInfo
    static let storeImage          = "store_image"
    static let storeName           = "store_name"
    static let country             = "country"
    static let storeAddress        = "store_address"
    static let addressLine1        = "address_line1"
    static let addressLine2        = "address_line2"
    static let storePhone          = "store_phone"
    static let storeMailID         = "store_mail_id"
    static let bio                 = "bio"
    static let lat                 = "let"
    static let long                = "long"
    
    //UploadDocuInfo
    static let ownerDocument      = "owner_document"
    static let storeDocument      = "store_document"
    static let accountType        = "account_type"
    static let iban               = "iban"
    static let swift              = "swift"
    static let bankName           = "bank_name"
    static let accountHolderName  = "account_holder_name"
    static let uploadProof        = "upload_proof"
    
    //Login
    static let emailMobile       = "email_mobile"
    static let id                = "id"
}
