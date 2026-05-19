//
//  StaffManagementFilterViewController.swift
//  DesynatDealer
//
//  Created by fluper_mac2 on 19/05/26.
//

import UIKit

class StaffManagementFilterViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var roleCollectionView: UICollectionView! {
        didSet {
            roleCollectionView.registerCellFromNib(cellID: "RadioBtnCollectionViewCell")
        }
    }
    @IBOutlet weak var statusCollectionView: UICollectionView! {
        didSet {
            statusCollectionView.registerCellFromNib(cellID: "RadioBtnCollectionViewCell")
        }
    }
    
    var roles = [GetAllStaffRoles]()
    let datePicker = UIDatePicker()
    private var activeTextField: UITextField?
    var selectedFilter = StaffListFilterModel()
    var onApplyFilter: ((StaffListFilterModel) -> Void)?
    var onClearFilter: (() -> Void)?
    var selectedRoleId: Int = -1
    private var selectedStatus: Int = -1
    private let filtersOptions = ["Active", "Inactive"]
    private let statusMapping = [0, 1] // Active = 0, Inactive = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
       getAllRolesRequest()
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            applyPreselectedData()
        }
    
    // MARK: - Navigation
    
    @IBAction func dismissDidTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func clearDidTapped(_ sender: Any) {
        selectedRoleId = -1
                selectedStatus = -1
                fromTextField.text = ""
                toTextField.text = ""
                roleCollectionView.reloadData()
                statusCollectionView.reloadData()
                onClearFilter?()
                dismiss(animated: true)
    }
    
    @IBAction func applyDidTapped(_ sender: Any) {
        var filter = StaffListFilterModel()
                filter.fromDate = fromTextField.text?.isEmpty == false ? fromTextField.text : nil
                filter.toDate = toTextField.text?.isEmpty == false ? toTextField.text : nil
                if selectedRoleId != -1 {
                    filter.roleId = selectedRoleId
                }
                if selectedStatus != -1 {
                    filter.activeStatus = selectedStatus
                }
                onApplyFilter?(filter)
                dismiss(animated: true)
    }
    
    private func handleUISetup() {
            headerView.layer.cornerRadius = 24
            headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            headerView.clipsToBounds = true
            setUpTextFields()
        }
    
    func getAllRolesRequest() {
        WebService.sharedInstance.getAllRolesService { [weak self] response in
            guard let self = self else { return }
            self.roles = response
            self.applyPreselectedData()
            self.roleCollectionView.reloadData()
        }
    }
    
    private func applyPreselectedData() {
            fromTextField.text = selectedFilter.fromDate
            toTextField.text = selectedFilter.toDate
            // Role
            selectedRoleId = selectedFilter.roleId ?? -1
            // Status
            selectedStatus = selectedFilter.activeStatus ?? -1
            roleCollectionView.reloadData()
            statusCollectionView.reloadData()
        }
    
    
}

extension StaffManagementFilterViewController: UICollectionViewDataSource,
                                              UICollectionViewDelegate,
                                              UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {

        if collectionView == roleCollectionView {
            return roles.count
        } else {
            return filtersOptions.count
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "RadioBtnCollectionViewCell",
            for: indexPath
        ) as! RadioBtnCollectionViewCell

        if collectionView == roleCollectionView {

            let role = roles[indexPath.row]

            if AppLanguageManager.shared.currentLanguage == .ar {
                cell.titleLbl.text = role.nameAr
            } else {
                cell.titleLbl.text = role.nameEn
            }

            let isSelected = selectedRoleId == (role.id ?? 0)

            cell.updateSelectionState(isSelected: isSelected)

        } else {

            cell.titleLbl.text = filtersOptions[indexPath.row].localiz()

            let currentStatus = statusMapping[indexPath.row]

            let isSelected = selectedStatus == currentStatus

            cell.updateSelectionState(isSelected: isSelected)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let text: String

        if collectionView == roleCollectionView {

            let role = roles[indexPath.row]

            text = AppLanguageManager.shared.currentLanguage == .ar
            ? (role.nameAr ?? "")
            : (role.nameEn ?? "")

        } else {

            text = filtersOptions[indexPath.row].localiz()
        }

        let font = UIFont(name: "Poppins-Medium", size: 10)
        ?? UIFont.systemFont(ofSize: 10)

        let width = (text as NSString).size(withAttributes: [.font: font]).width

        return CGSize(width: width + 30, height: 24)
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

        if collectionView == roleCollectionView {

            let tappedRoleId = roles[indexPath.row].id ?? 0

            // Deselect if already selected
            if selectedRoleId == tappedRoleId {
                selectedRoleId = -1
            } else {
                selectedRoleId = tappedRoleId
            }

            roleCollectionView.reloadData()

        } else {

            let tappedStatus = statusMapping[indexPath.row]

            // Deselect if already selected
            if selectedStatus == tappedStatus {
                selectedStatus = -1
            } else {
                selectedStatus = tappedStatus
            }

            statusCollectionView.reloadData()
        }
    }
}

// MARK: - Date Picker

extension StaffManagementFilterViewController {

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

            if let toText = toTextField.text,
               let toDate = formatter.date(from: toText),
               toDate < datePicker.date {

                toTextField.text = ""
            }

        } else if activeTextField == toTextField {

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

        let alert = UIAlertController(
            title: "Invalid Date".localiz(),
            message: "To Date cannot be earlier than From Date.".localiz(),
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK".localiz(), style: .default))

        present(alert, animated: true)
    }

    @objc private func cancelDatePicker() {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate

extension StaffManagementFilterViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {

        activeTextField = textField

        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"

        if textField == toTextField {

            if let fromText = fromTextField.text,
               let fromDate = formatter.date(from: fromText) {

                datePicker.minimumDate = fromDate

            } else {

                datePicker.minimumDate = nil
            }
        }

        if textField == fromTextField {
            datePicker.minimumDate = nil
        }
    }
}

struct StaffListFilterModel {
    var roleId: Int?
    var activeStatus: Int?
    var fromDate: String?
    var toDate: String?
    
    var isEmpty: Bool {
        return roleId == nil && activeStatus == nil && fromDate == nil && toDate == nil
    }
}
