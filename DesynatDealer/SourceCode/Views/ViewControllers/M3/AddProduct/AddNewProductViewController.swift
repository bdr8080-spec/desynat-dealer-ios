//
//  AddNewProductViewController.swift
//  DesynatDealer
//
//  Created by fluper on 20/11/25.
//

import UIKit
import SDWebImage

class AddNewProductViewController: UIViewController {
  
  @IBOutlet weak var exchagableDaysView: UIView!
  @IBOutlet weak var returningDaysView: UIView!
  @IBOutlet weak var otherStackView: UIStackView!
  @IBOutlet weak var addButtonLabel: UILabel!
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
  
  private lazy var viewModel = AddNewProductViewModel(hostVC: self)
  var comingReason: ComingReasonAtAddToProduct = .forAddingProduct
  var specifications: [Spefication] = [Spefication()]
  var variantArray: [Variant] = [Variant()]
  var productId: Int? = 0
  var selectedSubCategoriesId: Int? = -1
  var selectedBrandId: Int? = -1
  var selectedSizeChartImageUrl: String? = ""
  var isWomenCategory: Bool = false {
    didSet {
      variantTableView.reloadData()
    }
  }
  
  var selectedCategoriesSection: Int? = -1 {
    didSet {
      if selectedCategoriesSection == 2 {
        isWomenCategory = true
      } else {
        isWomenCategory = false
      }
    }
  }
  
  var isProductReturnable = true {
    didSet {
      updateRadioButtons(selected: isProductReturnable, yesButton: yesproductReturnButton, noButton: noproductReturnButton)
      returningDaysView.isHidden = !isProductReturnable
    }
  }
  
  var isProductExchangable = true {
    didSet {
      updateRadioButtons(selected: isProductExchangable, yesButton: yesProductExchangeableButton, noButton: noProductExchangeableButton)
      exchagableDaysView.isHidden = !isProductExchangable
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
    initialSetup()
    setupTextViewPlaceholder()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    DispatchQueue.main.async {
            self.updateSpecificationTableHeight()
            self.updateVariantTableHeight()
        }
  }
  
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func addSpecificationsDidTapped(_ sender: Any) {
//    let lastRow = specifications.count - 1
//    let lastVariant = specifications[lastRow]
//    if let lastCell = specificationTableView.cellForRow(at: IndexPath(row: lastRow, section: 0)) as? AddSpecificationTableViewCell {
//      let errors = lastCell.validateSpecificationFields()
//      if !errors.isEmpty {
//        showAlert(msg: errors)
//        return
//      }
//    } else {
//      if lastVariant.product_spe_ar.isEmpty || lastVariant.product_spe_en.isEmpty || lastVariant.product_spe_feature_ar.isEmpty || lastVariant.product_spe_feature_en.isEmpty {
//        showAlert(msg: "Please fill all required fields of the current spefication before adding a new one")
//        return
//      }
//    }
//    let newVariant = Spefication()
//    specifications.append(newVariant)
//    specificationTableView.reloadData()
//    updateSpecificationTableHeight()
    
    let lastIndex = specifications.count - 1
        if let lastCell = specificationTableView.cellForRow(at: IndexPath(row: lastIndex, section: 0)) as? AddSpecificationTableViewCell {
            let errors = lastCell.validateSpecificationFields()
            if !errors.isEmpty {
                showAlert(msg: errors)
                return
            }
            
            // Save data from UI to model
          var spec = specifications[lastIndex]
            spec.product_spe_en = lastCell.nameEngTF.text ?? ""
            spec.product_spe_feature_en = lastCell.featuresEngTF.text ?? ""
            spec.product_spe_ar = lastCell.nameARTF.text ?? ""
            spec.product_spe_feature_ar = lastCell.featuresARTF.text ?? ""
            specifications[lastIndex] = spec
        }

        // Add new empty spec
        let newSpec = Spefication()
        specifications.append(newSpec)

        // Insert new row instead of reloadData()
        let newIndexPath = IndexPath(row: specifications.count - 1, section: 0)
        
        specificationTableView.performBatchUpdates({
            specificationTableView.insertRows(at: [newIndexPath], with: .automatic)
        }) { _ in
            self.updateSpecificationTableHeight()
            self.specificationTableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
        
        // Hide main add button if needed
        addSpecificationButtonOutlet.isHidden = true
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
      if lastVariant.sizeId == nil || lastVariant.colorId == nil ||
          lastVariant.totalStock.isEmpty || lastVariant.sku.isEmpty {
        showAlert(msg: "Please fill all required fields of the current variant before adding a new one")
        return
      }
    }
    let newVariant = Variant()
    variantArray.append(newVariant)
    let newIndexPath = IndexPath(row: variantArray.count - 1, section: 0)
    variantTableView.performBatchUpdates({
      variantTableView.insertRows(at: [newIndexPath], with: .automatic)
    }, completion: { _ in
      self.updateVariantTableHeight()
      self.variantTableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
    })
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
      if (selectedsubCategory.nameEnglish?.lowercased() == "other") {
        self.otherStackView.isHidden = false
      } else {
        self.otherStackView.isHidden = true
      }
    }
  }
  
