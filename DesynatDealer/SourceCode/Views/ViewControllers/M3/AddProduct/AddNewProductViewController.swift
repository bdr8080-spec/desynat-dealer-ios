//
//  AddNewProductViewController.swift
//  DesynatDealer
//
//  Created by fluper on 20/11/25.
//

import UIKit
import SDWebImage

class AddNewProductViewController: UIViewController {
  
  @IBOutlet weak var cancelView: CustomView!
  @IBOutlet weak var varaintTableViewHeightConstriant: NSLayoutConstraint!
  @IBOutlet weak var addSpecificationButtonOutlet: UIButton!
  @IBOutlet weak var specificationTableViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var specificationTableView: UITableView! {
    didSet {
      specificationTableView.registerCellFromNib(cellID: "AddSpecificationTableViewCell")
    }
  }
  
  @IBOutlet weak var variantTableView: UITableView! {
    didSet {
      variantTableView.registerCellFromNib(cellID: "AddVariantTableViewCell")
    }
  }
  
  @IBOutlet weak var categoriesCollectionView: UICollectionView! {
    didSet {
      categoriesCollectionView.registerCellFromNib(cellID: "CategoriesSectionCollectionViewCell")
    }
  }
  
  @IBOutlet weak var subCatgeoryTF: UITextField!
  @IBOutlet weak var selectedBrandTF: UITextField!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var otherBrandEnglishTF: UITextField!
  @IBOutlet weak var otherBrandArabicTF: UITextField!
  @IBOutlet weak var producNameEngTF: UITextField!
  @IBOutlet weak var productNameArabicTF: UITextField!
  @IBOutlet weak var descriptionEngTextView: UITextView!
  @IBOutlet weak var descriptionArabicTextView: UITextView!
  @IBOutlet weak var minCartQuantityTF: UITextField!
  @IBOutlet weak var maxCartQuantityTF: UITextField!
  @IBOutlet weak var totalDaysReturningTF: UITextField!
  @IBOutlet weak var yesproductReturnButton: UIButton!
  @IBOutlet weak var noproductReturnButton: UIButton!
  @IBOutlet weak var returnDayTF: UITextField!
  @IBOutlet weak var yesProductExchangeableButton: UIButton!
  @IBOutlet weak var noProductExchangeableButton: UIButton!
  @IBOutlet weak var exchangableTF: UITextField!
  @IBOutlet weak var yesRatingAllowed: UIButton!
  @IBOutlet weak var noRatingAllowed: UIButton!
  @IBOutlet weak var yesAffiliatedProduct: UIButton!
  @IBOutlet weak var noAffiliatedProduct: UIButton!
  @IBOutlet weak var yesCustomize: UIButton!
  @IBOutlet weak var noCustomize: UIButton!
  @IBOutlet weak var yesREadyToShip: UIButton!
  @IBOutlet weak var noREadyToShip: UIButton!
  @IBOutlet weak var yesCashOnDelivery: UIButton!
  @IBOutlet weak var noCashOnDelivery: UIButton!
  @IBOutlet weak var sizeChartImageView: CustomImageView!
  
  var comingReason: ComingReasonAtAddToProduct = .forAddingProduct
  var specifications: [Spefication] = [Spefication()]
  var variantArray: [Variant] = [Variant()]
  private lazy var viewModel = AddNewProductViewModel(hostVC: self)
  var selectedCategoriesSection: Int? = -1 {
    didSet {
      if selectedCategoriesSection == 2 {
        isWomenCategory = true
      } else {
        isWomenCategory = false
      }
    }
  }
  var selectedSubCategoriesId: Int? = -1
  var selectedBrandId: Int? = -1
  var selectedSizeChartImageUrl: String? = ""
  var isWomenCategory: Bool = false {
    didSet {
      variantTableView.reloadData()
    }
  }
  
  var isProductReturnable = true {
      didSet {
          updateRadioButtons(selected: isProductReturnable, yesButton: yesproductReturnButton, noButton: noproductReturnButton)
      }
  }
  
  var isProductExchangable = true {
      didSet {
          updateRadioButtons(selected: isProductExchangable, yesButton: yesProductExchangeableButton, noButton: noProductExchangeableButton)
      }
  }
  
  var isRatingAllowed = true {
      didSet {
          updateRadioButtons(selected: isRatingAllowed, yesButton: yesRatingAllowed, noButton: noRatingAllowed)
      }
  }
  
