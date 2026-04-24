//
//  AffiliatedCommisionViewController.swift
//  DesynatDealer
//
//  Created by fluper on 05/12/25.
//

import UIKit

class AffiliatedCommisionViewController: UIViewController {
  
  @IBOutlet weak var commissionTF: UITextField!
  
  private lazy var viewModel = AffiliatedCommisionViewModel(hostVC: self)
  var commissionValue: String? = ""
    var hasActionPermission: Bool = false
    
  override func viewDidLoad() {
    super.viewDidLoad()
    commissionTF.delegate = self
    commissionTF.text = commissionValue
    commissionTF.isUserInteractionEnabled = false
  }
  
  
  @IBAction func saveChangesDidTapped(_ sender: Any) {
    let currentValue = commissionTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        // Check if value has changed
        if currentValue == (commissionValue ?? "") {
            CommonUtils.showToast(message: "No changes made to the commission value")
            return
        }
    if viewModel.validCommissionFields() {
      viewModel.updateAffiliated()
    }
  }
  
  @IBAction func bcakDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func editDidTapped(_ sender: Any) {
    commissionTF.isUserInteractionEnabled = true
    commissionTF.becomeFirstResponder()
  }
}

extension AffiliatedCommisionViewController: UITextFieldDelegate {
  
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    let currentText = textField.text ?? ""
    let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
    if textField == commissionTF {
      if string == " " { return false }
      if updatedText.count == 1 && updatedText == "0" {
        return false
      }
      let currentText = textField.text ?? ""
      let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
      let discount = Int(updatedText) ?? 0
      if discount > 100 {
        return false
      }
      return true
    }
    let numericFields = [commissionTF].compactMap { $0 }
    if numericFields.contains(where: { $0 === textField }) {
      if string == " " { return false }
      if string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil {
        return false
      }
      if updatedText.count == 1 && updatedText == "0" {
        return false
      }
      return true
    }
    return true
  }
  
  // MARK: Final validation + toast when user finishes editing
  func textFieldDidEndEditing(_ textField: UITextField) {
    guard let rawText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
          !rawText.isEmpty else { return }
    let value = Int(rawText) ?? 0
    if textField == commissionTF {
      if value > 100 {
        textField.text = "100"
        CommonUtils.showToast(message: "Affiliated Commission percentage cannot exceed 100%")
      }
      return
    }
  }
}