  @IBAction func addProductDidTapepd(_ sender: Any) {
    if viewModel.validFields() {
      switch comingReason {
      case .forEditProduct:
        viewModel.editProductApi()
      case .forAddingProduct:
        viewModel.addProductApi()
      }
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
  
  @IBAction func deleteDidTapped(_ sender: Any) {
    self.showConfirmationAlert(msg: "Are you sure you want to delete this product?"){ [weak self] in
      guard let self = self else { return }
      viewModel.deleteProductDetailsService()
    }
  }
  
  private func refreshVariantCellDisplays() {
      guard !viewModel.colorsList.isEmpty || !viewModel.sizesList.isEmpty else { return }
      
      for cell in variantTableView.visibleCells {
          if let cell = cell as? AddVariantTableViewCell {
            cell.updateColorAndSizeDisplay(colorsList: viewModel.colorsList, sizesList: viewModel.sizesList)
          }
      }
  }
  
  private func initialSetup() {
    switch comingReason {
    case .forAddingProduct:
      cancelView.isHidden = true
      titleLabel.text = "Add new product"
      addButtonLabel.text = "Add Product"
    case .forEditProduct:
      cancelView.isHidden = false
      titleLabel.text = "Edit product"
      addButtonLabel.text = "Edit Product"
      viewModel.getProductDetailsService()
      refreshVariantCellDisplays()
    }
    let textFields: [UITextField] = [
      otherBrandEnglishTF, otherBrandArabicTF, producNameEngTF, productNameArabicTF, minCartQuantityTF, maxCartQuantityTF, returnDayTF,
      exchangableTF]
    
    for tf in textFields {
      tf.delegate = self
    }
    descriptionEngTextView.delegate = self
    descriptionArabicTextView.delegate = self
  }
  
//  func updateSpecificationTableHeight() {
//    specificationTableView.layoutIfNeeded()
//    self.specificationTableViewHeightConstraint.constant = self.specificationTableView.contentSize.height + 20
//  }
  
  func updateSpecificationTableHeight() {
      // Ensure layout pass
      specificationTableView.layoutIfNeeded()
      
      var height = specificationTableView.contentSize.height
      
      // Add padding if needed
      height += 20
      
      // Minimum height to avoid collapse
      if height < 100 {
          height = 150
      }
      
      // Animate constraint update
      UIView.animate(withDuration: 0.1) {
          self.specificationTableViewHeightConstraint.constant = height
          self.view.layoutIfNeeded()
      }
  }
  
  func updateVariantTableHeight() {
      // Force full layout pass
      variantTableView.setNeedsLayout()
      variantTableView.layoutIfNeeded()
      
      // Get accurate content size
      let height = variantTableView.contentSize.height
      
      // Add safe padding (optional, but recommended)
      let finalHeight = height + 10
      
      // Prevent collapse when empty or too small
      let minimumHeight: CGFloat = 200
      
      // Animate smooth height change
      UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
          self.varaintTableViewHeightConstriant.constant = max(finalHeight, minimumHeight)
          self.view.layoutIfNeeded()
      }, completion: nil)
  }
  
//  func updateVariantTableHeight() {
//    variantTableView.layoutIfNeeded()
//    self.varaintTableViewHeightConstriant.constant = self.variantTableView.contentSize.height
//  }
  
  private func updateRadioButtons(selected: Bool, yesButton: UIButton, noButton: UIButton) {
    let yesImageName = selected ? "radioSelected" : "radioUnselected"
    let noImageName = selected ? "radioUnselected" : "radioSelected"
    
    yesButton.setImage(UIImage(named: yesImageName), for: .normal)
    noButton.setImage(UIImage(named: noImageName), for: .normal)
  }
  
