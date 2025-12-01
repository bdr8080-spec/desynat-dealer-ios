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
    featuresARTF.delegate = self
    featuresEngTF.delegate = self
    nameARTF.delegate = self
    nameEngTF.delegate = self
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
  func validateSpecificationFields() -> String {
    var errors: String = ""
    
    if nameEngTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
      errors = "Enter name in english"
    }else if nameARTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
      errors = "Enter name in arabic"
    }else if featuresEngTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
      errors = "Enter feature in english"
    }else if featuresARTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
      errors = "Enter feature in arabic"
    }
    return errors
  }
}

extension AddSpecificationTableViewCell: UITextFieldDelegate {
  
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    let currentText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
    if string.isEmpty { return true }
    if currentText.hasPrefix(" ") { return false }
    let fieldsAllowingSpaces: [UITextField] = [
      nameARTF,
      nameEngTF,
      featuresARTF,
      featuresEngTF,
    ]
    if textField == nameARTF ||  textField == featuresARTF {
      let allowedSet = CharacterSet(charactersIn: "\u{0600}"..."\u{06FF}")
        .union(CharacterSet(charactersIn: "\u{0750}"..."\u{077F}"))
        .union(CharacterSet(charactersIn: "\u{08A0}"..."\u{08FF}"))
        .union(CharacterSet.whitespaces)
      
      for scalar in string.unicodeScalars {
        if !allowedSet.contains(scalar) {
          CommonUtils.showToast(message: "Please switch to Arabic keyboard")
          return false
        }
      }
      return true
    }
    if textField == nameEngTF ||  textField == featuresEngTF {
      let allowedSet = CharacterSet.letters.union(.whitespaces)
      for scalar in string.unicodeScalars {
        if !allowedSet.contains(scalar) {
          return false
        }
      }
      return true
    }
    if !fieldsAllowingSpaces.contains(textField) {
      if string.contains(" ") {
        return false
      }
    }
    return true
    
  }
}

protocol AddSpecificationCellDelegate: AnyObject {
  func addSpecificationTapped(from cell: AddSpecificationTableViewCell)
  func removeSpecificationTapped(from cell: AddSpecificationTableViewCell)
}
