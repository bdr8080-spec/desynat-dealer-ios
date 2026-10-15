//
//  PaymentFilterViewController.swift
//  DesynatDealer
//
//  Created by fluper_mac2 on 29/04/26.
//

import UIKit

class PaymentFilterViewController: UIViewController {

    @IBOutlet weak var filterTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var filtersTableView: UITableView! {
        didSet {
            filtersTableView.dataSource = self
            filtersTableView.delegate = self
            filtersTableView.registerCellFromNib(cellID: "FiltersOptionsTableViewCell")
        }
    }
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var buttonActionStackView: UIStackView!

    let datePicker = UIDatePicker()
    private var activeTextField: UITextField?
    var selectedFilter = PayoutFilterModel()
    var onApplyFilter: ((PayoutFilterModel) -> Void)?
    var onClearFilter: (() -> Void)?
    // payment_mode -> 1 for online, 2 for wallet, 3 for cash on delivery
    private var filtersOptions = ["Online", "In Wallet", "COD"]
    private var selectedIndex: Int = -1
    private let statusMapping: [TransactionType] = [.Online, .InWallet, .COD]
    var selectedPayments: SelectedTab = .allTrasanctions
    // POSIX locale keeps western digits even when the app language is Arabic
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
        applyPreselectedData()
        buttonActionStackView.semanticContentAttribute = .forceLeftToRight
    }

    // MARK: - Actions

    @IBAction func dismissDidTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func clearDidTapped(_ sender: Any) {
        onClearFilter?()
        dismiss(animated: true)
    }

    @IBAction func applyDidTapped(_ sender: Any) {
        let from = fromTextField.text ?? ""
        let to = toTextField.text ?? ""

        // Date filter only works with both dates selected
        if from.isEmpty != to.isEmpty {
            let alert = UIAlertController(title: "Invalid Date".localiz(),
                                          message: "Please select both From and To date.".localiz(),
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".localiz(), style: .default))
            present(alert, animated: true)
            return
        }

        var filter = PayoutFilterModel()
        filter.fromDate = from.isEmpty ? nil : from
        filter.toDate = to.isEmpty ? nil : to
        // 1 = online, 2 = wallet, 3 = cash on delivery (list order: Online, In Wallet, COD)
        filter.statusId = (selectedIndex >= 0 && selectedIndex < filtersOptions.count) ? selectedIndex + 1 : nil

        onApplyFilter?(filter)
        dismiss(animated: true)
    }

    // MARK: - Setup

    private func handleUISetup() {
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
        setUpTextFields()
        if selectedPayments == .myPayouts {
            filtersTableView.isHidden = true
            filterTableViewHeight.constant = 0
        } else {
            filtersTableView.isHidden = false
            filterTableViewHeight.constant = 150
        }
    }

    private func applyPreselectedData() {
        fromTextField.text = selectedFilter.fromDate
        toTextField.text = selectedFilter.toDate

        if let statusId = selectedFilter.statusId, (1...filtersOptions.count).contains(statusId) {
            selectedIndex = statusId - 1
        } else {
            selectedIndex = -1
        }
        filtersTableView.reloadData()
    }
}

// MARK: - Options table

extension PaymentFilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filtersOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FiltersOptionsTableViewCell", for: indexPath) as! FiltersOptionsTableViewCell
        cell.titleLabel.text = filtersOptions[indexPath.row].localiz()
        cell.mainImageView.image = (selectedIndex == indexPath.row) ? .filledCheckbox : .checkBox
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // tapping the selected option again clears it
        selectedIndex = (selectedIndex == indexPath.row) ? -1 : indexPath.row
        filtersTableView.reloadData()
    }
}

// MARK: - Date pickers

extension PaymentFilterViewController {
    private func setUpTextFields() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.minimumDate = nil
        datePicker.backgroundColor = .white
        datePicker.locale = AppLanguageManager.shared.currentLanguage == .ar ? Locale(identifier: "ar") : Locale(identifier: "en_US")

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
        if activeTextField == fromTextField {
            fromTextField.text = dateFormatter.string(from: datePicker.date)
            if let toText = toTextField.text, let toDate = dateFormatter.date(from: toText), toDate < datePicker.date {
                toTextField.text = ""
            }
        } else if activeTextField == toTextField {
            if let fromText = fromTextField.text, let fromDate = dateFormatter.date(from: fromText), datePicker.date < fromDate {
                showValidationAlert()
                return
            }
            toTextField.text = dateFormatter.string(from: datePicker.date)
        }
        view.endEditing(true)
    }

    private func showValidationAlert() {
        let alert = UIAlertController(title: "Invalid Date".localiz(),
                                      message: "To Date cannot be earlier than From Date.".localiz(),
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localiz(), style: .default))
        present(alert, animated: true)
    }

    @objc private func cancelDatePicker() {
        view.endEditing(true)
    }
}

extension PaymentFilterViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        if textField == toTextField {
            if let fromText = fromTextField.text, let fromDate = dateFormatter.date(from: fromText) {
                datePicker.minimumDate = fromDate
            } else {
                datePicker.minimumDate = nil
            }
        } else if textField == fromTextField {
            datePicker.minimumDate = nil
        }
    }
}