  func setupTextViewPlaceholder() {
      descriptionEngTextView.text = "Write Here"
      descriptionEngTextView.textColor = .lightGray
      descriptionEngTextView.delegate = self

      descriptionArabicTextView.text = "Write Here"
      descriptionArabicTextView.textColor = .lightGray
      descriptionArabicTextView.delegate = self
  }

  
  // MARK: - Helper: Add New Specification
//  func updateUIVisibility() {
//    if specifications.count == 1 {
//      addSpecificationButtonOutlet.isHidden = false
//    } else {
//      addSpecificationButtonOutlet.isHidden = true
//    }
//  }
  
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
//    var sku_threshold_value: [String] = []
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
//      sku_threshold_value.append(cell.skuThresholdTF.text ?? "")
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
//      "sku_threshold_value": sku_threshold_value,
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
  
  func prefillProductDetails(_ data: ProductsList) {
    selectedCategoriesSection = Int(data.categoryID ?? "0")
    categoriesCollectionView.reloadData()
    
    selectedSubCategoriesId = Int(data.subcategoryID ?? "0")
    subCatgeoryTF.text = data.category?.description
    
    selectedBrandId = Int(data.brandID ?? "0")
    selectedBrandTF.text = data.brand?.nameEnglish
    
    if (data.brand?.nameEnglish?.lowercased() == "other") {
      self.otherStackView.isHidden = false
    } else {
      self.otherStackView.isHidden = true
    }
    
    otherBrandEnglishTF.text = data.otherEn
    otherBrandArabicTF.text = data.otherAr
    producNameEngTF.text = data.productNameEn
    productNameArabicTF.text = data.productNameAr
    descriptionEngTextView.text = data.descriptionEn
    descriptionArabicTextView.text = data.descriptionAr
    descriptionEngTextView.placeholderTextView = ""
    descriptionArabicTextView.placeholderTextView = ""
    
    minCartQuantityTF.text = data.minCardQuantity
    maxCartQuantityTF.text = data.maxCardQuantity
    totalDaysReturningTF.text = data.returnDays
    exchangableTF.text = data.exchangableDays
    addSpecificationButtonOutlet.isHidden = true
    isProductReturnable = (data.productReturn == "1")
    isProductExchangable = (data.productExchangable == "1")
    isRatingAllowed = (data.reviewRating == "1")
    isAffiliatedAllowed = (data.affiliatedProduct == "1")
    isCustomizationAllowed = (data.customizedProduct == "1")
    isReadyToShip = (data.readyToShip == "1")
    isCashOnDeliveryAllowed = (data.cashOnDelivery == "1")
    
    selectedSizeChartImageUrl = data.uploadSizeChart
    if let url = URL(string: data.uploadSizeChart ?? "") {
      sizeChartImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "user_ic"))
    }
    
    specifications.removeAll()
    let specification = data.productSpecifications ?? []
    for item in specification {
      var spec = Spefication()
      spec.product_spe_en = item.nameEn ?? ""
      spec.product_spe_ar = item.nameAr ?? ""
      spec.product_spe_feature_en = item.featureEn ?? ""
      spec.product_spe_feature_ar = item.featureAr ?? ""
      specifications.append(spec)
    }
    specificationTableView.reloadData()
    updateSpecificationTableHeight()
    
    variantArray.removeAll()
    
    let variants = data.productVariants ?? []
    for v in variants {
      var variant = Variant()
      variant.colorId = v.colorID?.toInt
      variant.sizeId = v.sizeID?.toInt //
      variant.totalStock = v.totalStock ?? ""
      variant.sku = v.sku ?? ""
      variant.skuThreshold = v.skuThresholdValue ?? ""
      variant.actualPrice = v.actualPrice ?? ""
      variant.discountTypeIsPercentage = (v.discountType == "1")
      variant.discountValue = v.discountValue ?? ""
      variant.finalPrice = v.finalPrice ?? ""
      
      variant.bust = v.bust ?? ""
      variant.hip = v.hip ?? ""
      variant.waist = v.waist ?? ""
      variant.length = v.length ?? ""
      variant.shoulder = v.shoulder ?? ""
      variant.sleeveLength = v.sleeveLength ?? ""
      
        if let imageStrings = v.variantImage, !imageStrings.isEmpty {
            variant.imageURLs = imageStrings.compactMap { $0 }  // removes any nil if backend sends them
            variant.images = Array(repeating: UIImage(), count: imageStrings.count) // temp placeholder
        } else {
            variant.imageURLs = []
            variant.images = []
        }
      variantArray.append(variant)
    }
    variantTableView.reloadData()
    updateVariantTableHeight()
    viewModel.getSubCategoriesListApi()
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
      let spec = specifications[indexPath.row]
      cell.nameEngTF.text = spec.product_spe_en
      cell.featuresEngTF.text = spec.product_spe_feature_en
      cell.nameARTF.text = spec.product_spe_ar
      cell.featuresARTF.text = spec.product_spe_feature_ar
      
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
      let variant = variantArray[indexPath.row]
      cell.selectedSizeId = variant.sizeId
      cell.selectedColorId = variant.colorId
