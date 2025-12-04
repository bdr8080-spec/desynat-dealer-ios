//
//  StoreInformationViewController.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit
import SDWebImage

class StoreInformationViewController: UIViewController {
    private lazy var viewModel = StoreInformationViewModel(hostVC:self)
    @IBOutlet weak var uploadStoreImageView: CustomImageView!
    @IBOutlet weak var storeNameTextField: UITextField!
    @IBOutlet weak var storeAddressTextField: UITextField!
    @IBOutlet weak var addressLineOneTextField: UITextField!
    @IBOutlet weak var addressLineTwoTextField: UITextField!
    @IBOutlet weak var storePhoneNumberTextField: UITextField!
    @IBOutlet weak var storeMailIDTextField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtCountryCode: UITextField!
    
    var userId = 0
    var selectedStoreInformationImage = ""
    var countryId = 0
    var lat: Double = 0.0
    var long: Double = 0.0
    var countryCode: String = "+965"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtCountryCode.text = countryCode
        storePhoneNumberTextField.delegate = self
        storeMailIDTextField.delegate = self
        viewModel.countryListApi()
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueDidTapped(_ sender: Any) {
        if viewModel.validFields() {
            viewModel.storeInformationApi()
        }
    }
    
    @IBAction func addressDidTapped(_ sender: Any) {
//        let vc = LocationViewController.instantiate(fromAppStoryboard: .Main)
//
//        vc.locationCallBack = { [weak self] address, locality, city, state, country, pincode, lat, long in
//            guard let self = self else { return }
//            let safeAddress = address.isEmpty ? "" : address
//            let safeLocality = locality.isEmpty ? "" : locality
//            let safeCity = city.isEmpty ? "" : city
//            let safeState = state.isEmpty ? "" : state
//            let safeCountry = country.isEmpty ? "" : country
//            let safePincode = pincode.isEmpty ? "" : pincode
//
//            let lineTwoData = [safeCity, safeState]
//                .filter { !$0.isEmpty }
//                .joined(separator: ", ")
//                + (safePincode.isEmpty ? "" : " - \(safePincode)")
//
//            self.storeAddressTextField.text = safeAddress
//
//            if safeLocality.isEmpty {
//                // If locality (line 1) is empty → use city/state/pincode data
//                self.addressLineOneTextField.text = lineTwoData
//                self.addressLineTwoTextField.text = ""
//            } else {
//                // Otherwise show proper structured data
//                self.addressLineOneTextField.text = safeLocality
//                self.addressLineTwoTextField.text = lineTwoData
//            }
//            self.lat = lat
//            self.long = long
//        }
        
        
        
        
        let vc = LocationViewController.instantiate(fromAppStoryboard: .Main)
           
           vc.locationCallBack = { [weak self] address, locality, city, state, country, pincode, lat, long in
               guard let self = self else { return }
               
               // ✅ Safely unwrap each value with fallbacks
               let safeAddress = address.isEmpty ? "" : address
               let safeLocality = locality.isEmpty ? "" : locality
               let safeCity = city.isEmpty ? "" : city
               let safeState = state.isEmpty ? "" : state
               let safeCountry = country.isEmpty ? "" : country
               let safePincode = pincode.isEmpty ? "" : pincode
               
               // ✅ Assign values properly to all fields
               self.storeAddressTextField.text = safeAddress
               self.addressLineOneTextField.text = safeLocality
//               self.addressLineTwoTextField.text = "\(safeCity), \(safeState) - \(safePincode)"
               var components: [String] = []

               if !safeCity.isEmpty {
                   components.append(safeCity)
               }
               if !safeState.isEmpty {
                   components.append(safeState)
               }

               var address = components.joined(separator: ", ")

               if !safePincode.isEmpty {
                   address += " - \(safePincode)"
               }

               self.addressLineTwoTextField.text = address

//               self.txtCountry.text = safeCountry
               
               self.lat = lat
               self.long = long
           }
           
           self.navigationController?.pushViewController(vc, animated: true)

        }

    
    @IBAction func btnTapCountry(_ sender: UIButton) {
        let countryNames = viewModel.countryList.map { $0.name ?? ""}
        kSharedAppDelegate.dropDown(dataSource:countryNames, anchorView:sender) { index, item in
            self.txtCountry.text = item
            let selectedCountryId = self.viewModel.countryList[index]
            self.countryId = selectedCountryId.id ?? 0
        }
    }
    
    @IBAction func uploadStoreImageDidTapped(_ sender: Any) {
        ImagePickerHelper.shared.showPickerController {  image , imageName in
            if let image = image {
                WebService.sharedInstance.uploadImage(withParams: image) { imageURL in
                    self.selectedStoreInformationImage = imageURL.url ?? ""
                    if let url = URL(string: imageURL.url ?? "") {
                        self.uploadStoreImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        self.uploadStoreImageView.sd_setImage(with: url,placeholderImage: UIImage(named: "user_ic"))
                    }
                }
            }
        }
    }
    
    @IBAction func btnTapCountryCode(_ sender: UIButton) {
        let countryNames = viewModel.countryList.map { country -> String in
            let name = country.name ?? ""
            let dialCode = country.dialCode ?? ""
            let flag = country.flag ?? "🇰🇼"
            return "\(flag)  \(name) (\(dialCode))"
        }

        kSharedAppDelegate.dropDown(dataSource: countryNames, anchorView: sender) { index, item in
            let selectedCountry = self.viewModel.countryList[index]
            let code = selectedCountry.dialCode ?? "+965"
            self.txtCountryCode.text = code
            self.countryCode = code
        }
    }
    
    private func extractCityAndState(from address: String) -> String {
        // Example: "123 Road, Sector 5, Mumbai, Maharashtra, India, 400001"
        // Extracts "Mumbai, Maharashtra"
        let components = address.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        if components.count >= 3 {
            return "\(components[components.count - 3]), \(components[components.count - 2])"
        }
        return ""
    }

    private func extractCountry(from address: String) -> String {
        // Extracts the last component (usually country)
        let components = address.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        return components.last ?? ""
    }
}

extension StoreInformationViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        // Safely unwrap the current text
        guard let currentText = textField.text else { return true }
        
        // Construct the updated text after the change
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // Prevent leading space
        if updatedText.hasPrefix(" ") {
            return false
        }
        
        var validation: StringValidation?
        
        // Validate email
        if textField == storeMailIDTextField {
            validation = StringValidation(string: updatedText, characterCount: 55, validation: .emailId)
        }
        // Validate mobile number
        else if textField == storePhoneNumberTextField {
            validation = StringValidation(string: updatedText, characterCount: 15, validation: .mobileNo)
        }
        
        // Perform validation if applicable
        if let validation = validation {
            return validation.validate()
        }
        
        return true
    }
}
