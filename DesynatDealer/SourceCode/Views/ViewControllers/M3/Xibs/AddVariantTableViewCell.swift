//
//  AddVariantTableViewCell.swift
//  DesynatDealer
//
//  Created by fluper on 20/11/25.
//

import UIKit
import SDWebImage

class AddVariantTableViewCell: UITableViewCell {
  
  @IBOutlet weak var sizeTF: UITextField!
  @IBOutlet weak var colorTF: UITextField!
  @IBOutlet weak var priceView: CustomView!
  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var imagesCollectionView: UICollectionView!
  @IBOutlet weak var bsutTF: UITextField!
  @IBOutlet weak var waistTF: UITextField!
  @IBOutlet weak var shouldTF: UITextField!
  @IBOutlet weak var hipTF: UITextField!
  @IBOutlet weak var sleeveLengthTF: UITextField!
  @IBOutlet weak var lengthTF: UITextField!
  @IBOutlet weak var totalStocksTF: UITextField!
  @IBOutlet weak var skuTF: UITextField!
  @IBOutlet weak var skuThresholdTF: UITextField!
  @IBOutlet weak var bustWaistStackView: UIStackView!
  @IBOutlet weak var hipshouldStackView: UIStackView!
  @IBOutlet weak var actualPriceTF: UITextField!
  @IBOutlet weak var fixedPriceButton: UIButton!
  @IBOutlet weak var percentageButton: UIButton!
  @IBOutlet weak var discountPriceTF: UITextField!
  @IBOutlet weak var finalPriceTF: UITextField!
  @IBOutlet weak var sleeveLengthStackView: UIStackView!
  
  weak var delegate: AddVariantCellDelegate?
  var images: [UIImage] = []                    // Only real uploaded images
  var imageURLs: [String] = []
  var onColorButtonTap: (() -> Void)?
  var onSizeButtonTap: (() -> Void)?
  var selectedColorId: Int? = -1
  var selectedSizeId: Int? = -1
  private var finalPriceManuallyCleared = false
  
  private var displayImages: [UIImage?] {
    return [nil] + images  // nil = placeholder, then real images
  }
  
  private var displayImageURLs: [String?] {
    return [nil] + imageURLs
  }
  var isWomenIsSelected: Bool = false {
    didSet {
      bustWaistStackView.isHidden = !isWomenIsSelected
      hipshouldStackView.isHidden = !isWomenIsSelected
      sleeveLengthStackView.isHidden = !isWomenIsSelected
    }
  }
  
