//
//  ForgotPasswordViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var imgMobile: UIImageView!
    @IBOutlet weak var mobileView: UIView!
    @IBOutlet weak var emailView: UIView!
    
    var mobileIsSelected: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mobileIsSelected = true
    }
    
    @IBAction func continueDidTapped(_ sender: Any) {
        let vc = OTPViewController.instantiate(fromAppStoryboard: .Main)
        vc.comingReason = .forgotPassword
        self.navigationController?.pushViewController(vc, animated: true)
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
    }
    
    @IBAction func emailDidTapped(_ sender: Any) {
        imgEmail.image = UIImage(named: "radioSelected")
        imgMobile.image = UIImage(named: "radioUnselected")
        mobileView.isHidden = true
        emailView.isHidden = false
        mobileIsSelected = false
    }
}
