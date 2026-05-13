//
//  AddNewSizeVariantTableViewCell.swift
//  DesynatDealer
//
//  Created by fluper on 01/12/25.
//

import UIKit

class AddNewSizeVariantTableViewCell: UITableViewCell {
  
  @IBOutlet weak var deleteButtonOutlet: UIButton!
  @IBOutlet weak var plusButonOutlet: UIButton!
  @IBOutlet weak var sizeTF: UITextField!
  @IBOutlet weak var priceView: CustomView!
  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var bustTF: UITextField!
  @IBOutlet weak var waistTF: UITextField!
  @IBOutlet weak var shoulderTF: UITextField!
  @IBOutlet weak var hipTF: UITextField!
  @IBOutlet weak var sleeveLengthTF: UITextField!
  @IBOutlet weak var lengthTF: UITextField!
  @IBOutlet weak var totalStocksTF: UITextField!
  @IBOutlet weak var skuLimitTF: UITextField!
  @IBOutlet weak var bustWaistStackView: UIStackView!
  @IBOutlet weak var hipShoulderStackView: UIStackView!
  @IBOutlet weak var actualPriceTF: UITextField!
  @IBOutlet weak var fixedPriceButton: UIButton!
  @IBOutlet weak var percentageButton: UIButton!
  @IBOutlet weak var discountPriceTF: UITextField!
  @IBOutlet weak var finalPriceTF: UITextField!
  @IBOutlet weak var sleeveLengthStackView: UIStackView!
  
  weak var delegate: AddNewSizeVariantDelegate?
  var sizesList: [SizeListDataModel] = []
  var variantArray: [Variant] = [Variant()]
  var selectedSizeId: Int? = -1
  private var isEditingField = false
  
  
  
  var sizeVariant: SizeVariant = SizeVariant() {
    didSet { populateFromModel() }
  }
  var onValueChanged: (() -> Void)?
  //  var onSizeSelected: ((Int, String) -> Void)?
  var onSizeButtonTap: (() -> Void)?
  var isWomenIsSelected: Bool = false {
    didSet {
      bustWaistStackView.isHidden = !isWomenIsSelected
      hipShoulderStackView.isHidden = !isWomenIsSelected
      sleeveLengthStackView.isHidden = !isWomenIsSelected
    }
  }
  
