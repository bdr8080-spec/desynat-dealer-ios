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
    
    var isTermsAccepted: Bool = false
    var selectedImage: UIImage?
    lazy private var viewModel = SignupViewModel(hostVC: self)
    var profileImage = ""
    var countryCode = "+91"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mobileTextField.delegate = self
        emailTextField.delegate = self
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
        CommonUtils.openPicker(controller: self) { _ , _, callingCode in
            self.setUpCountryCode(code: callingCode)
            self.countryCode = callingCode
        }
    }
    
    func setUpCountryCode(code:String)  {
        self.txtCountryCode.text = code
    }
    
    @IBAction func uploadProfilePicDidTapped(_ sender: Any) {
//        ImagePickerManager().pickImage(self) { [weak self] image, fileName, url in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                self.profilePicImageView.image = image
//                self.selectedImage = image
//            }
//        }
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
        
        // Perform validation if applicable
        if let validation = validation {
            return validation.validate()
        }
        
        return true
    }
}
