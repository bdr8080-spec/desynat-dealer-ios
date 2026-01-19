//
//  OrdersfilterViewController.swift
//  DesynatDealer
//
//  Created by fluper on 05/01/26.
//

import UIKit

class OrdersfilterViewController: UIViewController {
  
  @IBOutlet weak var filtersTableView: UITableView! {
    didSet{
      filtersTableView.registerCellFromNib(cellID: "FiltersOptionsTableViewCell")
    }
  }
  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var toTextField: UITextField!
  @IBOutlet weak var fromTextField: UITextField!
  
  let datePicker = UIDatePicker()
  private var activeTextField: UITextField?
  var selectedFilter = OrderListFilterModel()
  var onApplyFilter: ((OrderListFilterModel) -> Void)?
  var onClearFilter: (() -> Void)?
  
  private var filtersOptions = ["Confirmed", "Packed", "Shipped", "Exchange"]
  private var selectedIndex: Int = -1
    private let statusMapping: [OrderStatus] = [
        .confirmed,
        .packed,
        .shipped,
        .exchange
    ]

  override func viewDidLoad() {
    super.viewDidLoad()
    handleUISetup()
    applyPreselectedData()
  }
  
  @IBAction func dismissDidTapped(_ sender: Any) {
    self.dismiss(animated: true)
  }
  
  @IBAction func clearDidTapped(_ sender: Any) {
    onClearFilter?()
    dismiss(animated: true)
  }
  
  @IBAction func applyDidTapped(_ sender: Any) {
      var filter = OrderListFilterModel()

          filter.fromDate = fromTextField.text?.isEmpty == false ? fromTextField.text : nil
          filter.toDate   = toTextField.text?.isEmpty == false ? toTextField.text : nil

          if selectedIndex >= 0 && selectedIndex < statusMapping.count {
              filter.orderDeliveryStatus = statusMapping[selectedIndex]
          } else {
              filter.orderDeliveryStatus = nil
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
  
  private func applyPreselectedData() {
    // Preselect date fields
    fromTextField.text = selectedFilter.fromDate
    toTextField.text = selectedFilter.toDate
      if let status = selectedFilter.orderDeliveryStatus,
             let index = statusMapping.firstIndex(of: status) {
              selectedIndex = index
          } else {
              selectedIndex = -1
          }

          filtersTableView.reloadData()
  }
  
}

extension OrdersfilterViewController:  UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filtersOptions.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FiltersOptionsTableViewCell", for: indexPath) as! FiltersOptionsTableViewCell
    cell.titleLabel.text = filtersOptions[indexPath.row]
    if selectedIndex == indexPath.row {
      cell.mainImageView.image = .filledCheckbox//UIImage(named: "filledCheckbox")
    } else {
      cell.mainImageView.image = .checkBox//UIImage(named: "checkBox")
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedIndex = indexPath.row
    filtersTableView.reloadData()
  }
  
}

extension OrdersfilterViewController {
  private func setUpTextFields() {
    datePicker.preferredDatePickerStyle = .wheels
    datePicker.datePickerMode = .date
    datePicker.minimumDate = nil
    datePicker.backgroundColor = .white
    
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    
    let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneDatePicker))
    let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
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
    }
    
    else if activeTextField == toTextField {
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
    let alert = UIAlertController(title: "Invalid Date",
                                  message: "To Date cannot be earlier than From Date.",
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    self.present(alert, animated: true)
  }
  
  
  @objc private func cancelDatePicker() {
    view.endEditing(true)
  }
}

extension OrdersfilterViewController: UITextFieldDelegate {
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

struct OrderListFilterModel {
//  var orderDeliveryStatus: String?
//  var fromDate: String?
//  var toDate: String?
//  
//  var isEmpty: Bool {
//    return fromDate == nil && toDate == nil
//  }
  
  var orderDeliveryStatus: OrderStatus?
  var fromDate: String?
  var toDate: String?
  
  var isEmpty: Bool {
    return orderDeliveryStatus == nil && fromDate == nil && toDate == nil
  }
}