  var discountTypeisPercentage = true {
    didSet {
      updateRadioButtons(selected: discountTypeisPercentage, yesButton: percentageButton, noButton: fixedPriceButton)
      updateDiscountPlaceholder()
      updateFinalPrice()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    registerCell()
    setupTextFieldDelegates()
  }
  
  private func registerCell() {
    imagesCollectionView.delegate = self
    imagesCollectionView.dataSource = self
    imagesCollectionView.register(UINib(nibName: "ProductDetailImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductDetailImageCollectionViewCell")
  }
  
  @IBAction func deleteDidTapped(_ sender: Any) {
    delegate?.removeVariantTapped(from: self)
  }
  
  @IBAction func colourButtonAction(_ sender: Any) {
    onColorButtonTap?()
  }
  
  @IBAction func sizeButtonAction(_ sender: Any) {
    onSizeButtonTap?()
  }
  
  @IBAction func discountPriceAction(_ sender: Any) {
    discountTypeisPercentage.toggle()
    discountPriceTF.text = ""
    finalPriceTF.text = ""
  }
  
  func scrollToLastItem() {
    let lastIndex = displayImages.count - 1
    if lastIndex > 0 {
      imagesCollectionView.scrollToItem(at: IndexPath(item: lastIndex, section: 0), at: .right, animated: true)
    }
  }
  
  func reloadImageItem(at realIndex: Int) {
    let collectionIndex = realIndex + 1  // +1 because index 0 is placeholder
    let indexPath = IndexPath(item: collectionIndex, section: 0)
    if collectionIndex < imagesCollectionView.numberOfItems(inSection: 0) {
      imagesCollectionView.reloadItems(at: [indexPath])
    }
  }
  
  private func updateRadioButtons(selected: Bool, yesButton: UIButton, noButton: UIButton) {
    let yesImageName = selected ? "radioSelected" : "radioUnselected"
    let noImageName = selected ? "radioUnselected" : "radioSelected"
    
    yesButton.setImage(UIImage(named: yesImageName), for: .normal)
    noButton.setImage(UIImage(named: noImageName), for: .normal)
  }
  
//  private func updateFinalPrice(for discountValue: Int? = nil) {
//    guard let actualPrice = Int(actualPriceTF.text ?? "0") else {
//      finalPriceTF.text = ""
//      return
//    }
//    
//    let discount = discountValue ?? (Int(discountPriceTF.text ?? "0") ?? 0)
//    var finalPrice = actualPrice
//
//    if discountTypeisPercentage {
//      finalPrice = actualPrice - (actualPrice * discount / 100)
//    } else {
//      finalPrice = actualPrice - discount
//    }
//    
//    finalPriceTF.text = "\(finalPrice)"
//  }
  
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
      
      // Prevent negative
      if finalPrice < 0 { finalPrice = 0 }
      
      // THE KEY: For percentage discount, always floor (give benefit to customer)
      let roundedPrice = discountTypeisPercentage ? Int(floor(finalPrice)) : Int(round(finalPrice))
      
      // Never show same price if any % discount was applied
      var displayPrice = roundedPrice
      if discountTypeisPercentage && discount > 0 && displayPrice >= actualPrice {
          displayPrice = actualPrice - 1
      }
      
      displayPrice = max(displayPrice, 0)
      finalPriceTF.text = "\(displayPrice)"
  }
  
  func updateColorAndSizeDisplay(colorsList: [ColorsLisDataModel], sizesList: [SizeListDataModel]) {
    if let colorId = selectedColorId,
       let color = colorsList.first(where: { $0.id == colorId }) {
      colorTF.text = color.name
    } else {
      colorTF.text = ""
    }
    
    if let sizeId = selectedSizeId,
       let size = sizesList.first(where: { $0.id == sizeId }) {
      sizeTF.text = size.name
    } else {
      sizeTF.text = ""
    }
  }
  
  private func updateDiscountPlaceholder() {
    if discountTypeisPercentage {
      discountPriceTF.placeholder = "E.g. 10%"
      discountPriceTF.keyboardType = .numberPad
    } else {
      discountPriceTF.placeholder = "E.g. 1200 KD"
      discountPriceTF.keyboardType = .numberPad
    }
  }
  
}

extension AddVariantTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return displayImages.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductDetailImageCollectionViewCell", for: indexPath) as! ProductDetailImageCollectionViewCell
    cell.mainImageView.layer.cornerRadius = 12
    cell.mainImageView.contentMode = .scaleAspectFill
    cell.mainImageView.clipsToBounds = true
    
    if indexPath.item == 0 {
      cell.mainImageView.image = UIImage(named: "uploadProductImage")
    } else {
      let realIndex = indexPath.item - 1
      if realIndex < images.count {
        cell.mainImageView.image = images[realIndex]
      } else {
        cell.mainImageView.image = UIImage(named: "uploadProductImage")
      }
    }
    
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if indexPath.item == 0 {
      delegate?.addImageTapped(from: self, at: images.count)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 162, height: 120)
  }
}

extension AddVariantTableViewCell {
  
  func validateFieldsWithErrors(isWomenCategory: Bool) -> String {
    
    func isEmpty(_ text: String?) -> Bool {
      return text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
    }
    if images.isEmpty { return "please upload product image" }
    
    if isEmpty(colorTF.text) { return "Please select color" }
    
    if isEmpty(sizeTF.text) { return "Please select size" }
    
    if isWomenCategory {
      if isEmpty(bsutTF.text)        { return "Please enter bust" }
      if isEmpty(waistTF.text)       { return "Please enter waist" }
      if isEmpty(hipTF.text)         { return "Please enter hip" }
      if isEmpty(shouldTF.text)      { return "Please enter shoulder" }
      if isEmpty(sleeveLengthTF.text){ return "Please enter sleeve length" }
      if isEmpty(lengthTF.text)      { return "Please enter length" }
    }
    
    if isEmpty(totalStocksTF.text) { return "Please enter total stocks" }
    
    if isEmpty(skuTF.text) { return "Please enter SKU limit" }
    
    if isEmpty(actualPriceTF.text) { return "Please enter actual price" }
    
    if isEmpty(discountPriceTF.text) {
      return discountTypeisPercentage
      ? "Please enter discount percentage"
      : "Please enter discount fixed price"
    }
    
    if isEmpty(finalPriceTF.text) { return "Final price is missing" }
    return ""
  }
  
}

// MARK: - UITextFieldDelegate + Validation (Add inside AddVariantTableViewCell)
extension AddVariantTableViewCell: UITextFieldDelegate {
  
