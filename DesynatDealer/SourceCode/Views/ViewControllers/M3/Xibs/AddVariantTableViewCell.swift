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
  
  weak var delegate: AddVariantCellDelegate?
    var images: [UIImage] = []                    // Only real uploaded images
      var imageURLs: [String] = []
  var onColorButtonTap: (() -> Void)?
  var onSizeButtonTap: (() -> Void)?
  var selectedColorId: Int? = -1
  var selectedSizeId: Int? = -1
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
      }
  }

  var discountTypeisPercentage = true {
      didSet {
          updateRadioButtons(selected: discountTypeisPercentage, yesButton: percentageButton, noButton: fixedPriceButton)
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
        
        // Safety: only reload if item actually exists
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
              // Always show placeholder at index 0
              cell.mainImageView.image = UIImage(named: "uploadProductImage")
          } else {
              // Real images from index 1 onwards
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
              // Only trigger image picker on placeholder
              delegate?.addImageTapped(from: self, at: images.count) // pass current count as insert position
          }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 162, height: 120)
  }
}

extension AddVariantTableViewCell {
    func validateFieldsWithErrors(isWomenCategory: Bool) -> String {
        var errors: String = ""
        if colorTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            errors = "Please select color"
        }else if sizeTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            errors = "Please select size"
        } else if totalStocksTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            errors = "Please enter total stocks"
        }else if skuTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            errors = "Please enter SKU"
        }else if skuThresholdTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            errors = "Please enter SKU limit"
        }else if actualPriceTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            errors = "Please enter actual price"
        } else if discountPriceTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
          errors = "Please enter discount price"
      }else if finalPriceTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            errors = "Please enter final price"
        }
        
        if isWomenCategory {
            if bsutTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                errors = "Please enter bust"
            }
            if waistTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                errors = "Please enter waist"
            }
            if shouldTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                errors = "Please enter hip"
            }
            if hipTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                errors = "Please enter shoulder"
            }
            if sleeveLengthTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                errors = "Please enter sleeve length"
            }
            if lengthTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                errors = "Please enter length"
            }
        }
        
        // Images
        let hasImage = !images.isEmpty
        if !hasImage {
            errors = "please upload product image"
        }
        
        return errors
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

//extension AddVariantTableViewCell: UITextFieldDelegate {
//    
//    private func setupTextFieldDelegates() {
//        totalStocksTF.delegate = self
//        skuThresholdTF.delegate = self
//        discountPriceTF.delegate = self
//        actualPriceTF.delegate = self
//        finalPriceTF.delegate = self
//        skuTF.delegate = self
//    }
//    
//    func textField(_ textField: UITextField,
//                   shouldChangeCharactersIn range: NSRange,
//                   replacementString string: String) -> Bool {
//        
//        // Convert NSRange → Swift Range safely
//        guard let swiftRange = Range(range, in: textField.text ?? "") else { return false }
//        let currentText = textField.text?.replacingCharacters(in: swiftRange, with: string) ?? string
//        
//        // Allow backspace
//        if string.isEmpty { return true }
//        
//        // Prevent leading space
//        if currentText.hasPrefix(" ") { return false }
//        
//        // Total Stocks: Max 6 digits
//        if textField == totalStocksTF {
//            return currentText.count <= 6 && string.areAllDigits
//        }
//        
//        // SKU Threshold ≤ Total Stocks
//        if textField == skuThresholdTF {
//            let total = Int(totalStocksTF.text ?? "0") ?? 0
//            let threshold = Int(currentText) ?? 0
//            return threshold <= total && string.areAllDigits
//        }
//        
//        // Discount % ≤ 100 (only when percentage mode)
//        if textField == discountPriceTF && discountTypeisPercentage {
//            let value = Int(currentText) ?? 0
//            return value <= 100 && string.areAllDigits
//        }
//        
//        // Price fields: Max 7 digits
//        if textField == actualPriceTF || textField == finalPriceTF {
//            return currentText.count <= 7 && string.areAllDigits
//        }
//        
//        // SKU: No spaces
//        if textField == skuTF {
//            return !string.contains(" ")
//        }
//        
//        return true
//    }
//}

// MARK: - Add This Extension Inside AddVariantTableViewCell.swift

// MARK: - UITextFieldDelegate + Validation (Add inside AddVariantTableViewCell)
extension AddVariantTableViewCell: UITextFieldDelegate {

    private func setupTextFieldDelegates() {
        let fields: [UITextField] = [
            totalStocksTF, skuThresholdTF,
            actualPriceTF, finalPriceTF,
            discountPriceTF, skuTF
        ]
        fields.forEach { $0.delegate = self }
    }

    // MARK: ONE AND ONLY shouldChangeCharactersIn
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        // Allow backspace
        guard !string.isEmpty else { return true }

        // ---- Block non-digits for number fields ----
        let numberFields: [UITextField] = [
            totalStocksTF, skuThresholdTF,
            actualPriceTF, finalPriceTF,
            discountPriceTF
        ]

        if numberFields.contains(textField) {
            let allowed = CharacterSet.decimalDigits
            if string.rangeOfCharacter(from: allowed.inverted) != nil {
                return false
            }
        }

        // ---- Block space in SKU ----
        if textField == skuTF && string.contains(" ") {
            return false
        }

        // ---- Real-time length limit (optional but nice) ----
        guard let currentText = textField.text else { return true }
        let newLength = currentText.count + string.count - range.length

        if textField == totalStocksTF && newLength > 6 { return false }
        if (textField == actualPriceTF || textField == finalPriceTF) && newLength > 7 { return false }

        return true
    }

    // MARK: Final validation + toast when user finishes editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let rawText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !rawText.isEmpty else { return }

        let value = Int(rawText) ?? 0

        // 1. Total Stocks – max 6 digits
        if textField == totalStocksTF {
            if rawText.count > 6 {
                textField.text = String(rawText.prefix(6))
                showToast("Total stocks cannot exceed 6 digits")
            }
            return
        }

        // 2. SKU Threshold – cannot be > Total Stocks
        if textField == skuThresholdTF {
            let totalText = totalStocksTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "0"
            let totalStocks = Int(totalText) ?? 0

            if totalStocks == 0 {
                textField.text = ""
                showToast("Please enter total stocks first")
            } else if value > totalStocks {
                textField.text = "\(totalStocks)"
                showToast("SKU threshold cannot exceed total stocks (\(totalStocks))")
            }
            return
        }

        // 3. Discount % – max 100 (only when percentage mode)
        if textField == discountPriceTF && discountTypeisPercentage {
            if value > 100 {
                textField.text = "100"
                showToast("Discount percentage cannot exceed 100%")
            }
            return
        }

        // 4. Price fields – max 7 digits
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
