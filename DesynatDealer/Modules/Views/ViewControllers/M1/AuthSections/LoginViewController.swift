//
//  LoginViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPassword.isSecureTextEntry = true
        txtPassword.delegate = self
    }
    

    @IBAction func loginDidTapped(_ sender: Any) {
        kSharedSceneDelegate.navigateToDealerHomeVc()
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
