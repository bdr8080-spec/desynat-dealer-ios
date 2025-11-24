//
//  AddSpecificationTableViewCell.swift
//  DesynatDealer
//
//  Created by fluper on 20/11/25.
//

import UIKit

class AddSpecificationTableViewCell: UITableViewCell {
  
  @IBOutlet weak var featuresEngTF: UITextField!
  @IBOutlet weak var featuresARTF: UITextField!
  @IBOutlet weak var nameARTF: UITextField!
  @IBOutlet weak var nameEngTF: UITextField!
  @IBOutlet weak var addNewView: UIView!
  @IBOutlet weak var removeButton: UIButton!
  @IBOutlet weak var addRemoveStackView: UIView!
  
  weak var delegate: AddSpecificationCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
  @IBAction func addTapped(_ sender: Any) {
    delegate?.addSpecificationTapped(from: self)
  }
  
  @IBAction func removeTapped(_ sender: Any) {
    delegate?.removeSpecificationTapped(from: self)
  }
  
}

extension AddSpecificationTableViewCell {

    /// Returns dictionary of fieldName: errorMessage
    func validateSpecificationFields() -> String {
        var errors: String = ""

        if nameEngTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            errors = "English name is required"
        }
        if nameARTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            errors = "Arabic name is required"
        }
        if featuresEngTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            errors = "English feature is required"
        }
        if featuresARTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            errors = "Arabic feature is required"
        }
        return errors
    }

//    func showSpecificationErrors(_ errors: [String: String]) {
//        var message = ""
//        for error in errors.values {
//            message += "\(error)\n"
//        }
//        if !message.isEmpty {
//            UIApplication.shared.keyWindow?.rootViewController?.presentAlert(title: "Validation Error", message: message)
//        }
//    }
}




protocol AddSpecificationCellDelegate: AnyObject {
  func addSpecificationTapped(from cell: AddSpecificationTableViewCell)
  func removeSpecificationTapped(from cell: AddSpecificationTableViewCell)
}
