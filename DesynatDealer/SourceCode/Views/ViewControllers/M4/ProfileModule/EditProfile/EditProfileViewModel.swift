//
//  EditProfileViewModel.swift
//  DesynatDealer
//
//  Created by fluper on 05/12/25.
//


import Foundation

class EditProfileViewModel {
  
  private var hostVC: EditProfileViewController?
  var userProfile: SellerProfileDataModel?
  
  init(hostVC: EditProfileViewController? = nil) {
    self.hostVC = hostVC
  }
  
  func getUserProfile() {
    WebService.sharedInstance.getUserProfile { [weak self] response in
      guard let self else { return }
      userProfile = response
      hostVC?.populateData()
    }
  }
  
  func validBankInfoFields() -> Bool {
      var errorMessage: AlertConstant = .none
      let iban = String.getString(hostVC?.ibanTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
      let swiftCode = String.getString(hostVC?.swiftTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
      let bankName = String.getString(hostVC?.bankNameTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
      let accountHolder = String.getString(hostVC?.accountHolderNameTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
     if bankName.isEmpty {
          errorMessage = .EnterBankName
      } else if accountHolder.isEmpty {
          errorMessage = .EnterAccountHolder
      } else if hostVC?.bankProofUrl == nil {
          errorMessage = .UploadAccountHolderImage
      }
      if errorMessage != .none {
        hostVC?.showAlert(msg: errorMessage.rawValue)
      }
    hostVC?.view.endEditing(true)
      return errorMessage == .none
  }
  
  func updateBankDocumentApi(){
    let param: [String: Any] = [
      "bank_name": hostVC?.bankNameTF.text ?? "",
      "account_holder_name": hostVC?.accountHolderNameTF.text ?? "",
      "account_type": hostVC?.accountType ?? 0,
      "swift": hostVC?.swiftTF.text ?? "",
      "iban": hostVC?.ibanTF.text ?? "",
      "user_id": userProfile?.id ?? 0,
      "upload_proof": hostVC?.bankProofUrl ?? ""]
      WebService.sharedInstance.updateBankInformationRequest(param:param) { user in
        CommonUtils.showToast(message: "")
      }
  }
  
  func updateStoreInfoDocumentApi(){
    let param:[String:Any] = [:
      ]
      WebService.sharedInstance.updateStoreInformationRequest(param:param) { user in
        CommonUtils.showToast(message: "")
      }
  }
}
