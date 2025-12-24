//
//  BannerFilterVC.swift
//  DesynatDealer
//
//  Created by fluper on 24/12/25.
//

import UIKit

class BannerFilterVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img5: UIImageView!
    @IBOutlet weak var txtFromDate: UITextField!
    @IBOutlet weak var txtToDate: UITextField!
    @IBOutlet weak var headerView: UIView!
    
    let datePicker = UIDatePicker()
    private var activeTextField: UITextField?
    weak var delegate: BannerFilterDelegate?
    var appliedFilter: BannerFilterModel?
    private var selectedStatuses: Set<Int> = []
    private var selectedStatus: Int?
    private var statusImages: [UIImageView] {
        return [img1, img2, img3, img4, img5]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFields()
        setupUI()
        restoreAppliedFilter()
    }
    
    private func restoreAppliedFilter() {
        guard let filter = appliedFilter else { return }
        
        txtFromDate.text = filter.fromDate
        txtToDate.text = filter.toDate
        
        if let status = filter.statusIds.first {
            selectedStatus = status
            for (index, imageView) in statusImages.enumerated() {
                imageView.image = (index + 1 == status)
                ? UIImage(named: "radioSelected")
                : UIImage(named: "radioUnselected")
            }
        }
    }
    
    func setupUI() {
      headerView.layer.cornerRadius = 32
      headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
      headerView.clipsToBounds = true
    }

    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func btnSelectStatus(_ sender: UIButton) {
        let selectedTag = sender.tag
        selectedStatus = selectedTag
        
        for (index, imageView) in statusImages.enumerated() {
            if index + 1 == selectedTag {
                imageView.image = UIImage(named: "radioSelected")
            } else {
                imageView.image = UIImage(named: "radioUnselected")
            }
        }
    }
    
    @IBAction func btnClear(_ sender: Any) {
        selectedStatus = nil
        txtFromDate.text = ""
        txtToDate.text = ""
        
        statusImages.forEach {
            $0.image = UIImage(named: "radioUnselected")
        }
        
        delegate?.didClearFilter()
        //dismiss(animated: true)
    }
    
    @IBAction func btnApply(_ sender: Any) {
        var filter = appliedFilter ?? BannerFilterModel()
        
        filter.fromDate = txtFromDate.text
        filter.toDate = txtToDate.text
        
        if let status = selectedStatus {
            filter.statusIds = [status]
        } else {
            filter.statusIds = []
        }
        
        delegate?.didApplyFilter(filter)
        dismiss(animated: true)
    }
}

// Date Picker
extension BannerFilterVC {
    private func setUpTextFields() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.backgroundColor = .white
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        let textFields = [txtFromDate, txtToDate]
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
        
        // Apply selected date
        activeTextField.text = formatter.string(from: datePicker.date)
        view.endEditing(true)
        
        // Handle automatic focus movement
        switch activeTextField {
        case txtFromDate:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.txtToDate.becomeFirstResponder()
            }
            
        default:
            break
        }
    }
    
    @objc private func cancelDatePicker() {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        if textField == txtToDate, let fromDateText = txtFromDate.text, let fromDate = formatter.date(from: fromDateText) {
            datePicker.minimumDate = fromDate
        } else {
            datePicker.minimumDate = Date()
        }
    }
}