//      if let sizeId = variant.sizeId,
//         let size = viewModel.sizesList.first(where: { $0.id == sizeId }) {
//        cell.sizeTF.text = size.name
//      }
      
      if !viewModel.colorsList.isEmpty {
        cell.updateColorAndSizeDisplay(colorsList: viewModel.colorsList, sizesList: viewModel.sizesList)
      } else {
          // If lists not loaded yet, do nothing — will be updated later
          cell.colorTF.text = ""
          cell.sizeTF.text = ""
      }
      
      // In cellForRowAt — after setting IDs
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
          if let color = self.viewModel.colorsList.first(where: { $0.id == variant.colorId }) {
              cell.colorTF.text = color.name
          }
          if let size = self.viewModel.sizesList.first(where: { $0.id == variant.sizeId }) {
              cell.sizeTF.text = size.name
          }
      }
      
//      if let colorId = variant.colorId,
//         let color = viewModel.colorsList.first(where: { $0.id == colorId }) {
//        cell.colorTF.text = color.name
//      } else {
//        print("Color not found for id:", variant.colorId ?? -1)
//      }
      cell.totalStocksTF.text = variant.totalStock
      cell.skuTF.text = variant.sku
//      cell.skuThresholdTF.text = variant.skuThreshold
      cell.actualPriceTF.text = variant.actualPrice
      cell.discountPriceTF.text = variant.discountValue
      cell.finalPriceTF.text = variant.finalPrice
      cell.discountTypeisPercentage = variant.discountTypeIsPercentage
      
      // Women's measurements
      cell.bsutTF.text = variant.bust
      cell.waistTF.text = variant.waist
      cell.hipTF.text = variant.hip
      cell.shouldTF.text = variant.shoulder
      cell.sleeveLengthTF.text = variant.sleeveLength
      cell.lengthTF.text = variant.length
      
        // Set only real images and URLs (no nil, no placeholder)
        cell.images = variant.images         // [UIImage]
        cell.imageURLs = variant.imageURLs  // [String]

        // Load existing images from URLs (only when editing)
        for (index, urlString) in cell.imageURLs.enumerated() {
            guard let url = URL(string: urlString) else { continue }
            
            SDWebImageManager.shared.loadImage(
                with: url,
                options: [.highPriority, .retryFailed],
                progress: nil
            ) { [weak cell] (image, _, error, _, _, _) in
                guard let image = image,
                      let cell = cell,
                      index < cell.images.count else { return }
                
                cell.images[index] = image
                
                DispatchQueue.main.async {
                    cell.reloadImageItem(at: index)
                }
            }
        }

        // Final safe refresh to ensure everything is displayed
        DispatchQueue.main.async {
            cell.imagesCollectionView.reloadData()
        }
      
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
    variantTableView.reloadData()
    updateVariantTableHeight()
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (collectionView.frame.width - 0) / 3
    let height: CGFloat = 35
    return CGSize(width: width, height: height)
  }
  
}

extension AddNewProductViewController: AddSpecificationCellDelegate, AddVariantCellDelegate {
  
