//
//  OTPViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit

class OTPViewController: UIViewController {
    private lazy var viewModel = OTPViewModel(hostVC:self)
    // MARK: - Outlets
    @IBOutlet weak var stepTwoImageView: CustomImageView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var textField4: UITextField!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var textField5: UITextField!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var textField6: UITextField!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var resendView: UIView!
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    
    var userId = 0
    var otpDigits = ""
    var type = 0
    var emailMobileType = 0
    var email = ""
    var phoneNumber = ""
    var countryCode = ""
    // MARK: - Variables
    var remainingTime = 90
    var otpTimer: Timer?
    var comingReason: ComingReasonAtOTPScreen = .forgotPassword
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
        setupTextFields()
        startTimer()
        resendView.isHidden = true
        textField1.becomeFirstResponder()
    }
    
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func verifyDidTapped(_ sender: Any) {
        guard validation() else { return }
        switch comingReason {
        case .signup:
            viewModel.otpVerificationAPi()
        case .forgotPassword:
            viewModel.otpVerificationAPi()
        }
    }
    
    @IBAction func buttonResend(_ sender: UIButton) {
        startTimer()
        viewModel.resendOtpApi()
    }
    
    func initialSetUp() {
        switch comingReason {
        case .signup:
            stepTwoImageView.isHidden = false
        default:
            stepTwoImageView.isHidden = true
        }
        
        if emailMobileType == 0 {
            phoneNumberLabel.text = "\(countryCode)\(phoneNumber)"
        } else {
            phoneNumberLabel.text = email
        }
    }
    
    // MARK: - Timer Handling
    func startTimer() {
        remainingTime = 90
        resendView.isHidden = true
        timerView.isHidden = false
        let text = "Sec".localiz()
        labelTimer.text = "00:90 \(text)"
        
        otpTimer?.invalidate()
        otpTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                        target: self,
                                        selector: #selector(updateTimer),
                                        userInfo: nil,
                                        repeats: true)
    }
    
    @objc func updateTimer() {
        remainingTime -= 1
        let text = "Sec".localiz()
        labelTimer.text = "\(String(format: "00:%02d", remainingTime)) \(text)"
        if remainingTime <= 0 {
            otpTimer?.invalidate()
            otpTimer = nil
            resendView.isHidden = false
            timerView.isHidden = true
        }
    }
    
    // MARK: - Setup
    func setupTextFields() {
        [textField1, textField2, textField3, textField4, textField5, textField6].forEach {
            $0?.delegate = self
            $0?.keyboardType = .numberPad
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension OTPViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string.count <= 1 else { return false } // Only 1 character allowed
        
        if !string.isEmpty {
            // Add character
            textField.text = string
            updateBorder(for: textField, isActive: true)
            
            switch textField {
            case textField1: textField2.becomeFirstResponder()
            case textField2: textField3.becomeFirstResponder()
            case textField3: textField4.becomeFirstResponder()
            case textField4: textField5.becomeFirstResponder()
            case textField5: textField6.becomeFirstResponder()
            case textField6: textField6.resignFirstResponder()
            default: break
            }
        } else {
            // Delete character
            textField.text = ""
            updateBorder(for: textField, isActive: false)
            
            switch textField {
            case textField2: textField1.becomeFirstResponder()
            case textField3: textField2.becomeFirstResponder()
            case textField4: textField3.becomeFirstResponder()
            case textField5: textField4.becomeFirstResponder()
            case textField6: textField5.becomeFirstResponder()
            default: break
            }
        }
        return false
    }
    
    private func updateBorder(for textField: UITextField, isActive: Bool) {
        let darkBrown = UIColor.darkBrown.cgColor
        let lightGray = UIColor.lightGray.cgColor
        
        switch textField {
        case textField1: view1.layer.borderColor = isActive ? darkBrown : lightGray
        case textField2: view2.layer.borderColor = isActive ? darkBrown : lightGray
        case textField3: view3.layer.borderColor = isActive ? darkBrown : lightGray
        case textField4: view4.layer.borderColor = isActive ? darkBrown : lightGray
        case textField5: view5.layer.borderColor = isActive ? darkBrown : lightGray
        case textField6: view6.layer.borderColor = isActive ? darkBrown : lightGray
        default: break
        }
    }
}

// MARK: - Validation
extension OTPViewController {
    func validation() -> Bool {
        let otpText = [textField1, textField2, textField3, textField4, textField5, textField6].compactMap { $0?.text }.joined()
        
        if otpText.count < 6 {
            showAlert(msg: "Please enter 6-digit otp".localiz())
            return false
        }
        
        otpDigits = String.getString(textField1.text) + String.getString(textField2.text) + String.getString(textField3.text) + String.getString(textField4.text) + String.getString(textField5.text) + String.getString(textField6.text)
        
        print("Entered OTP: \(otpText)")
        return true
    }
}


enum ComingReasonAtOTPScreen {
    case signup
    case forgotPassword
}
