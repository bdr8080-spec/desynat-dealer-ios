//
//  PromoteStoryViewController.swift
//  DesynatDealer
//
//  Created by fluper_mac2 on 13/07/26.
//

import UIKit

class PromoteStoryViewController: UIViewController {
    
    @IBOutlet weak var lblTotalPrice: CustomLabelFont!
    @IBOutlet weak var postOnProfileButton: CustomButton!
    @IBOutlet weak var desynatRadioContentView: CustomView!
    @IBOutlet weak var profileContentView: CustomView!
    @IBOutlet weak var profileRadioImageView: UIImageView!
    @IBOutlet weak var desynatRadioImageView: UIImageView!
    @IBOutlet weak var promotioDetailsView: UIView!
    @IBOutlet weak var txtFromDate: UITextField!
    
    private lazy var viewModel = PromoteStoryViewModel(hostVC: self)
    var profileRadioIsOn: Bool = true
    let datePicker = UIDatePicker()
    private var activeTextField: UITextField?
    var perDayPrice: Double = 499
    
    override func viewDidLoad() {
        super.viewDidLoad()
        desynatRadioContentView.borderColor = UIColor.black.withAlphaComponent(0.1)
        promotioDetailsView.isHidden = true
        lblTotalPrice.text = perDayPrice.description
        setUpTextFields()
    }
    
    @IBAction func profileStoryDidTapped(_ sender: Any) {
        profileRadioIsOn = true
        profileContentView.borderColor = UIColor.darkBrown
        desynatRadioContentView.borderColor = UIColor.black.withAlphaComponent(0.1)
        profileRadioImageView.image = .radioSelected
        desynatRadioImageView.image = .radioUnselected
        promotioDetailsView.isHidden = true
        postOnProfileButton.setTitle("Post on Profile".localiz(), for: .normal)
    }
    
    @IBAction func featuredOnDesynatHomeDidTapped(_ sender: Any) {
        profileRadioIsOn = false
        profileContentView.borderColor = UIColor.black.withAlphaComponent(0.1)
        desynatRadioContentView.borderColor = UIColor.darkBrown
        profileRadioImageView.image = .radioUnselected
        desynatRadioImageView.image = .radioSelected
        promotioDetailsView.isHidden = false
        postOnProfileButton.setTitle("Send Request".localiz(), for: .normal)
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func postOnProfileDidTapped(_ sender: Any) {
        if profileRadioIsOn {
            self.navigationController?.popToViewController(ofClass: DelearProfileViewController.self)
        } else {
            let date = txtFromDate.text?.trimmed() ?? ""
            if date.isEmpty {
                showAlert(msg: "Please select date".localiz())
                return
            }
            let vc = AddBannerSuccessVC.instantiate(fromAppStoryboard: .BannerManagement)
            vc.comingReason = .forStory
            vc.dismissCallBack = {
                self.navigationController?.popToViewController(ofClass: DelearProfileViewController.self)
            }
            self.navigationController?.present(vc, animated: true)
        }
    }
}

extension PromoteStoryViewController {
    
    private func setUpTextFields() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.backgroundColor = .white
        if AppLanguageManager.shared.currentLanguage == .ar {
            datePicker.locale = Locale(identifier: "ar")
        } else {
            datePicker.locale = Locale(identifier: "en_US")
        }
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(
            title: "Done".localiz(),
            style: .done,
            target: self,
            action: #selector(doneDatePicker)
        )
        let spaceButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        let cancelButton = UIBarButtonItem(
            title: "Cancel".localiz(),
            style: .plain,
            target: self,
            action: #selector(cancelDatePicker)
        )
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        let textFields = [txtFromDate]
        textFields.forEach { textField in
            textField?.inputView = datePicker
            textField?.inputAccessoryView = toolbar
            textField?.delegate = self
        }
    }
    
    @objc private func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        guard let activeTextField = activeTextField else { return }
        let selectedDate = datePicker.date
        activeTextField.text = formatter.string(from: selectedDate)
        view.endEditing(true)
        calculateTotalDays()
    }
    
    @objc private func cancelDatePicker() {
        view.endEditing(true)
    }
    
    func calculateTotalDays() {
        guard let fromText = txtFromDate.text, !fromText.isEmpty else {
            lblTotalPrice.text = "0 KD".localiz()
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        guard let startDate = formatter.date(from: fromText) else {
            lblTotalPrice.text = "0 KD".localiz()
            return
        }
        let text = "KD"
        //        lblTotalPrice.text = "\(totalDays * pricePerDay) \(text)"
    }
    
}

// MARK: - TextField Delegate
extension PromoteStoryViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        datePicker.minimumDate = Date()
    }
    
}
