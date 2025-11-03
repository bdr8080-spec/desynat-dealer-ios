//
//  ResetPasswordViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    lazy private var viewModel = ResetPasswordViewModel(hostVC: self)
    @IBOutlet weak var txtCreatePassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    var id = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtConfirmPassword.delegate = self
        txtCreatePassword.delegate = self
        
    }
    
    @IBAction func doneDidTapped(_ sender: Any) {
        if viewModel.validFields() {
            viewModel.ResetPassApi()
        }
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
