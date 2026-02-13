//
//  SendNewLiveRequestViewController.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 13/02/26.
//

import UIKit

class SendNewLiveRequestViewController: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
        setupDatePicker()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async { [self] in
            self.collectionViewHieghtconstraint.constant = self.timeCollectionView.contentSize.height
        }
    }

    @IBAction func dismissDidTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func sendRequestDidTapped(_ sender: Any) {
        print("Selected Date:", dateTF.text ?? "")
        dismiss(animated: true) { [weak self] in
               self?.onSendTapped?()
           }
    }
    
    private func handleUISetup() {
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
    }
}


extension SendNewLiveRequestViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SendNewLiveRequestCollectionViewCell", for: indexPath) as! SendNewLiveRequestCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 3
        let totalSpacing = spacing * 2
        let width = (collectionView.frame.width - totalSpacing) / 2
        return CGSize(width: width, height: 38)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewDidLayoutSubviews()
    }
    
}

extension SendNewLiveRequestViewController {
    
    private func setupDatePicker() {
        
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date() // Prevent past dates
        datePicker.backgroundColor = .white
        
        // Toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(
            title: "Cancel",
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
            title: "Done",
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
        formatter.dateFormat = "dd/MM/yyyy"
        
        dateTF.text = formatter.string(from: datePicker.date)
        view.endEditing(true)
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
