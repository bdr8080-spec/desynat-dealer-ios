//
//  AddVariantTableViewCell.swift
//  DesynatDealer
//
//  Created by fluper on 20/11/25.
//

import UIKit
import SDWebImage

protocol AddVariantCellDelegate: AnyObject {
  func removeVariantTapped(from cell: AddVariantTableViewCell)
  func addImageTapped(from cell: AddVariantTableViewCell, at index: Int)
}

class AddVariantTableViewCell: UITableViewCell {
  
  @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var colorTF: UITextField!
  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var imagesCollectionView: UICollectionView!
  @IBOutlet weak var sizeVariantTableView: UITableView!
  
  weak var delegate: AddVariantCellDelegate?
  var images: [UIImage] = []
  var imageURLs: [String] = []
  var onColorButtonTap: (() -> Void)?
  var sizesList: [SizeListDataModel] = []
  var selectedColorId: Int? = -1
  var sizeVariants: [SizeVariant] = [SizeVariant()]
  var addedSizeVariantDetails: ((SizeVariant) -> SizeVariant)?
//  var onAddNewSizeRequested: (() -> Void)?
  var onSizeVariantsChanged: (([SizeVariant]) -> Void)?
  var onVariantUpdated: ((Variant) -> Void)?
  var isWomenIsSelected: Bool = false {
    didSet { sizeVariantTableView.reloadData() }
  }
  
  private var displayImages: [UIImage?] {
    return [nil] + images
  }
  