  var discountTypeisPercentage = true {
    didSet {
      updateDiscountPlaceholder()
      updateRadioButtons()
      updateFinalPrice()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupTextFieldDelegates()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
  @IBAction func deleetButtonAction(_ sender: Any) {
    delegate?.removeSizeTapped(from: self)
  }
  
  @IBAction func plusButtonAction(_ sender: Any) {
    delegate?.addNewSizeTapped(from: self)
  }
  
  @IBAction func sizeButtonAction(_ sender: Any) {
    onSizeButtonTap?()
  }
  
  @IBAction func discountPriceAction(_ sender: Any) {
    discountTypeisPercentage.toggle()
    discountPriceTF.text = ""
    finalPriceTF.text = ""
    //            updateModelFromUI()
    onValueChanged?()
  }
  
  func saveToModel() {
    sizeVariant.sizeId           = selectedSizeId
    sizeVariant.totalStock       = totalStocksTF.text ?? ""
    sizeVariant.sku              = skuLimitTF.text ?? ""
    sizeVariant.actualPrice      = actualPriceTF.text ?? ""
    sizeVariant.discountValue    = discountPriceTF.text ?? ""
    sizeVariant.discountTypeIsPercentage = discountTypeisPercentage
    sizeVariant.finalPrice       = finalPriceTF.text ?? ""
    sizeVariant.bust         = bustTF.text ?? ""
    sizeVariant.waist        = waistTF.text ?? ""
    sizeVariant.hip          = hipTF.text ?? ""
    sizeVariant.shoulder     = shoulderTF.text ?? ""
    sizeVariant.sleeveLength = sleeveLengthTF.text ?? ""
    sizeVariant.length       = lengthTF.text ?? ""
//    print("------ SAVED SIZE DATA ------")
//    print("Size: \(sizeVariant.sizeId)")
//    print("Actual Price: \(sizeVariant.actualPrice)")
//    print("Final Price: \(sizeVariant.finalPrice)")
//    print("Discount: \(sizeVariant.discountValue)")
//    print("Total Stocks: \(sizeVariant.totalStock)")
//    print("SKU Limit: \(sizeVariant.sku)")
//    print("--------------------------------")
  }
  
  
  
  private func populateFromModel() {
    guard !isEditingField else { return } // Don't overwrite while editing
    
    bustTF.text = sizeVariant.bust
    waistTF.text = sizeVariant.waist
    hipTF.text = sizeVariant.hip
    shoulderTF.text = sizeVariant.shoulder
    sleeveLengthTF.text = sizeVariant.sleeveLength
    lengthTF.text = sizeVariant.length
    
    totalStocksTF.text = sizeVariant.totalStock
    skuLimitTF.text = sizeVariant.sku
    actualPriceTF.text = sizeVariant.actualPrice
    discountPriceTF.text = sizeVariant.discountValue
    finalPriceTF.text = sizeVariant.finalPrice
    
    discountTypeisPercentage = sizeVariant.discountTypeIsPercentage
    
    updateDiscountPlaceholder()
    updateRadioButtons()
    updateFinalPrice()
  }
  
  private func updateRadioButtons() {
    percentageButton.setImage(UIImage(named: discountTypeisPercentage ? "radioSelected" : "radioUnselected"), for: .normal)
    fixedPriceButton.setImage(UIImage(named: discountTypeisPercentage ? "radioUnselected" : "radioSelected"), for: .normal)
  }
  
  private func updateFinalPrice(for discountValue: Int? = nil) {
    guard let actualPriceText = actualPriceTF.text?.trimmingCharacters(in: .whitespaces),
          !actualPriceText.isEmpty,
          let actualPrice = Int(actualPriceText), actualPrice > 0 else {
      finalPriceTF.text = ""
      return
    }
    let discount = discountValue ?? (Int(discountPriceTF.text ?? "0") ?? 0)
    var finalPrice: Double
    if discountTypeisPercentage {
      let discountAmount = Double(actualPrice) * Double(discount) / 100.0
      finalPrice = Double(actualPrice) - discountAmount
    } else {
      finalPrice = Double(actualPrice) - Double(discount)
    }
    if finalPrice < 0 { finalPrice = 0 }
    let roundedPrice = discountTypeisPercentage ? Int(floor(finalPrice)) : Int(round(finalPrice))
    var displayPrice = roundedPrice
    if discountTypeisPercentage && discount > 0 && displayPrice >= actualPrice {
      displayPrice = actualPrice - 1
    }
    displayPrice = max(displayPrice, 0)
    finalPriceTF.text = "\(displayPrice)"
  }
  
  private func updateDiscountPlaceholder() {
    if discountTypeisPercentage {
        discountPriceTF.placeholder = "E.g. 10%".localiz()
      discountPriceTF.keyboardType = .numberPad
    } else {
        discountPriceTF.placeholder = "E.g. 1200 KD".localiz()
      discountPriceTF.keyboardType = .numberPad
    }
  }
  
  
  
}


extension AddNewSizeVariantTableViewCell {
  
  func validateFieldsWithErrors(isWomenCategory: Bool) -> String {
    
    func isEmpty(_ text: String?) -> Bool {
      return text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
    }
    
      if isEmpty(sizeTF.text) { return "Please select size".localiz() }
    
    if isWomenCategory {
        if isEmpty(bustTF.text)        { return "Please enter bust".localiz() }
        if isEmpty(waistTF.text)       { return "Please enter waist".localiz() }
        if isEmpty(hipTF.text)         { return "Please enter hip".localiz() }
        if isEmpty(shoulderTF.text)      { return "Please enter shoulder".localiz() }
        if isEmpty(sleeveLengthTF.text){ return "Please enter sleeve length".localiz() }
        if isEmpty(lengthTF.text)      { return "Please enter length".localiz() }
    }
    
      if isEmpty(totalStocksTF.text) { return "Please enter total stocks".localiz() }
    
      if isEmpty(skuLimitTF.text) { return "Please enter SKU limit".localiz() }
    
      if isEmpty(actualPriceTF.text) { return "Please enter actual price".localiz() }
    
    if isEmpty(discountPriceTF.text) {
      return discountTypeisPercentage
        ? "Please enter discount percentage".localiz()
        : "Please enter discount fixed price".localiz()
    }
    
      if isEmpty(finalPriceTF.text) { return "Final price is missing".localiz() }
    return ""
  }
  
}

// MARK: - UITextFieldDelegate + Validation (Add inside AddNewSizeVariantTableViewCell)
extension AddNewSizeVariantTableViewCell: UITextFieldDelegate {
  func setupTextFieldDelegates() {
    let textFields: [UITextField] = [
      sizeTF, bustTF, waistTF, hipTF, shoulderTF,
      sleeveLengthTF, lengthTF, totalStocksTF, skuLimitTF,
      actualPriceTF, discountPriceTF, finalPriceTF
    ]
    
    for tf in textFields {
      tf.delegate = self   // Keep delegate for safe editing if needed
      tf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
      tf.keyboardType = .numberPad
    }
  }
  
  @objc private func textFieldDidChange(_ textField: UITextField) {
    // Optional: limit digits manually if needed
    if let text = textField.text, text.count > 7 {
      textField.text = String(text.prefix(7))
    }
    saveToModel() // Auto-save every change
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    isEditingField = true
  }
  
  //  // MARK: ONE AND ONLY shouldChangeCharactersIn
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    
    let currentText = textField.text ?? ""
    let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
    let measurementFields: [UITextField] = [bustTF, waistTF, hipTF, shoulderTF, sleeveLengthTF, lengthTF]
    if measurementFields.contains(textField) {
      if !string.isEmpty && string.rangeOfCharacter(from: .decimalDigits.inverted) != nil {
        return false
      }
      if updatedText.count == 1 && updatedText == "0" {
        return false
      }
      if currentText.isEmpty && string == "0" {
        return false
      }
      if updatedText.count > 7 {
        return false
      }
      return true
    }
    
//    if textField == discountPriceTF {
//      if string == " " { return false }
////      if updatedText.count == 1 && updatedText == "0" {
////        return false
////      }
//      let currentText = textField.text ?? ""
//      let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
//      let discount = Int(updatedText) ?? 0
//      let actualPrice = Int(actualPriceTF.text ?? "0") ?? 0
//      if discountTypeisPercentage {
//        if discount > 100 {
//          return false
//        }
//      } else {
//        if discount >= actualPrice {
//          return false
//        }
//      }
//      if discount > 0 {
//        updateFinalPrice(for: discount)
//      } else {
//        finalPriceTF.text = ""
//      }
//      return true
//    }
    
    if textField == discountPriceTF {

        // No spaces
        if string == " " { return false }

        // Only digits
        if string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil {
            return false
        }

        // Allow empty (backspace)
        if updatedText.isEmpty {
            finalPriceTF.text = ""
            return true
        }

        let discount = Int(updatedText) ?? 0
        let actualPrice = Int(actualPriceTF.text ?? "0") ?? 0

        if discountTypeisPercentage {
            // Percentage: allow 0–100
            if discount > 100 {
                return false
            }
        } else {
            // Fixed price: allow 0 < actual price
            if discount > actualPrice {
                return false
            }
        }

        updateFinalPrice(for: discount)
        return true
    }

    
    if textField == actualPriceTF {
      let newText = updatedText.trimmingCharacters(in: .whitespacesAndNewlines)
//      print("Updated text:", newText)
      
      // Allow empty
      if newText.isEmpty {
        finalPriceTF.text = ""
        discountPriceTF.text = ""
        return true
      }
      
      // Only digits
      if string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil {
        return false
      }
      
      // Limit digits
      if newText.count > 7 {
          CommonUtils.showToast(message: "Price cannot exceed 7 digits".localiz())
        return false
      }
      
      // Parse actual price safely
      guard let actualPrice = Double(newText) else {
        finalPriceTF.text = ""
        return true
      }
      
      let discount = Double(discountPriceTF.text ?? "0") ?? 0
//      print("Discount:", discount)
      
      var finalPrice: Double = actualPrice
      
      if discount > 0 {
        if discountTypeisPercentage {
          finalPrice = actualPrice - (actualPrice * discount / 100)
        } else {
          finalPrice = actualPrice - discount
        }
      }
      
      // Round and show integer value only
      let roundedFinal = Int(floor(finalPrice))
      
      if finalPrice < 0 {
        finalPriceTF.text = ""
        discountPriceTF.text = ""
      } else {
        if discount > 0 {
          finalPriceTF.text = "\(roundedFinal)"
        }
      }
      return true
    }
    
    
    if textField === skuLimitTF {
      
      // Block typing if Total Stocks empty
      let totalText = totalStocksTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
      guard let totalStocks = Int(totalText), totalStocks > 0 else {
          CommonUtils.showToast(message: "Please enter total stocks first".localiz())
        return false
      }
      
      // Block typing if SKU > Total Stocks
      if let updatedSKU = Int(updatedText), updatedSKU > totalStocks {
        //              showToast("SKU cannot exceed total stocks (\(totalStocks))")
          CommonUtils.showToast(message: "Sku limit can not be greater than Total stocks ".localiz())
        return false
      }
      
      // Only digits for SKU
      if string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil {
        return false
      }
      
      // No leading zero for SKU
      if updatedText.count == 1 && updatedText == "0" {
        return false
      }
      
      return true
    }
    
    let numericFields = [bustTF, waistTF, hipTF, shoulderTF, sleeveLengthTF, lengthTF, totalStocksTF, actualPriceTF, finalPriceTF, discountPriceTF].compactMap { $0 }
    
    if numericFields.contains(where: { $0 === textField }) {
      
      // No spaces
      if string == " " { return false }
      
      // Only digits
      if string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil {
        return false
      }
      
      // No leading zero
      if updatedText.count == 1 && updatedText == "0" {
        return false
      }
      
      // Total Stocks limit – max 6 digits
      if textField === totalStocksTF && updatedText.count > 6 {
        return false
      }
      
      if textField === actualPriceTF || textField === finalPriceTF {
        if updatedText.count > 7 {
            CommonUtils.showToast(message: "Price cannot exceed 7 digits".localiz())
          return false
        }
      }
      
      return true
    }
    
    return true
  }
  //
  //  // MARK: Final validation + toast when user finishes editing
  func textFieldDidEndEditing(_ textField: UITextField) {
    isEditingField = false
    saveToModel()
    guard let rawText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
          !rawText.isEmpty else { return }
    let actualPrice = Int(actualPriceTF.text ?? "") ?? 0
    let discountValue = Int(rawText) ?? 0
    if textField == actualPriceTF {
      let newText = rawText
      if newText.isEmpty {
        discountPriceTF.text = ""
        finalPriceTF.text = ""
      }
    }
    let value = Int(rawText) ?? 0
    if textField == totalStocksTF {
      if rawText.count > 6 {
        textField.text = String(rawText.prefix(6))
          CommonUtils.showToast(message: "Total stocks cannot exceed 6 digits".localiz())
      }
      return
    }
    if textField == skuLimitTF {
      let totalText = totalStocksTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "0"
      let totalStocks = Int(totalText) ?? 0
      
      if totalStocks == 0 {
        textField.text = ""
          CommonUtils.showToast(message: "Please enter total stocks first".localiz())
      } else if value > totalStocks {
        textField.text = "\(totalStocks)"
          let text = "SKU Limit cannot exceed total stocks".localiz()
        CommonUtils.showToast(message: "\(text) (\(totalStocks))")
      }
      return
    }
    if textField == discountPriceTF && discountTypeisPercentage {
      if value > 100 {
        textField.text = "100"
          CommonUtils.showToast(message: "Discount percentage cannot exceed 100%".localiz())
      }
      return
    }
    if textField == actualPriceTF || textField == finalPriceTF {
      if rawText.count > 7 {
        textField.text = String(rawText.prefix(7))
          CommonUtils.showToast(message: "Price cannot exceed 7 digits".localiz())
      }
    }
  }
  
}

protocol AddNewSizeVariantDelegate: AnyObject {
  func addNewSizeTapped(from cell: AddNewSizeVariantTableViewCell)
  func removeSizeTapped(from cell: AddNewSizeVariantTableViewCell)
}
