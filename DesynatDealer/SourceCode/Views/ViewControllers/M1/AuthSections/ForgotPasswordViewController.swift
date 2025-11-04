//
//  ForgotPasswordViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var imgMobile: UIImageView!
    @IBOutlet weak var mobileView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var txtCountryCode: UITextField!
    
    var accountType = 0
    var countryCode: String = "+965"
    var mobileIsSelected: Bool? = nil
    private lazy var viewModel = ForgotPasswordViewModel(hostVC: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtCountryCode.text = countryCode
        mobileTextField.delegate = self
        emailAddressTextField.delegate = self
        viewModel.countryListApi()
    }
    
    @IBAction func continueDidTapped(_ sender: Any) {
        if viewModel.validFields(mobileIsSelected: mobileIsSelected ?? false) {
            viewModel.forgotPasswordApi(isMobileSelected:mobileIsSelected ?? false)
        }
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func mobileNumberDidTapped(_ sender: Any) {
        imgMobile.image = UIImage(named: "radioSelected")
        imgEmail.image = UIImage(named: "radioUnselected")
        mobileView.isHidden = false
        emailView.isHidden = true
        mobileIsSelected = true
        accountType = 0
    }
    
    @IBAction func emailDidTapped(_ sender: Any) {
        imgEmail.image = UIImage(named: "radioSelected")
        imgMobile.image = UIImage(named: "radioUnselected")
        mobileView.isHidden = true
        emailView.isHidden = false
        mobileIsSelected = false
        accountType = 1
    }
    
    @IBAction func btnTapCountryCode(_ sender: UIButton) {
//        CommonUtils.openPicker(controller: self) { _ , _, callingCode in
//            self.setUpCountryCode(code: callingCode)
//            self.countryCode = callingCode
//        }
        
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
    
//    func setUpCountryCode(code:String)  {
//        self.txtCountryCode.text = code
//    }
    
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    
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
        if textField == emailAddressTextField {
            validation = StringValidation(string: updatedText, characterCount: 55, validation: .emailId)
        }
        // Validate mobile number
        else if textField == mobileTextField {
            validation = StringValidation(string: updatedText, characterCount: 15, validation: .mobileNo)
        }
        
        // Perform validation if applicable
        if let validation = validation {
            return validation.validate()
        }
        
        return true
    }
}
