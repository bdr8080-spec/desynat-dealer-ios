//
//  EditProfileViewController.swift
//  DesynatDealer
//
//  Created by fluper on 05/12/25.
//

import UIKit
import SDWebImage

class EditProfileViewController: UIViewController {
  
  @IBOutlet weak var bankProofImageView: CustomImageView!
  @IBOutlet weak var accountHolderNameTF: UITextField!
  @IBOutlet weak var bankNameTF: UITextField!
  @IBOutlet weak var swiftTF: UITextField!
  @IBOutlet weak var ibanTF: UITextField!
  @IBOutlet weak var personalInfoStackView: UIStackView!
  @IBOutlet weak var bankDetailsStackView: UIStackView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var personalInfoButtn: CustomButton!
  @IBOutlet weak var personalLabel: UILabel!
  @IBOutlet weak var bandDetailsButton: CustomButton!
  @IBOutlet weak var bankDetailsLabel: UILabel!
  @IBOutlet weak var personalAccountImage: UIImageView!
  @IBOutlet weak var businessAccountImage: UIImageView!
  @IBOutlet weak var userProfileImageView: CustomImageView!
  @IBOutlet weak var firsNameTF: UITextField!
  @IBOutlet weak var lastNameTF: UITextField!
  @IBOutlet weak var mobileTF: UITextField!
  @IBOutlet weak var countrycodeTF: UITextField!
  @IBOutlet weak var emailTF: UITextField!
  @IBOutlet weak var storeImageView: CustomImageView!
  @IBOutlet weak var storeNameTF: UITextField!
  @IBOutlet weak var contryTF: UITextField!
  @IBOutlet weak var storeAddressTF: UITextField!
  @IBOutlet weak var addressLineOneTF: UITextField!
  @IBOutlet weak var addressLineTwoTF: UITextField!
  @IBOutlet weak var storePhoneTF: UITextField!
  @IBOutlet weak var storeCountryCodeTF: UITextField!
  @IBOutlet weak var storeEmailTF: UITextField!
  @IBOutlet weak var bioTF: UITextView!
  
