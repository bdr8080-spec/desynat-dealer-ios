//
//  LiveCoverageFilterViewController.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 23/02/26.
//

import UIKit

protocol LiveCoverageFilterDelegate: AnyObject {
    func didApplyFilter(_ filter: LiveCoverageFilterModel)
    func didClearFilter()
}

class LiveCoverageFilterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var filterTableView: UITableView! {
        didSet {
            filterTableView.registerCellFromNib(cellID: "LiveCoverageFilterTableViewCell")
        }
    }
    @IBOutlet weak var txtFromDate: UITextField!
    @IBOutlet weak var txtToDate: UITextField!
    @IBOutlet weak var headerView: UIView!
    
    let datePicker = UIDatePicker()
    private var activeTextField: UITextField?
    weak var delegate: LiveCoverageFilterDelegate?
    var appliedFilter: LiveCoverageFilterModel?
    private var filterArray = ["Pending", "Compeleted", "Cancelled", "Rejected"]
    var selcetedStatusIndex: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFields()
        setupUI()
        restoreAppliedFilter()
    }
    
    private func restoreAppliedFilter() {
        guard let filter = appliedFilter else { return }
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd" // API format
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "dd/MM/yyyy" // UI format
        
        if let fromDateStr = filter.fromDate, let fromDate = inputFormatter.date(from: fromDateStr) {
            txtFromDate.text = displayFormatter.string(from: fromDate)
        }
        
        if let toDateStr = filter.toDate, let toDate = inputFormatter.date(from: toDateStr) {
            txtToDate.text = displayFormatter.string(from: toDate)
        }
        
        if let status = filter.filterId {
            selcetedStatusIndex = status
        }
    }
    
    func setupUI() {
        headerView.layer.cornerRadius = 32
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
    }
    
    @IBAction func btnDismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnClear(_ sender: Any) {
        selcetedStatusIndex = -1
        txtFromDate.text = ""
        txtToDate.text = ""
        delegate?.didClearFilter()
        dismiss(animated: true)
    }
    
    @IBAction func btnApply(_ sender: Any) {
        var filter = appliedFilter ?? LiveCoverageFilterModel()
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd/MM/yyyy"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let fromText = txtFromDate.text, let fromDate = inputFormatter.date(from: fromText) {
            filter.fromDate = outputFormatter.string(from: fromDate)
        } else {
            filter.fromDate = nil
        }
        
        if let toText = txtToDate.text, let toDate = inputFormatter.date(from: toText) {
            filter.toDate = outputFormatter.string(from: toDate)
        } else {
            filter.toDate = nil
        }
        
        filter.filterId = selcetedStatusIndex
        
        delegate?.didApplyFilter(filter)
        dismiss(animated: true)
    }
}

// Date Picker

extension LiveCoverageFilterViewController {
    
    private func setUpTextFields() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
//        datePicker.minimumDate = Date()
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
//            datePicker.minimumDate = Date()
        }
    }
}

extension LiveCoverageFilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LiveCoverageFilterTableViewCell", for: indexPath) as! LiveCoverageFilterTableViewCell
        cell.titleLabel.text = filterArray[indexPath.row]
        if selcetedStatusIndex == indexPath.row {
            cell.mainImageView.image = .radioSelected
        } else {
            cell.mainImageView.image = .radioUnselected
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selcetedStatusIndex = indexPath.row
        filterTableView.reloadData()
    }

}