  private func setupTextFieldDelegates() {
    let fields: [UITextField] = [
      bsutTF, waistTF, hipTF, shouldTF, sleeveLengthTF, lengthTF,
      totalStocksTF, //skuThresholdTF,
      actualPriceTF, finalPriceTF,
      discountPriceTF, skuTF
    ]
    fields.forEach { $0.delegate = self }
  }
  
  // MARK: ONE AND ONLY shouldChangeCharactersIn
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    
    let currentText = textField.text ?? ""
    print("currentText==>\(currentText)")
    let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
    print("currentText==>\(updatedText)")
    let measurementFields: [UITextField] = [
      bsutTF, waistTF, hipTF, shouldTF, sleeveLengthTF, lengthTF
    ]
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
    
    if textField == discountPriceTF {
      if string == " " { return false }
      if updatedText.count == 1 && updatedText == "0" {
        return false
      }
      let currentText = textField.text ?? ""
      let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
      let discount = Int(updatedText) ?? 0
      let actualPrice = Int(actualPriceTF.text ?? "0") ?? 0
      if discountTypeisPercentage {
        if discount > 100 {
          return false
        }
      } else {
        if discount >= actualPrice {
          return false
        }
      }
      if discount > 0 {
        updateFinalPrice(for: discount)
      } else {
        finalPriceTF.text = ""
      }
      return true
    }
    
    if textField == actualPriceTF {
      let newText = updatedText.trimmingCharacters(in: .whitespacesAndNewlines)
      print("Updated text:", newText)
      
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
        showToast("Price cannot exceed 7 digits")
        return false
      }
      
      // Parse actual price safely
      guard let actualPrice = Double(newText) else {
        finalPriceTF.text = ""
        return true
      }
      
      let discount = Double(discountPriceTF.text ?? "0") ?? 0
      print("Discount:", discount)
      
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
    
    
    if textField === skuTF {
      
      // Block typing if Total Stocks empty
      let totalText = totalStocksTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
      guard let totalStocks = Int(totalText), totalStocks > 0 else {
        showToast("Please enter total stocks first")
        return false
      }
      
      // Block typing if SKU > Total Stocks
      if let updatedSKU = Int(updatedText), updatedSKU > totalStocks {
        //              showToast("SKU cannot exceed total stocks (\(totalStocks))")
        showToast("Sku limit can not be greater than Total stocks ")
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
    
    let numericFields = [
      bsutTF, waistTF, hipTF, shouldTF, sleeveLengthTF, lengthTF,
      totalStocksTF, actualPriceTF, finalPriceTF, discountPriceTF
    ].compactMap { $0 }
    
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
          showToast("Price cannot exceed 7 digits")
          return false
        }
      }
      
      return true
    }
    
    return true
  }
  
  // MARK: Final validation + toast when user finishes editing
  func textFieldDidEndEditing(_ textField: UITextField) {
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
        showToast("Total stocks cannot exceed 6 digits")
      }
      return
    }
    if textField == skuTF {
      let totalText = totalStocksTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "0"
      let totalStocks = Int(totalText) ?? 0
      
      if totalStocks == 0 {
        textField.text = ""
        showToast("Please enter total stocks first")
      } else if value > totalStocks {
        textField.text = "\(totalStocks)"
        showToast("SKU Limit cannot exceed total stocks (\(totalStocks))")
      }
      return
    }
    if textField == discountPriceTF && discountTypeisPercentage {
      if value > 100 {
        textField.text = "100"
        showToast("Discount percentage cannot exceed 100%")
      }
      return
    }
    if textField == actualPriceTF || textField == finalPriceTF {
      if rawText.count > 7 {
        textField.text = String(rawText.prefix(7))
        showToast("Price cannot exceed 7 digits")
      }
    }
  }
  
}

// MARK: - Toast Helper
private extension AddVariantTableViewCell {
  func showToast(_ message: String) {
    DispatchQueue.main.async {
      CommonUtils.showToast(message: message)
      // or your own toast method
    }
  }
}

// Helper
private extension String {
  var areAllDigits: Bool {
    return !isEmpty && rangeOfCharacter(from: .decimalDigits.inverted) == nil
  }
}

protocol AddVariantCellDelegate: AnyObject {
  func removeVariantTapped(from cell: AddVariantTableViewCell)
  func addImageTapped(from cell: AddVariantTableViewCell, at index: Int)
}

struct VariantImage {
  var image: UIImage?
  var isPlaceholder: Bool
}