  var accountType = 0
  var userProfileImageUrl: String = ""
  var storeImageUrl: String = ""
  var bankProofUrl: String = ""
  private lazy var viewModel = EditProfileViewModel(hostVC: self)
  var lat: Double? = 0.0
  var long: Double? = 0.0
  var countryId = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    personalInfoStackView.isHidden = false
    bankDetailsStackView.isHidden = true
    setAllTextFieldDelegates()
    viewModel.countryListApi()
    viewModel.getUserProfile()
  }
  
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func personalInfoDidTapped(_ sender: Any) {
    bandDetailsButton.setImage(UIImage(named: ""), for: .normal)
    bankDetailsLabel.textColor = UIColor.black
    personalInfoButtn.setImage(UIImage(named: "btnGradient"), for: .normal)
    personalLabel.textColor = UIColor.white
    titleLabel.text = "Edit"
    personalInfoStackView.isHidden = false
    bankDetailsStackView.isHidden = true
  }
  
  @IBAction func bankDetailsAction(_ sender: Any) {
    personalInfoButtn.setImage(UIImage(named: ""), for: .normal)
    personalLabel.textColor = UIColor.black
    bandDetailsButton.setImage(UIImage(named: "btnGradient"), for: .normal)
    bankDetailsLabel.textColor = UIColor.white
    titleLabel.text = "Edit Bank Details"
    personalInfoStackView.isHidden = true
    bankDetailsStackView.isHidden = false
  }
  
  @IBAction func personalDidTappd(_ sender: Any) {
    personalAccountImage.image = UIImage(named: "radioSelected")
    businessAccountImage.image = UIImage(named: "radioUnselected")
    accountType = 0
  }
  
  @IBAction func businessDidTapped(_ sender: Any) {
    businessAccountImage.image = UIImage(named: "radioSelected")
    personalAccountImage.image = UIImage(named: "radioUnselected")
    accountType = 1
  }
  
  @IBAction func bankUploadProofDidTapped(_ sender: Any) {
    ImagePickerHelper.shared.showPickerController {  image , imageName in
      if let image = image {
        WebService.sharedInstance.uploadImage(withParams: image) { imageURL in
          self.bankProofUrl = imageURL.url ?? ""
          if let url = URL(string: imageURL.url ?? "") {
            self.bankProofImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.bankProofImageView.sd_setImage(with: url,placeholderImage: UIImage(named: ""))
          }
        }
      }
    }
  }
  
  @IBAction func changeProfileImageDidTapped(_ sender: Any) {
    ImagePickerHelper.shared.showPickerController {  image , imageName in
      if let image = image {
        WebService.sharedInstance.uploadImage(withParams: image) { imageURL in
          self.userProfileImageUrl = imageURL.url ?? ""
          if let url = URL(string: imageURL.url ?? "") {
            self.userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.userProfileImageView.sd_setImage(with: url,placeholderImage: UIImage(named: "userProfile"))
          }
        }
      }
    }
  }
  
  @IBAction func storeImageDidTapped(_ sender: Any) {
    ImagePickerHelper.shared.showPickerController {  image , imageName in
      if let image = image {
        WebService.sharedInstance.uploadImage(withParams: image) { imageURL in
          self.storeImageUrl = imageURL.url ?? ""
          if let url = URL(string: imageURL.url ?? "") {
            self.storeImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.storeImageView.sd_setImage(with: url,placeholderImage: UIImage(named: ""))
          }
        }
      }
    }
  }
  
  @IBAction func addressDidTapped(_ sender: Any) {
    let vc = LocationViewController.instantiate(fromAppStoryboard: .Main)
    vc.preSelectedLat = self.lat
    vc.preSelectedLng = self.long
    vc.locationCallBack = { [weak self] address, locality, city, state, country, pincode, lat, long in
      guard let self = self else { return }
      let safeAddress   = address.trimmingCharacters(in: .whitespaces)
      let safeLocality  = locality.trimmingCharacters(in: .whitespaces)
      let safeCity      = city.trimmingCharacters(in: .whitespaces)
      let safeState     = state.trimmingCharacters(in: .whitespaces)
      let safePincode   = pincode.trimmingCharacters(in: .whitespaces)
      var fullAddress = safeAddress
      if fullAddress.isEmpty {
        fullAddress = [safeLocality, safeCity, safeState, safePincode]
          .filter { !$0.isEmpty }
          .joined(separator: ", ")
      }
      self.storeAddressTF.text = fullAddress
      var line1 = safeLocality
      if line1.isEmpty {
        line1 = [safeCity, safeState]
          .filter { !$0.isEmpty }
          .joined(separator: ", ")
      }
      self.addressLineOneTF.text = line1
      var line2Components = [String]()
      if !safeCity.isEmpty { line2Components.append(safeCity) }
      if !safeState.isEmpty { line2Components.append(safeState) }
      var line2 = line2Components.joined(separator: ", ")
      if !safePincode.isEmpty {
        line2 = line2.isEmpty ? safePincode : "\(line2) - \(safePincode)"
      }
      self.addressLineTwoTF.text = line2
      self.lat = lat
      self.long = long
    }
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func updateBankInfoDidTapped(_ sender: Any) {
    if viewModel.validBankInfoFields() {
      viewModel.updateBankDocumentApi()
    }
  }
  
  @IBAction func saveChangesDidTapped(_ sender: Any) {
    if viewModel.validStoreInfoFields() {
      viewModel.updateStoreInfoDocumentApi()
    }
  }
  
  @IBAction func storePhoneCountryCodeAction(_ sender: UIButton) {
    let countryNames = viewModel.countryList.map { country -> String in
        let name = country.name ?? ""
        let dialCode = country.dialCode ?? ""
        let flag = country.flag ?? "🇰🇼"
        return "\(flag)  \(name) (\(dialCode))"
    }

    kSharedAppDelegate.dropDown(dataSource: countryNames, anchorView: sender) { index, item in
        let selectedCountry = self.viewModel.countryList[index]
        let code = selectedCountry.dialCode ?? "+965"
        self.storeCountryCodeTF.text = code
    }
  }
  
  @IBAction func btnTapCountry(_ sender: UIButton) {
      let countryNames = viewModel.countryList.map { $0.name ?? ""}
      kSharedAppDelegate.dropDown(dataSource:countryNames, anchorView:sender) { index, item in
          self.contryTF.text = item
          self.countryId = self.viewModel.countryList[index].id ?? 0
      }
  }
  
  private func setAllTextFieldDelegates() {
    let textFields: [UITextField] = [accountHolderNameTF,bankNameTF,swiftTF, ibanTF, firsNameTF, lastNameTF,  mobileTF, countrycodeTF, emailTF, storeNameTF,  contryTF, storeAddressTF,addressLineOneTF, addressLineTwoTF, storePhoneTF, storeCountryCodeTF, storeEmailTF]
    textFields.forEach { $0.delegate = self }
  }
  
  func populateData() {
    let data = viewModel.userProfile
    
    if let imageUrlString = data?.profilePic,
       let url = URL(string: imageUrlString) {
      userProfileImageUrl = imageUrlString
      userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
      userProfileImageView.sd_imageIndicator?.startAnimatingIndicator()
      userProfileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "userProfile"))
    } else {
      userProfileImageView.image = UIImage(named: "userProfile")
    }
    firsNameTF.text = data?.firstName
    lastNameTF.text = data?.lastName
    mobileTF.text = data?.mobile
    countrycodeTF.text = data?.countryCode
    emailTF.text = data?.email
    if let imageUrlString = data?.storeInfo?.storeImage,
       let url = URL(string: imageUrlString) {
      storeImageUrl = imageUrlString
      storeImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
      storeImageView.sd_imageIndicator?.startAnimatingIndicator()
      storeImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
    } else {
      storeImageView.image = UIImage(named: "")
    }
    storeNameTF.text = data?.storeInfo?.storeName
    countryId = Int(data?.storeInfo?.country ?? "0") ?? 0
    contryTF.text = data?.storeInfo?.countryInfo?.name
    storeAddressTF.text = data?.storeInfo?.storeAddress
    addressLineOneTF.text = data?.storeInfo?.addressLine1
    addressLineTwoTF.text = data?.storeInfo?.addressLine2
    storePhoneTF.text = data?.storeInfo?.storePhone
    storeCountryCodeTF.text = data?.storeInfo?.countryCode
    storeEmailTF.text = data?.storeInfo?.storeMailID
    bioTF.text = data?.storeInfo?.bio
    
    accountType = Int(data?.sellerBankDetails?.accountType ?? "0") ?? 0
    if accountType == 0 {
      personalAccountImage.image = UIImage(named: "radioSelected")
      businessAccountImage.image = UIImage(named: "radioUnselected")
    } else {
      personalAccountImage.image = UIImage(named: "radioUnselected")
      businessAccountImage.image = UIImage(named: "radioSelected")
    }
    
    ibanTF.text = data?.sellerBankDetails?.iban
    swiftTF.text = data?.sellerBankDetails?.swift
    bankNameTF.text = data?.sellerBankDetails?.bankName
    accountHolderNameTF.text = data?.sellerBankDetails?.accountHolderName
    
    if let imageUrlString = data?.sellerBankDetails?.uploadProof,
       let url = URL(string: imageUrlString) {
      bankProofUrl = imageUrlString
      bankProofImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
      bankProofImageView.sd_imageIndicator?.startAnimatingIndicator()
      bankProofImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
    } else {
      bankProofImageView.image = UIImage(named: "")
    }
  }
  
}


extension EditProfileViewController: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if range.location == 0 && string == " " {
      return false
    }
    if string.isEmpty { return true }
    let currentText = textField.text ?? ""
    let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
    if textField == bankNameTF {
      let allowed = CharacterSet.letters.union(.whitespaces)
      return string.rangeOfCharacter(from: allowed.inverted) == nil
    }
    if textField == accountHolderNameTF {
      let allowed = CharacterSet.letters.union(.whitespaces)
      return string.rangeOfCharacter(from: allowed.inverted) == nil
    }
    if textField == ibanTF {
      if string == " " { return false }
      if newText.count > 20 { return false }
      return true
    }
    if textField == swiftTF {
      if string == " " { return false }
      return true
    }
    if newText.trimmingCharacters(in: .whitespaces).isEmpty && !newText.isEmpty {
      return false
    }
    var validation: StringValidation?
    if textField == storeEmailTF || textField == emailTF {
      validation = StringValidation(string: newText, characterCount: 55, validation: .emailId)
    }
    if textField == storePhoneTF || textField == mobileTF {
      validation = StringValidation(string: newText, characterCount: 15, validation: .mobileNo)
    }
    if let validation = validation {
      return validation.validate()
    }
    return true
  }
}