    func addImageTapped(from cell: AddVariantTableViewCell, at index: Int) {
        ImagePickerHelper.shared.showPickerController { [weak cell] image, imageName in
            guard let image = image, let cell = cell else { return }
            
            WebService.sharedInstance.uploadImage(withParams: image) { imageURL in
                DispatchQueue.main.async {
                    // Insert new image at the end of real images
                    let insertIndex = cell.images.count
                    cell.images.append(image)
                    cell.imageURLs.append(imageURL.url ?? "")
                    
                    // Reload only the new item (index 1-based)
                    let newItemIndexPath = IndexPath(item: insertIndex + 1, section: 0) // +1 because 0 is placeholder
                    cell.imagesCollectionView.performBatchUpdates({
                        cell.imagesCollectionView.insertItems(at: [newItemIndexPath])
                    }, completion: nil)
                    
                    // FOR DISABLE THE SCROLLING AFTER UPLAODING IMAGE
                    cell.scrollToLastItem()
                }
            }
        }
    }
  
  func removeVariantTapped(from cell: AddVariantTableViewCell) {
    guard let indexPath = variantTableView.indexPath(for: cell) else { return }
    
    variantArray.remove(at: indexPath.row)
    
    variantTableView.performBatchUpdates({
      variantTableView.deleteRows(at: [indexPath], with: .automatic)
    }, completion: { _ in
      self.updateVariantTableHeight()
      if self.variantArray.isEmpty {
        self.variantArray.append(Variant())
        let newIndexPath = IndexPath(row: 0, section: 0)
        self.variantTableView.insertRows(at: [newIndexPath], with: .automatic)
        self.updateVariantTableHeight()
      }
    })
  }
  
//  func addSpecificationTapped(from cell: AddSpecificationTableViewCell) {
//    guard let index = specificationTableView.indexPath(for: cell)?.row else { return }
//    let errors = cell.validateSpecificationFields()
//    
//    if !errors.isEmpty {
//      showAlert(msg: errors)
//      specificationTableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: true)
//      return
//    }
//    let newVariant = Spefication()
//    specifications.append(newVariant)
//    specificationTableView.reloadData()
//    updateSpecificationTableHeight()
//  }
  
  func addSpecificationTapped(from cell: AddSpecificationTableViewCell) {
      guard let indexPath = specificationTableView.indexPath(for: cell) else { return }
      
      // Validate current cell
      let errors = cell.validateSpecificationFields()
      if !errors.isEmpty {
          showAlert(msg: errors)
          specificationTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
          return
      }

      // Save current cell data to model
    var currentSpec = specifications[indexPath.row]
      currentSpec.product_spe_en = cell.nameEngTF.text ?? ""
      currentSpec.product_spe_feature_en = cell.featuresEngTF.text ?? ""
      currentSpec.product_spe_ar = cell.nameARTF.text ?? ""
      currentSpec.product_spe_feature_ar = cell.featuresARTF.text ?? ""
      specifications[indexPath.row] = currentSpec

      // Add new one
      let newSpec = Spefication()
      specifications.append(newSpec)
      
      let newIndexPath = IndexPath(row: specifications.count - 1, section: 0)
      
      specificationTableView.performBatchUpdates({
          specificationTableView.insertRows(at: [newIndexPath], with: .automatic)
      }) { _ in
          self.updateSpecificationTableHeight()
          self.specificationTableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
      }
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
  
//  func removeSpecificationTapped(from cell: AddSpecificationTableViewCell) {
//      guard let indexPath = specificationTableView.indexPath(for: cell) else { return }
//      
//      specifications.remove(at: indexPath.row)
//      
//      specificationTableView.performBatchUpdates({
//          specificationTableView.deleteRows(at: [indexPath], with: .automatic)
//      }) { _ in
//          self.updateSpecificationTableHeight()
//          
//          if self.specifications.isEmpty {
//              self.specifications.append(Spefication())
//              self.specificationTableView.reloadData()
//              self.updateSpecificationTableHeight()
//          }
//          
//          self.addSpecificationButtonOutlet.isHidden = self.specifications.count > 1
//      }
//  }
}

extension AddNewProductViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        let currentText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        // Allow deleting/backspace
        if string.isEmpty { return true }

        // Prevent leading space
        if currentText.hasPrefix(" ") { return false }

        let fieldsAllowingSpaces: [UITextField] = [
            otherBrandEnglishTF,
            otherBrandArabicTF,
            producNameEngTF,
            productNameArabicTF,
        ]
        
        let numericFields = [
            minCartQuantityTF,
            maxCartQuantityTF,
            totalDaysReturningTF,
            exchangableTF
        ]
        
