//
//  SendNewLiveRequestViewController.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 13/02/26.
//

import UIKit

class SendNewLiveRequestViewController: UIViewController {

    @IBOutlet weak var totalCoverageLabel: UILabel!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var collectionViewHieghtconstraint: NSLayoutConstraint!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var timeCollectionView: UICollectionView! {
        didSet {
            timeCollectionView.registerCellFromNib(cellID: "SendNewLiveRequestCollectionViewCell")
        }
    }
    
    // MARK: - Properties
    private let datePicker = UIDatePicker()
    var onSendTapped: (() -> Void)?
    var selectedDateString: String? = ""
    private lazy var viewModel = SendNewLiveRequestViewModel(hostVC: self)
    private var selectedIndexID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
        setupDatePicker()
        dateTF.text = selectedDateString
        viewModel.getAllTimeSlotsRequest()
    }
    
    func handleHeightOfTableView() {
        DispatchQueue.main.async {
            self.timeCollectionView.layoutIfNeeded()
            self.collectionViewHieghtconstraint.constant =
                self.timeCollectionView.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
    

    @IBAction func dismissDidTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func sendRequestDidTapped(_ sender: Any) {
        guard let selectedIndexID = selectedIndexID else {
            showAlert(msg: "Please select time slot".localiz())
                return
            }
        viewModel.sendTimeSlotsRequest(timeslotId: selectedIndexID)
    }
    
    private func handleUISetup() {
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
    }
}

extension SendNewLiveRequestViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.timeSlotsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SendNewLiveRequestCollectionViewCell", for: indexPath) as! SendNewLiveRequestCollectionViewCell
        let data = viewModel.timeSlotsList[indexPath.row]
        if selectedIndexID == data.id {
            cell.mainImageView.image = .btnGradient
            cell.titleLabel.textColor = .white
        } else {
            cell.mainImageView.image = nil
            cell.titleLabel.textColor = .black
        }
        cell.configData(data: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexID = viewModel.timeSlotsList[indexPath.row].id
        timeCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 2
        let totalSpacing = spacing * 2
        let width = (collectionView.frame.width - totalSpacing) / 2
        return CGSize(width: width, height: 38)
    }
    
}

extension SendNewLiveRequestViewController {
    
    private func setupDatePicker() {
        
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date() // Prevent past dates
        datePicker.backgroundColor = .white
        if AppLanguageManager.shared.currentLanguage == .ar {
                datePicker.locale = Locale(identifier: "ar")
                datePicker.semanticContentAttribute = .forceRightToLeft
            } else {
                datePicker.locale = Locale(identifier: "en_US_POSIX")
                datePicker.semanticContentAttribute = .forceLeftToRight
            }
        // Toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(
            title: "Cancel".localiz(),
            style: .plain,
            target: self,
            action: #selector(cancelDatePicker)
        )
        
        let spaceButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        let doneButton = UIBarButtonItem(
            title: "Done".localiz(),
            style: .done,
            target: self,
            action: #selector(doneDatePicker)
        )
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        dateTF.inputView = datePicker
        dateTF.inputAccessoryView = toolbar
        dateTF.delegate = self
    }
    
    @objc private func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"//"dd/MM/yyyy"
        dateTF.text = formatter.string(from: datePicker.date)
        view.endEditing(true)
        selectedIndexID = nil
        selectedDateString = formatter.string(from: datePicker.date)
        viewModel.getAllTimeSlotsRequest()
    }
    
    @objc private func cancelDatePicker() {
        view.endEditing(true)
    }
}

extension SendNewLiveRequestViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dateTF {
            datePicker.minimumDate = Date() // always prevent past
        }
    }
}