  var isAffiliatedAllowed = true {
      didSet {
          updateRadioButtons(selected: isAffiliatedAllowed, yesButton: yesAffiliatedProduct, noButton: noAffiliatedProduct)
      }
  }
  
  var isCustomizationAllowed = true {
      didSet {
          updateRadioButtons(selected: isCustomizationAllowed, yesButton: yesCustomize, noButton: noCustomize)
      }
  }
  
  var isReadyToShip = true {
      didSet {
          updateRadioButtons(selected: isReadyToShip, yesButton: yesREadyToShip, noButton: noREadyToShip)
      }
  }
  
  var isCashOnDeliveryAllowed = true {
      didSet {
          updateRadioButtons(selected: isCashOnDeliveryAllowed, yesButton: yesCashOnDelivery, noButton: noCashOnDelivery)
      }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.getCategoriesListApi()
    viewModel.getBrandListApi()
    viewModel.getColoursListApi()
    viewModel.getSizeListApi()
    switch comingReason {
    case .forAddingProduct:
      cancelView.isHidden = true
      titleLabel.text = "Add new product"
    case .forEditProduct:
      cancelView.isHidden = false
      titleLabel.text = "Edit product"
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    updateSpecificationTableHeight()
    updateVariantTableHeight()
  }
  
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func addSpecificationsDidTapped(_ sender: Any) {
    let lastRow = specifications.count - 1
    let lastVariant = specifications[lastRow]
    if let lastCell = specificationTableView.cellForRow(at: IndexPath(row: lastRow, section: 0)) as? AddSpecificationTableViewCell {
        let errors = lastCell.validateSpecificationFields()
        if !errors.isEmpty {
          showAlert(msg: errors)
            return
        }
    } else {
      if lastVariant.product_spe_ar.isEmpty || lastVariant.product_spe_en.isEmpty || lastVariant.product_spe_feature_ar.isEmpty || lastVariant.product_spe_feature_en.isEmpty {
            showAlert(msg: "Please fill all required fields of the current spefication before adding a new one")
            return
        }
    }
    let newVariant = Spefication()
    specifications.append(newVariant)
    specificationTableView.reloadData()
    updateSpecificationTableHeight()
  }
  
  @IBAction func addVariantDidTapped(_ sender: Any) {
    let lastRow = variantArray.count - 1
        let lastVariant = variantArray[lastRow]
        if let lastCell = variantTableView.cellForRow(at: IndexPath(row: lastRow, section: 0)) as? AddVariantTableViewCell {
            let errors = lastCell.validateFieldsWithErrors(isWomenCategory: isWomenCategory)
            if !errors.isEmpty {
              showAlert(msg: errors)
                return
            }
        } else {
            if lastVariant.sizeId == nil || lastVariant.colorId == nil || lastVariant.totalStock.isEmpty || lastVariant.sku.isEmpty {
                showAlert(msg: "Please fill all required fields of the current variant before adding a new one")
                return
            }
        }
        let newVariant = Variant()
        variantArray.append(newVariant)
        variantTableView.reloadData()
        updateVariantTableHeight()
  }
  
  @IBAction func subCatgeoryAction(_ sender: UIButton) {
    let subCategoryNames = viewModel.subcategoriesList.map { subcategories -> String in
      let list = subcategories.nameEnglish ?? ""
      return "\(list)"
    }
    kSharedAppDelegate.dropDown(dataSource: subCategoryNames, anchorView: sender) { index, item in
      let selectedsubCategory = self.viewModel.subcategoriesList[index]
      self.subCatgeoryTF.text = selectedsubCategory.nameEnglish ?? ""
      self.selectedSubCategoriesId = selectedsubCategory.id
    }
  }
  
  @IBAction func brandListAction(_ sender: UIButton) {
    let brandNames = viewModel.brandsList.map { brands -> String in
      let list = brands.nameEnglish ?? ""
      return "\(list)"
    }
    kSharedAppDelegate.dropDown(dataSource: brandNames, anchorView: sender) { index, item in
      let selectedsubCategory = self.viewModel.brandsList[index]
      self.selectedBrandTF.text = selectedsubCategory.nameEnglish ?? ""
      self.selectedBrandId = selectedsubCategory.id
    }
  }
  
  @IBAction func addProductDidTapepd(_ sender: Any) {
    if viewModel.validFields() {
      viewModel.addProductApi()
    }
  }
  
  @IBAction func productReturnableAction(_ sender: Any) {
    isProductReturnable.toggle()
  }
  
  @IBAction func productExcahngableAction(_ sender: Any) {
    isProductExchangable.toggle()
  }
  
  @IBAction func ratingAllowedAction(_ sender: Any) {
    isRatingAllowed.toggle()
  }
  
  @IBAction func affiliatedProductAction(_ sender: Any) {
    isAffiliatedAllowed.toggle()
  }
  
  @IBAction func customizeAction(_ sender: Any) {
    isCustomizationAllowed.toggle()
  }
  
  @IBAction func readyToShipAction(_ sender: Any) {
    isReadyToShip.toggle()
  }
  
  @IBAction func cashOnDeliveryAction(_ sender: Any) {
    isCashOnDeliveryAllowed.toggle()
  }
  
  @IBAction func uploadSizeChartDidTapped(_ sender: Any) {
    ImagePickerHelper.shared.showPickerController {  image , imageName in
        if let image = image {
            WebService.sharedInstance.uploadImage(withParams: image) { imageURL in
                self.selectedSizeChartImageUrl = imageURL.url ?? ""
                if let url = URL(string: imageURL.url ?? "") {
                    self.sizeChartImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    self.sizeChartImageView.sd_setImage(with: url,placeholderImage: UIImage(named: "user_ic"))
                }
            }
        }
    }
  }
  
  func updateSpecificationTableHeight() {
    specificationTableView.layoutIfNeeded()
    self.specificationTableViewHeightConstraint.constant = self.specificationTableView.contentSize.height + 20
  }
  
  func updateVariantTableHeight() {
    variantTableView.layoutIfNeeded()
    self.varaintTableViewHeightConstriant.constant = self.variantTableView.contentSize.height
  }
  
  private func updateRadioButtons(selected: Bool, yesButton: UIButton, noButton: UIButton) {
      let yesImageName = selected ? "radioSelected" : "radioUnselected"
      let noImageName = selected ? "radioUnselected" : "radioSelected"
      
      yesButton.setImage(UIImage(named: yesImageName), for: .normal)
      noButton.setImage(UIImage(named: noImageName), for: .normal)
  }
  
  // MARK: - Helper: Add New Specification
  func updateUIVisibility() {
    if specifications.count == 1 {
      addSpecificationButtonOutlet.isHidden = false
    } else {
      addSpecificationButtonOutlet.isHidden = true
    }
  }
  
  func prepareVariantData(isWomenCategory: Bool) -> [String: Any]? {
      var variant_image: [[String]] = []
      var color_id: [String] = []
      var size_id: [String] = []
      var bust: [String] = []
      var waist: [String] = []
      var hip: [String] = []
      var shoulder: [String] = []
      var sleeve_length: [String] = []
      var length: [String] = []
      var total_stock: [String] = []
      var sku: [String] = []
      var sku_threshold_value: [String] = []
      var actual_price: [String] = []
      var discount_type: [String] = []
      var discount_value: [String] = []
      var final_price: [String] = []
      
      for row in 0..<variantTableView.numberOfRows(inSection: 0) {
          guard let cell = variantTableView.cellForRow(at: IndexPath(row: row, section: 0)) as? AddVariantTableViewCell else { continue }
          
          // Get field errors
          let errors = cell.validateFieldsWithErrors(isWomenCategory: isWomenCategory)
          if !errors.isEmpty {
            showAlert(msg: errors)
              variantTableView.scrollToRow(at: IndexPath(row: row, section: 0), at: .middle, animated: true)
              return nil
          }
          
          // Collect images URLs (replace with actual uploaded URLs)
//          let imagesURLs = cell.images.compactMap { $0 != nil ? "uploaded_image_url_here" : nil }
        let imagesURLs = cell.imageURLs.compactMap { $0 }
          variant_image.append(imagesURLs)
          
          color_id.append("\(cell.selectedColorId ?? 0)")
          size_id.append("\(cell.selectedSizeId ?? 0)")
          
          if isWomenCategory {
              bust.append(cell.bsutTF.text ?? "")
              waist.append(cell.waistTF.text ?? "")
              hip.append(cell.hipTF.text ?? "")
              shoulder.append(cell.shouldTF.text ?? "")
              sleeve_length.append(cell.sleeveLengthTF.text ?? "")
              length.append(cell.lengthTF.text ?? "")
          }
          
          total_stock.append(cell.totalStocksTF.text ?? "")
          sku.append(cell.skuTF.text ?? "")
          sku_threshold_value.append(cell.skuThresholdTF.text ?? "")
          actual_price.append(cell.actualPriceTF.text ?? "")
          discount_type.append(cell.discountTypeisPercentage ? "1" : "2")
          discount_value.append(cell.discountPriceTF.text ?? "")
          final_price.append(cell.finalPriceTF.text ?? "")
      }
      
      return [
          "variant_image": variant_image,
          "color_id": color_id,
          "size_id": size_id,
          "bust": bust,
          "waist": waist,
          "hip": hip,
          "shoulder": shoulder,
          "sleeve_length": sleeve_length,
          "length": length,
          "total_stock": total_stock,
          "sku": sku,
          "sku_threshold_value": sku_threshold_value,
          "actual_price": actual_price,
          "discount_type": discount_type,
          "discount_value": discount_value,
          "final_price": final_price
      ]
  }
  
  func prepareSpecificationData() -> [String: Any]? {
      var product_spe_en: [String] = []
      var product_spe_feature_en: [String] = []
      var product_spe_ar: [String] = []
      var product_spe_feature_ar: [String] = []

      for row in 0..<specificationTableView.numberOfRows(inSection: 0) {
          guard let cell = specificationTableView.cellForRow(at: IndexPath(row: row, section: 0)) as? AddSpecificationTableViewCell else { continue }

          // Validate each cell
          let errors = cell.validateSpecificationFields()
          if !errors.isEmpty {
            showAlert(msg: errors)
              specificationTableView.scrollToRow(at: IndexPath(row: row, section: 0), at: .middle, animated: true)
              return nil
          }

          product_spe_en.append(cell.nameEngTF.text ?? "")
          product_spe_feature_en.append(cell.featuresEngTF.text ?? "")
          product_spe_ar.append(cell.nameARTF.text ?? "")
          product_spe_feature_ar.append(cell.featuresARTF.text ?? "")
      }

      return [
          "product_spe_en": product_spe_en,
          "product_spe_feature_en": product_spe_feature_en,
          "product_spe_ar": product_spe_ar,
          "product_spe_feature_ar": product_spe_feature_ar
      ]
  }

}

extension AddNewProductViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch tableView {
    case specificationTableView:
      return specifications.count
    case variantTableView:
      return variantArray.count
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch tableView {
    case specificationTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "AddSpecificationTableViewCell", for: indexPath) as! AddSpecificationTableViewCell
      cell.delegate = self
      if specifications.count == 1 {
        cell.addRemoveStackView.isHidden = true
      } else {
        cell.addRemoveStackView.isHidden = false
      }
      let isLastCell = indexPath.row == specifications.count - 1
      cell.addNewView.isHidden = !isLastCell
      return cell
    case variantTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "AddVariantTableViewCell", for: indexPath) as! AddVariantTableViewCell
      cell.delegate = self
      cell.isWomenIsSelected = self.isWomenCategory
      if indexPath.row == 0 {
        cell.priceView.backgroundColor = UIColor(named: "#FFF7EA")
        cell.headerView.isHidden = true
      } else {
        cell.headerView.isHidden = false
        cell.titleLabel.text = "Variant \(indexPath.row)"
        cell.priceView.backgroundColor = UIColor.white
      }
      cell.onSizeButtonTap = { [weak self, weak cell] in
          guard let self = self, let cell = cell else { return }
          self.showSizeDropdown(from: cell.sizeTF, in: cell)
      }
      cell.onColorButtonTap = { [weak self, weak cell] in
          guard let self = self, let cell = cell else { return }
          self.showColorDropdown(from: cell.colorTF, in: cell)
      }
      return cell
    default:
      return UITableViewCell()
    }
  }
  