        // Handle numeric fields
        if numericFields.contains(textField) {

            // Block spaces
            if string == " " { return false }

            // Allow only digits
            let allowedSet = CharacterSet.decimalDigits
            if string.rangeOfCharacter(from: allowedSet.inverted) != nil {
                return false
            }

            // Block leading zero
            if currentText.count == 1 && currentText == "0" {
                return false
            }
          
          if (textField == minCartQuantityTF || textField == maxCartQuantityTF) && currentText.count > 6 {
                         return false
                     }

            // Real-time min/max validation
            if textField == maxCartQuantityTF {
                let minVal = Int(minCartQuantityTF.text ?? "") ?? 0
                let maxVal = Int(currentText) ?? 0
//                if maxVal < minVal {
//                    CommonUtils.showToast(message: "Max quantity cannot be less than Min quantity")
//                    return true
//                }
            } else if textField == minCartQuantityTF {
                let maxVal = Int(maxCartQuantityTF.text ?? "") ?? 0
                let minVal = Int(currentText) ?? 0
                if minVal > maxVal && maxVal != 0 {
                    CommonUtils.showToast(message: "Min quantity cannot be greater than Max quantity")
                    return false
                }
            }

            return true
        }

        // Arabic text validation
        if textField == otherBrandArabicTF || textField == productNameArabicTF {
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

        // English text validation
        if textField == otherBrandEnglishTF || textField == producNameEngTF {
            let allowedSet = CharacterSet.letters.union(.whitespaces)
            for scalar in string.unicodeScalars {
                if !allowedSet.contains(scalar) {
                    return false
                }
            }
            return true
        }

        // Block spaces for fields not allowing them
        if !fieldsAllowingSpaces.contains(textField) {
            if string.contains(" ") {
                return false
            }
        }

        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        validateMinMaxQuantity()
    }

  func validateMinMaxQuantity() {
          let minVal = Int(minCartQuantityTF.text ?? "") ?? 0
          let maxVal = Int(maxCartQuantityTF.text ?? "") ?? 0

          // Show toast only after user finishes editing
          if minVal >= maxVal && maxVal != 0 {
              CommonUtils.showToast(message: "Min Cart Quantity must be smaller than Max Cart Quantity")
          }
      }

}

extension AddNewProductViewController: UITextViewDelegate {
  
  func textViewDidBeginEditing(_ textView: UITextView) {
          // Remove placeholder when user starts typing
          if textView.textColor == .lightGray {
              textView.text = ""
              textView.textColor = .label // or .black depending on your design
          }
      }

      func textViewDidEndEditing(_ textView: UITextView) {
          // Restore placeholder if text is empty
          if textView.text.isEmpty {
              if textView == descriptionEngTextView {
                  textView.text = "Write Here"
              } else if textView == descriptionArabicTextView {
                  textView.text = "Write Here"
              }
              textView.textColor = .lightGray
          }
      }

  
  func textView(_ textView: UITextView,
                shouldChangeTextIn range: NSRange,
                replacementText text: String) -> Bool {
    let currentText = (textView.text as NSString?)?.replacingCharacters(in: range, with: text) ?? text
    if text.isEmpty { return true }
    if currentText.hasPrefix(" ") { return false }
    let fieldsAllowingSpaces: [UITextView] = [
      descriptionEngTextView,
      descriptionArabicTextView]
    if textView == descriptionArabicTextView {
      let allowedSet = CharacterSet(charactersIn: "\u{0600}"..."\u{06FF}")
        .union(CharacterSet(charactersIn: "\u{0750}"..."\u{077F}"))
        .union(CharacterSet(charactersIn: "\u{08A0}"..."\u{08FF}"))
        .union(.whitespaces)
      for scalar in text.unicodeScalars {
        if !allowedSet.contains(scalar) {
          CommonUtils.showToast(message: "Please switch to Arabic keyboard")
          return false
        }
      }
      return true
    }
    if textView == descriptionEngTextView {
      let allowedSet = CharacterSet.letters.union(.whitespaces)
      for scalar in text.unicodeScalars {
        if !allowedSet.contains(scalar) {
          return false
        }
      }
      return true
    }
    if !fieldsAllowingSpaces.contains(textView) {
      if text.contains(" ") {
        return false
      }
    }
    return true
  }
}

