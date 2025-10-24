//
//  SignupViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var txtCreatePassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func conitnueDidTapped(_ sender: Any) {
        let vc = OTPViewController.instantiate(fromAppStoryboard: .Main)
        vc.comingReason = .signup
        self.navigationController?.pushViewController(vc, animated: true)
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
}