//  private func showColorDropdown(from sender: UIView) {
//    let colorNames = viewModel.colorsList.map { $0.name ?? "" }
//    kSharedAppDelegate.dropDown(dataSource: colorNames, anchorView: sender) { [weak self] index, item in
//      guard let self = self else { return }
//      let selectedColor = self.viewModel.colorsList[index]
//      if let cell = sender.superview?.superview as? AddVariantTableViewCell {
//        cell.colorTF.text = selectedColor.name
//        let colorView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
//        colorView.backgroundColor = UIColor(hex: selectedColor.hexCode ?? "#000000")
//        colorView.layer.cornerRadius = 8
//        colorView.clipsToBounds = true
//        cell.colorTF.leftView = colorView
//        cell.colorTF.leftViewMode = .always
//        cell.selectedColorId = selectedColor.id
//      }
//    }
//  }
  
  private func showSizeDropdown(from textField: UITextField, in cell: AddVariantTableViewCell) {
      let sizesNames = viewModel.sizesList.map { $0.name ?? "" }
      kSharedAppDelegate.dropDown(dataSource: sizesNames, anchorView: textField) { [weak self] index, item in
          guard let self = self else { return }
          let selectedSize = self.viewModel.sizesList[index]
          cell.sizeTF.text = selectedSize.name
          cell.selectedSizeId = selectedSize.id
      }
  }
  
  private func showColorDropdown(from textField: UITextField, in cell: AddVariantTableViewCell) {
      let sizesNames = viewModel.colorsList.map { $0.name ?? "" }
      kSharedAppDelegate.dropDown(dataSource: sizesNames, anchorView: textField) { [weak self] index, item in
          guard let self = self else { return }
          let selectedSize = self.viewModel.colorsList[index]
          cell.colorTF.text = selectedSize.name
          cell.selectedColorId = selectedSize.id
      }
  }
  
}