  private var displayImageURLs: [String?] {
    return [nil] + imageURLs
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    registerCell()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      self.updateTableViewHeight()
    }
  }
  
  private func registerCell() {
    imagesCollectionView.delegate = self
    imagesCollectionView.dataSource = self
    imagesCollectionView.register(UINib(nibName: "ProductDetailImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductDetailImageCollectionViewCell")
    sizeVariantTableView.delegate = self
    sizeVariantTableView.dataSource = self
    sizeVariantTableView.register(UINib(nibName: "AddNewSizeVariantTableViewCell", bundle: nil), forCellReuseIdentifier: "AddNewSizeVariantTableViewCell")
  }
  
  func updateTableViewHeight() {
    sizeVariantTableView.layoutIfNeeded()
    
    var height = sizeVariantTableView.contentSize.height
    height += 20
    if height < 100 {
      height = 150
    }
    UIView.animate(withDuration: 0.1) {
      self.tableViewHeightConstraint.constant = height
      self.layoutIfNeeded()
    }
  }
  
  @IBAction func deleteDidTapped(_ sender: Any) {
    delegate?.removeVariantTapped(from: self)
  }
  
  @IBAction func colourButtonAction(_ sender: Any) {
    onColorButtonTap?()
  }
  
  func scrollToLastItem() {
    let lastIndex = displayImages.count - 1
    if lastIndex > 0 {
      imagesCollectionView.scrollToItem(at: IndexPath(item: lastIndex, section: 0), at: .right, animated: true)
    }
  }
  
  func reloadImageItem(at realIndex: Int) {
    let collectionIndex = realIndex + 1
    let indexPath = IndexPath(item: collectionIndex, section: 0)
    if collectionIndex < imagesCollectionView.numberOfItems(inSection: 0) {
      imagesCollectionView.reloadItems(at: [indexPath])
    }
  }
  
  func updateColorAndSizeDisplay(colorsList: [ColorsLisDataModel], sizesList: [SizeListDataModel]) {
    if let colorId = selectedColorId,
       let color = colorsList.first(where: { $0.id == colorId }) {
      colorTF.text = color.name
    } else {
      colorTF.text = ""
    }
    self.sizesList = sizesList
  }
  
  private func showSizeDropdown(from textField: UITextField, for indexPath: IndexPath) {
    let sizesNames = sizesList.map { $0.name ?? "" }
    kSharedAppDelegate.dropDown(dataSource: sizesNames, anchorView: textField) { [weak self] selectedIndex, selectedItem in
      guard let self = self else { return }
      let selectedSize = self.sizesList[selectedIndex]
      if self.sizeVariants.indices.contains(indexPath.row) {
        var updatedSizeVariant = self.sizeVariants[indexPath.row]
        updatedSizeVariant.sizeId = selectedSize.id
        self.sizeVariants[indexPath.row] = updatedSizeVariant
      }
      DispatchQueue.main.async {
        self.sizeVariantTableView.reloadRows(at: [indexPath], with: .none)
      }
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

extension AddVariantTableViewCell: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sizeVariants.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewSizeVariantTableViewCell", for: indexPath) as! AddNewSizeVariantTableViewCell
    let sizeVar = sizeVariants[indexPath.row]
    cell.sizeVariant = sizeVar
    cell.bustTF.text = sizeVar.bust
    cell.waistTF.text = sizeVar.waist
    cell.hipTF.text = sizeVar.hip
    cell.shoulderTF.text = sizeVar.shoulder
    cell.sleeveLengthTF.text = sizeVar.sleeveLength
    cell.lengthTF.text = sizeVar.length
    cell.totalStocksTF.text = sizeVar.totalStock
    cell.skuLimitTF.text = sizeVar.sku
    cell.actualPriceTF.text = sizeVar.actualPrice
    cell.finalPriceTF.text = sizeVar.finalPrice
    cell.discountPriceTF.text = sizeVar.discountValue
    cell.discountTypeisPercentage = sizeVar.discountTypeIsPercentage
    
    if let sizeId = sizeVar.sizeId,
       let sizeModel = self.sizesList.first(where: { $0.id == sizeId }) {
      cell.sizeTF.text = sizeModel.name
      cell.selectedSizeId = sizeId
    } else {
      cell.sizeTF.text = ""
      cell.selectedSizeId = -1
    }
    cell.isWomenIsSelected = isWomenIsSelected
    cell.delegate = self
    cell.deleteButtonOutlet.isHidden = sizeVariants.count <= 1
    
    if indexPath.row == 0 {
      cell.deleteButtonOutlet.isHidden = true
      cell.priceView.backgroundColor = UIColor(named: "#FFF7EA")
    } else {
      cell.deleteButtonOutlet.isHidden = false
      //              cell.titleLabel?.text = "Variant \(indexPath.row + 1)"
    }
    cell.sizesList = self.sizesList
    cell.onSizeButtonTap = { [weak self] in
      guard let self = self else { return }
      guard let indexPath = self.sizeVariantTableView.indexPath(for: cell) else { return }
      
      let sizeVariantCell = cell as? AddNewSizeVariantTableViewCell
      guard let textField = sizeVariantCell?.sizeTF else { return }
      
      self.showSizeDropdown(from: textField, for: indexPath)
    }
    
    return cell
  }
  
  
}

extension AddVariantTableViewCell: AddNewSizeVariantDelegate {
  
  func addNewSizeTapped(from cell: AddNewSizeVariantTableViewCell) {
    let lastIndex = sizeVariants.count - 1
    if let lastCell = sizeVariantTableView.cellForRow(at: IndexPath(row: lastIndex, section: 0)) as? AddNewSizeVariantTableViewCell {
      
      let error = lastCell.validateFieldsWithErrors(isWomenCategory: isWomenIsSelected)
      if !error.isEmpty {
        CommonUtils.showToast(message: error)
        return
      }
      var variant = sizeVariants[lastIndex]
      variant.sizeId = lastCell.selectedSizeId
      variant.bust = lastCell.bustTF.text ?? ""
      variant.waist = lastCell.waistTF.text ?? ""
      variant.hip = lastCell.hipTF.text ?? ""
      variant.shoulder = lastCell.shoulderTF.text ?? ""
      variant.sleeveLength = lastCell.sleeveLengthTF.text ?? ""
      variant.length = lastCell.lengthTF.text ?? ""
      variant.totalStock = lastCell.totalStocksTF.text ?? ""
      variant.sku = lastCell.skuLimitTF.text ?? ""
      variant.actualPrice = lastCell.actualPriceTF.text ?? ""
      variant.finalPrice = lastCell.finalPriceTF.text ?? ""
      variant.discountValue = lastCell.discountPriceTF.text ?? ""
      variant.discountTypeIsPercentage = lastCell.discountTypeisPercentage
      sizeVariants[lastIndex] = variant
    }
    let newSpec = SizeVariant()
    sizeVariants.append(newSpec)
    let newIndexPath = IndexPath(row: sizeVariants.count - 1, section: 0)
    sizeVariantTableView.performBatchUpdates({
      sizeVariantTableView.insertRows(at: [newIndexPath], with: .automatic)
    }) { _ in
      self.updateTableViewHeight()
      self.sizeVariantTableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
    }
    self.notifyParentIfNeeded()
  }
  
  private func notifyParentIfNeeded() {
          // Create a temporary Variant object to send
          var currentVariant = Variant()
          currentVariant.sizeVariants = self.sizeVariants
          currentVariant.colorId = self.selectedColorId
          currentVariant.images = self.images
          currentVariant.imageURLs = self.imageURLs

          // Option 1: Only sizeVariants
          onSizeVariantsChanged?(self.sizeVariants)

          // Option 2: Full variant (RECOMMENDED)
          onVariantUpdated?(currentVariant)
      }
  
  func removeSizeTapped(from cell: AddNewSizeVariantTableViewCell) {
    guard let indexPath = sizeVariantTableView.indexPath(for: cell),
          sizeVariants.count > 1 else { return }
    
    sizeVariants.remove(at: indexPath.row)
    updateTableViewHeight()
  }
}

extension AddVariantTableViewCell {
  
  func validateFieldsWithErrors() -> String {
    
    func isEmpty(_ text: String?) -> Bool {
      return text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
    }
    
    if isEmpty(imageURLs.first) { return "Please upload image"}
    if isEmpty(colorTF.text) { return "Please select colour" }
    for (index, _) in sizeVariants.enumerated() {
      let indexPath = IndexPath(row: index, section: 0)
      guard let sizeCell = sizeVariantTableView.cellForRow(at: indexPath) as? AddNewSizeVariantTableViewCell else {
        continue
      }
      
      let error = sizeCell.validateFieldsWithErrors(isWomenCategory: isWomenIsSelected)
      if !error.isEmpty { return error }
      
      sizeCell.saveToModel()              // <--- Save cell data
      sizeVariants[index] = sizeCell.sizeVariant
    }
    
    return ""
  }
  
}
