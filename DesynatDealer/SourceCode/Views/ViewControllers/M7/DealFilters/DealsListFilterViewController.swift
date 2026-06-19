//
//  DealsListFilterViewController.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 27/01/26.
//

import UIKit

class DealsListFilterViewController: UIViewController {
    
    @IBOutlet weak var buttonAcionStackView: UIStackView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    
    let datePicker = UIDatePicker()
    private var activeTextField: UITextField?
    var selectedFilter = DealListFilterModel()
    var onApplyFilter: ((DealListFilterModel) -> Void)?
    var onClearFilter: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
        applyPreselectedData()
        buttonAcionStackView.semanticContentAttribute = .forceLeftToRight
    }
    
    @IBAction func dismissDidTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func clearDidTapped(_ sender: Any) {
        onClearFilter?()
        dismiss(animated: true)
    }
    
    @IBAction func applyDidTapped(_ sender: Any) {
        var filter = DealListFilterModel()
        
        filter.fromDate = fromTextField.text?.isEmpty == false ? fromTextField.text : nil
        filter.toDate   = toTextField.text?.isEmpty == false ? toTextField.text : nil
        
        onApplyFilter?(filter)
        dismiss(animated: true)
    }
    
    private func handleUISetup() {
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
        setUpTextFields()
    }
    
    private func applyPreselectedData() {
        // Preselect date fields
        fromTextField.text = selectedFilter.fromDate
        toTextField.text = selectedFilter.toDate
    }
    
}

extension DealsListFilterViewController {
    private func setUpTextFields() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.minimumDate = nil
        datePicker.backgroundColor = .white
        if AppLanguageManager.shared.currentLanguage == .ar {
                datePicker.locale = Locale(identifier: "ar")
                datePicker.semanticContentAttribute = .forceRightToLeft
            } else {
                datePicker.locale = Locale(identifier: "en_US_POSIX")
                datePicker.semanticContentAttribute = .forceLeftToRight
            }
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done".localiz(), style: .done, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel".localiz(), style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        fromTextField.inputView = datePicker
        fromTextField.inputAccessoryView = toolbar
        toTextField.inputView = datePicker
        toTextField.inputAccessoryView = toolbar
        
        fromTextField.delegate = self
        toTextField.delegate = self
    }
    
    @objc private func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"

        if activeTextField == fromTextField {
            fromTextField.text = formatter.string(from: datePicker.date)

            // Reset To Date if it’s earlier than From Date
            if let toText = toTextField.text,
               let toDate = formatter.date(from: toText),
               toDate < datePicker.date {
                toTextField.text = ""
            }
        } else if activeTextField == toTextField {
            // Validate To Date >= From Date
            if let fromText = fromTextField.text,
               let fromDate = formatter.date(from: fromText),
               datePicker.date < fromDate {
                showValidationAlert()
                return
            }
            toTextField.text = formatter.string(from: datePicker.date)
        }

        view.endEditing(true)
    }

    
    private func showValidationAlert() {
        let alert = UIAlertController(title: "Invalid Date".localiz(),
                                      message: "To Date cannot be earlier than From Date.".localiz(),
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localiz(), style: .default))
        self.present(alert, animated: true)
    }
    
    
    @objc private func cancelDatePicker() {
        view.endEditing(true)
    }
}

extension DealsListFilterViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
            activeTextField = textField
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            
            if textField == toTextField {
                
                // ✅ First select From Date
                guard let fromText = fromTextField.text,
                      !fromText.isEmpty,
                      let fromDate = formatter.date(from: fromText) else {
                    
                    view.endEditing(true)
                    
                    showAlert(msg: "Please select From Date first".localiz())
                    return
                }
                
                // ✅ To Date should not be less than From Date
                datePicker.minimumDate = fromDate
            }
            
            if textField == fromTextField {
                datePicker.minimumDate = nil
            }
        }
}

struct DealListFilterModel {
    var fromDate: String?
    var toDate: String?
    
    var isEmpty: Bool {
        return fromDate == nil && toDate == nil
    }
}

