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
  var images: [UIImage?] = []
  var imageURLs: [String?] = [nil]
  var onColorButtonTap: (() -> Void)?
  var onSizeButtonTap: (() -> Void)?
  var selectedColorId: Int? = -1
  var selectedSizeId: Int? = -1
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
    let lastIndex = images.count - 1
    if lastIndex >= 0 {
      imagesCollectionView.scrollToItem(at: IndexPath(item: lastIndex, section: 0), at: .right, animated: true)
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
    return images.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductDetailImageCollectionViewCell", for: indexPath) as! ProductDetailImageCollectionViewCell
        cell.mainImageView.layer.cornerRadius = 12
        if let image = images[indexPath.item] {
            cell.mainImageView.image = image
        } else {
            cell.mainImageView.image = UIImage(named: "uploadImages") // placeholder
        }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.addImageTapped(from: self, at: indexPath.item)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 162, height: 120)
  }
}

extension AddVariantTableViewCell {
    func validateFieldsWithErrors(isWomenCategory: Bool) -> String {
        var errors: String = ""
        if colorTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            errors = "Color is required"
        }else if sizeTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            errors = "Size is required"
        } else if totalStocksTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            errors = "Total stock is required"
        }else if skuTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            errors = "SKU is required"
        }else if skuThresholdTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            errors = "SKU Limit is required"
        }else if actualPriceTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            errors = "Actual price is required"
        }else if finalPriceTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            errors = "Final price is required"
        }
        
        if isWomenCategory {
            if bsutTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                errors = "Bust is required"
            }
            if waistTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                errors = "Waist is required"
            }
            if shouldTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                errors = "Shoulder is required"
            }
            if hipTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                errors = "Hip is required"
            }
            if sleeveLengthTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                errors = "Sleeve length is required"
            }
            if lengthTF.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                errors = "Length is required"
            }
        }
        
        // Images
        let hasImage = images.contains { $0 != nil }
        if !hasImage {
            errors = "At least one image is required"
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
