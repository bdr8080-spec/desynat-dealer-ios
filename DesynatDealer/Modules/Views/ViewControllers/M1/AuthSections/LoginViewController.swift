//
//  LoginViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit

class LoginViewController: UIViewController {
    private lazy var viewModel = LoginViewModel(loginHostVC: self)
    @IBOutlet weak var emailMobileImageView: UIImageView!
    @IBOutlet weak var txtFieldLeading: NSLayoutConstraint!
    @IBOutlet weak var viewCountryCode: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var txtPassword: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPassword.isSecureTextEntry = true
        txtPassword.delegate = self
        emailTextField.delegate = self
        viewCountryCode.isHidden = true
        self.txtFieldLeading.constant = -55
        emailMobileImageView.image = UIImage(named: "email")
    }

    @IBAction func loginDidTapped(_ sender: Any) {
        if viewModel.validFields() {
            viewModel.loginApi()
        }
    }
    
    @IBAction func forgotPasswordDidTapped(_ sender: Any) {
        let vc = ForgotPasswordViewController.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signupDidTapped(_ sender: Any) {
        if let navController = self.navigationController,
               let signupVC = navController.viewControllers.first(where: { $0 is SignupViewController }) {
                navController.popToViewController(signupVC, animated: true)
            } else {
                let vc = SignupViewController.instantiate(fromAppStoryboard: .Main)
                self.navigationController?.pushViewController(vc, animated: true)
            }
    }
    
    @IBAction func btnTapEye(_ sender: UIButton) {
        sender.isSelected.toggle()
        txtPassword.isSecureTextEntry.toggle()
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        var validation: StringValidation?
        
        if textField == self.emailTextField {
            if currentText.hasPrefix(" ") {
                return false
            }
            
            if !currentText.isNumber() {
                self.viewCountryCode.isHidden = true
                emailMobileImageView.image = UIImage(named: "email")
                self.txtFieldLeading.constant = -55
                validation = StringValidation(string: currentText, characterCount: 55, validation: .emailId)
            } else {
                self.viewCountryCode.isHidden = false
                emailMobileImageView.image = UIImage(named: "phone")
                self.txtFieldLeading.constant = 12
                validation = StringValidation(string: currentText, characterCount: 15, validation: .mobileNo)
            }
    
            if let data = validation {
                return data.validate()
            } else {
                return true
            }
        }
        return true
    }
}
