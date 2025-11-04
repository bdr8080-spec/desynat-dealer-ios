//
//  StringConstant.swift
//  ChorApp
//
//  Created by Developer on 05/12/23.
//

import Foundation

enum StringConstant: String {
    case ok                         = "Ok"
    case done                       = "Done"
    case cancel                     = "Cancel"
    
    func value() -> String {
        return self.rawValue
    }
}

enum AlertConstant: String {
    case none = ""
    /// Network validation
    case noInternet                 = "Network connection failed. Please check your internet and try again."
    case noStatusCode               = "No status code found"
    case noResponse                 = "No response data"
    case wentWrong                  = "Something went wrong"
    case noDataFound                = "No data found"
    case unableToDecode             = "Unable to decode data"
    case sessionExpired             = " Your session has expired. Please log in again."
    case imageMimeNotSame           = "Mime type and file are not of same data type"
    case videoMimeNotSame           = "Video Mime type and file are not URL"
    case decodingError              = "Failed to decode response"
    
    ///Validation Error Message
    case EnterEmailOrMobileNumber   = "Please Enter Mobile Number or Email Address"
    case EnterEmail                 = " Please Enter Email Address"
    case EnterMobileNumber          = "Please Enter Mobile Number"
    case EnterValidEmailAddress     = " Please Enter Valid Email Address"
    case validMobileNumber          = "Please enter valid mobile number"
    case EnterValidEmailorMobile    = "Please Enter Valid Email ID or Mobile Number"
    case EnterPassword              = "Please enter password"
    case InvalidPasswordFormat      = "Password must be at least 8 characters long, include 1 uppercase, 1 lowercase, and 1 special character"
    case EnterNewPassword           = "Please enter a new password"
    case EnterConfirmPassword       = "Please enter confrim password"
    case PasswordNotMatched         = "Password does not match"
    case SelectProfileImage         = "Please upload profile image"
    case EnterFirstName             = "Please Enter First name"
    case EnterLastName              = "Please Enter Last name"
    case AcceptTermsAndConditions   = "Please accept the Terms & Conditions to continue"
    case EnterStoreName             = "Please enter store name"
    case EnterStoreAddress          = "Please enter store address"
    case EnterAddressLine1          = "Please enter address line 1"
    case EnterAddressLine2          = "Please enter address line 2"
    case EnterPhoneNumber           = "Please enter phone number"
    case EnterValidStoreMobileNumber = "Please enter valid store phone number"
    case EnterStoreEmail            = "Please enter Store Email Address"
    case EnterValidStoreEmailAddress = "Please enter valid store email address"
    case EnterBio                   = "Please enter store bio"
    case UploadStoreImage           = "Please upload store image"
    case UploadOwnerDoc1            = "Please upload owner document 1"
    case UploadOwnerDoc2            = "Please upload owner document 2"
    case UploadStoreDoc1            = "Please upload store document 1"
    case UploadStoreDoc2            = "Please upload store document 2"
    case UploadAccountHolderImage   = "Please upload proof of account"
    case SelectAccountType          = "Please select an account type"
    case EnterIBAN                  = "Please enter IBAN number"
    case EnterSWIFT                 = "Please enter SWIFT/BIC code"
    case EnterBankName              = "Please enter bank name"
    case EnterAccountHolder         = "Please enter account holder name"
    case EnterStorePhoneNumber      = "Please enter store phone number"
    case EnterCountry               = "Please choose Country"

func value() -> String {
    return self.rawValue
}
}

struct MatchCharacterConstant {
    static let capitalAlphabet      = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    static let smallAlphabet        = "abcdefghijklmnopqrstuvwxyz"
    static let spacialCharacter     = "@._!#$%^&*()/<>'+,:;=?[]{}|~`-\""
    static let number               = "0123456789"
    static let timing               = number + ":"
    static let cardExpiration       = number + "/"
}