extension AddNewProductViewController: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.categoriesList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesSectionCollectionViewCell", for: indexPath) as! CategoriesSectionCollectionViewCell
    let data = viewModel.categoriesList[indexPath.row]
    cell.titleLabel.text = data.name
    if selectedCategoriesSection == data.id {
      cell.slecedImageView.image = UIImage(named: "radioSelected")
    } else {
      cell.slecedImageView.image = UIImage(named: "radioUnselected")
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    selectedCategoriesSection = viewModel.categoriesList[indexPath.row].id
    categoriesCollectionView.reloadData()
    viewModel.getSubCategoriesListApi()
    subCatgeoryTF.text = ""
    selectedSubCategoriesId = -1
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (collectionView.frame.width - 0) / 3
    let height: CGFloat = 35
    return CGSize(width: width, height: height)
  }
  
}

extension AddNewProductViewController: AddSpecificationCellDelegate, AddVariantCellDelegate {
  
  func addImageTapped(from cell: AddVariantTableViewCell, at index: Int) {
      ImagePickerHelper.shared.showPickerController { [weak self] image, imageName in
          guard let self = self, let image = image else { return }

          WebService.sharedInstance.uploadImage(withParams: image) { imageURL in
              // Save actual image
              cell.images[index] = image
              
              // Save uploaded image URL
            cell.imageURLs[index] = imageURL.url
              
              // If last index → add placeholder
              if index == cell.images.count - 1 {
                  cell.images.append(nil)
                  cell.imageURLs.append(nil)
              }

              cell.imagesCollectionView.reloadData()
              cell.scrollToLastItem()
          }
      }
  }

  
  
  
  func removeVariantTapped(from cell: AddVariantTableViewCell) {
    guard let indexPath = variantTableView.indexPath(for: cell) else { return }
    variantArray.remove(at: indexPath.row)
    variantTableView.reloadData()
    updateVariantTableHeight()
  }
  
  func addSpecificationTapped(from cell: AddSpecificationTableViewCell) {

      guard let index = specificationTableView.indexPath(for: cell)?.row else { return }

      // Validate current cell
      let errors = cell.validateSpecificationFields()

      if !errors.isEmpty {
        showAlert(msg: errors)
          specificationTableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: true)
          return
      }

      // If valid → Add new empty specification
    let newVariant = Spefication()
    specifications.append(newVariant)
      specificationTableView.reloadData()
      updateSpecificationTableHeight()
  }

  
  func removeSpecificationTapped(from cell: AddSpecificationTableViewCell) {
    guard let indexPath = specificationTableView.indexPath(for: cell) else { return }
    specifications.remove(at: indexPath.row)
    specificationTableView.reloadData()
    updateSpecificationTableHeight()
    if specifications.count == 1 {
      addSpecificationButtonOutlet.isHidden = false
    }
  }
}

