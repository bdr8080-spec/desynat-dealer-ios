//
//  SignupViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit
import SDWebImage

class SignupViewController: UIViewController {
    @IBOutlet weak var profilePicImageView: CustomImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var txtCreatePassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var txtCountryCode: UITextField!
    @IBOutlet weak var txtFieldLeading: NSLayoutConstraint!
    
    var isTermsAccepted: Bool = false
    var selectedImage: UIImage?
    lazy private var viewModel = SignupViewModel(hostVC: self)
    var profileImage = ""
//    var countryCode: String = LocationManager.sharedInstance.getCurrentLocationCode().dialCode
    var countryCode: String = "+965"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtCountryCode.text = countryCode
        mobileTextField.delegate = self
        emailTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        viewModel.countryListApi()
    }
    
    @IBAction func conitnueDidTapped(_ sender: Any) {
        if viewModel.validFields() {
            viewModel.signUpApi()
        }
    }
    
    @IBAction func signInDidTapped(_ sender: Any) {
        if let navController = self.navigationController,
           let loginVC = navController.viewControllers.first(where: { $0 is LoginViewController }) {
            navController.popToViewController(loginVC, animated: true)
        } else {
            let vc = LoginViewController.instantiate(fromAppStoryboard: .Main)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnTapCreatePasswordEye(_ sender: UIButton) {
        sender.isSelected.toggle()
        txtCreatePassword.isSecureTextEntry.toggle()
    }
    
    @IBAction func btnTapConfirmPasswordEye(_ sender: UIButton) {
        sender.isSelected.toggle()
        txtConfirmPassword.isSecureTextEntry.toggle()
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
    
//    func setUpCountryCode(code:String)  {
//        self.txtCountryCode.text = code
//    }
    
    @IBAction func uploadProfilePicDidTapped(_ sender: Any) {
        ImagePickerHelper.shared.showPickerController {  image , imageName in
            if let image = image {
                WebService.sharedInstance.uploadImage(withParams: image) { imageURL in
                    self.profileImage = imageURL.url ?? ""
                    self.selectedImage = image
                    print("image url--.\(self.profileImage)")
                    if let url = URL(string: imageURL.url ?? "") {
                        self.profilePicImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        self.profilePicImageView.sd_setImage(with: url,placeholderImage: UIImage(named: "user_ic"))
                    }
                }
            }
        }
    }
    
    @IBAction func agreeToTerms(_ sender: UIButton) {
        isTermsAccepted.toggle()
        let imageName = isTermsAccepted ? "selectedCheckBox" : "unslectedCheckbox"
        sender.setImage(UIImage(named: imageName), for: .normal)
    }
    
    @IBAction func policiesAction(_ sender: Any) {
    }
    
    @IBAction func termsAndConditionAction(_ sender: Any) {
    }
    
}

extension SignupViewController: UITextFieldDelegate {
    
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
        if textField == emailTextField {
            validation = StringValidation(string: updatedText, characterCount: 55, validation: .emailId)
        }
        // Validate mobile number
        else if textField == mobileTextField {
            validation = StringValidation(string: updatedText, characterCount: 15, validation: .mobileNo)
        }
        
        else if textField == firstNameTextField || textField == lastNameTextField {
                   let englishPattern = "^[A-Za-z]*$"
                   if string.range(of: englishPattern, options: .regularExpression) == nil {
                       return false
                   }
               }
        
        // Perform validation if applicable
        if let validation = validation {
            return validation.validate()
        }
        
        return true
    }
}


