//
//  EditProfileViewModel.swift
//  DesynatDealer
//
//  Created by fluper on 05/12/25.
//


import Foundation

class EditProfileViewModel {
  
  private var hostVC: EditProfileViewController
  var countryList:[CountryModel] = []
  var userProfile: SellerProfileDataModel?
  
  init(hostVC: EditProfileViewController) {
    self.hostVC = hostVC
  }
  
  func countryListApi(){
    WebService.sharedInstance.countryListService { list in
      self.countryList = list
    }
  }
  
  func getUserProfile(){
    WebService.sharedInstance.getUserProfile { [weak self] response in
      guard let self else { return }
      userProfile = response
      hostVC.populateData()
    }
  }
  
  func validBankInfoFields() -> Bool {
    var errorMessage: AlertConstant = .none
    //    let iban = String.getString(hostVC.ibanTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
    //    let swiftCode = String.getString(hostVC.swiftTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
    let bankName = String.getString(hostVC.bankNameTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
    let accountHolder = String.getString(hostVC.accountHolderNameTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
    if bankName.isEmpty {
      errorMessage = .EnterBankName
    } else if accountHolder.isEmpty {
      errorMessage = .EnterAccountHolder
    } else if hostVC.bankProofUrl.isEmpty {
      errorMessage = .UploadAccountHolderImage
    }
    if errorMessage != .none {
      hostVC.showAlert(msg: errorMessage.rawValue)
    }
    hostVC.view.endEditing(true)
    return errorMessage == .none
  }
  
  func updateBankDocumentApi(){
    let param: [String: Any] = [
      "bank_name": hostVC.bankNameTF.text ?? "",
      "account_holder_name": hostVC.accountHolderNameTF.text ?? "",
      "account_type": hostVC.accountType,
      "swift": hostVC.swiftTF.text ?? "",
      "iban": hostVC.ibanTF.text ?? "",
      "user_id": userProfile?.id ?? 0,
      "upload_proof": hostVC.bankProofUrl]
    WebService.sharedInstance.updateBankInformationRequest(param:param) { user in
      CommonUtils.showToast(message: "Bank Details is updated")
      DispatchQueue.main.async {
        self.hostVC.navigationController?.popViewController(animated: true)
      }
    }
  }
  
  func validStoreInfoFields() -> Bool {
    var errorMessage: AlertConstant = .none
    
    let firstName = String.getString(hostVC.firsNameTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
    let lastName = String.getString(hostVC.lastNameTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
    let mobile = String.getString(hostVC.mobileTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
    let email = String.getString(hostVC.emailTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
    let storeName = String.getString(hostVC.storeNameTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
    //      let countryName = String.getString(hostVC.contryTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
    let storeAddress = String.getString(hostVC.storeAddressTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
    let addressLine1 = String.getString(hostVC.addressLineOneTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
    let addressLine2 = String.getString(hostVC.addressLineTwoTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
    let phone = String.getString(hostVC.storePhoneTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
    let storeEmail = String.getString(hostVC.storeEmailTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
    let bio = String.getString(hostVC.bioTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
    
    // MARK: - Validation (Strict Order)
    
    // 1) Profile image
    if hostVC.userProfileImageUrl.isEmpty {
      errorMessage = .SelectProfileImage
    }
    else if firstName.isEmpty {
      errorMessage = .EnterFirstName
    }
    else if lastName.isEmpty {
      errorMessage = .EnterLastName
    }
    else if mobile.isEmpty {
      errorMessage = .EnterMobileNumber
    }
    else if !mobile.isValidPhoneNumber() {
      errorMessage = .validMobileNumber
    }
    else if email.isEmpty {
      errorMessage = .EnterEmail
    }
    else if !email.isValidEmail() {
      errorMessage = .EnterValidEmailAddress
    }
    
    // Store Validations
    else if hostVC.storeImageUrl.isEmpty {
      errorMessage = .UploadStoreImage
    }
    else if storeName.isEmpty {
      errorMessage = .EnterStoreName
    }
    else if hostVC.countryId == 0 {
      errorMessage = .EnterCountry
    }
    else if storeAddress.isEmpty {
      errorMessage = .EnterStoreAddress
    }
    else if addressLine1.isEmpty {
      errorMessage = .EnterAddressLine1
    }
    else if addressLine2.isEmpty {
      errorMessage = .EnterAddressLine2
    }
    else if phone.isEmpty {
      errorMessage = .EnterStorePhoneNumber
    }
    else if !phone.isValidPhoneNumber() {
      errorMessage = .EnterValidStoreMobileNumber
    }
    else if storeEmail.isEmpty {
      errorMessage = .EnterStoreEmail
    }
    else if !storeEmail.isValidEmail() {    // ← FIXED
      errorMessage = .EnterValidStoreEmailAddress
    }
    else if bio.isEmpty {
      errorMessage = .EnterBio
    }
    
    // Show alert if needed
    if errorMessage != .none {
      hostVC.showAlert(msg: errorMessage.rawValue)
    }
    
    hostVC.view.endEditing(true)
    return errorMessage == .none
  }
  
  func updateStoreInfoDocumentApi(){
    let param:[String:Any] = [
      "profile_pic": hostVC.userProfileImageUrl,
      "first_name": hostVC.firsNameTF.text ?? "",
      "last_name": hostVC.lastNameTF.text ?? "",
      "store_image": hostVC.storeImageUrl,
      "store_name": hostVC.storeNameTF.text ?? "",
      "country_code": hostVC.storeCountryCodeTF.text ?? "+965",
      "store_phone": hostVC.storePhoneTF.text ?? "",
      "country": hostVC.countryId,
      "store_address": hostVC.storeAddressTF.text ?? "",
      "address_line1": hostVC.addressLineOneTF.text ?? "",
      "address_line2": hostVC.addressLineTwoTF.text ?? "",
      "store_mail_id": hostVC.storeEmailTF.text ?? "",
      "bio": hostVC.bioTF.text ?? "",
      "let": hostVC.lat ?? 0.0,
      "long": hostVC.long ?? 0.0]
    WebService.sharedInstance.updateStoreInformationRequest(param:param) { user in
      CommonUtils.showToast(message: "Personal Information updated")
      DispatchQueue.main.async {
        self.hostVC.navigationController?.popViewController(animated: true)
      }
    }
  }
}
