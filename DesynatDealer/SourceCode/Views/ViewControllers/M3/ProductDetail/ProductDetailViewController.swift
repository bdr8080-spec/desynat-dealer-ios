//
//  ProductDetailViewController.swift
//  DesynatUser
//
//  Created by fluper on 18/11/25.
//

import UIKit

class ProductDetailViewController: UIViewController {
  
  @IBOutlet weak var womenStackView: UIStackView!
  @IBOutlet weak var lengthStackView: UIStackView!
  @IBOutlet weak var sleeveLengthStackView: UIStackView!
  @IBOutlet weak var womenDetailsView: CustomView!
  @IBOutlet weak var titlePageLabel: UILabel!
  @IBOutlet weak var cashOnDeliveryLabel: UILabel!
  @IBOutlet weak var readyToShipLabel: UILabel!
  @IBOutlet weak var customizableLabel: UILabel!
  @IBOutlet weak var affiliatedLabel: UILabel!
  @IBOutlet weak var ratingReviewALlowedLabel: UILabel!
  @IBOutlet weak var exchnageAllowedLAbel: UILabel!
  @IBOutlet weak var returnAllowedLAbel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var skuThresholderLabel: UILabel!
  @IBOutlet weak var skuLabel: UILabel!
  @IBOutlet weak var totalStocksLabel: UILabel!
  @IBOutlet weak var shoulderView: UIStackView!
  @IBOutlet weak var hipView: UIStackView!
  @IBOutlet weak var waistView: UIStackView!
  @IBOutlet weak var bustView: UIStackView!
  @IBOutlet weak var sleeveLenghtLabel: UILabel!
  @IBOutlet weak var lengthLabel: UILabel!
  @IBOutlet weak var waistLabel: UILabel!
  @IBOutlet weak var shoulderLabel: UILabel!
  @IBOutlet weak var hipLabel: UILabel!
  @IBOutlet weak var bustLabel: UILabel!
  @IBOutlet weak var actualPriceLAbel: CustomLabelFont!
  @IBOutlet weak var discountPriceALbel: UILabel!
  @IBOutlet weak var finalPriceLabel: UILabel!
  @IBOutlet weak var ratingCountLabel: UILabel!
  @IBOutlet weak var brandCategoryLabel: UILabel!
  @IBOutlet weak var descriptionLAbel: UILabel!
  @IBOutlet weak var addedOnLabel: UILabel!
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var totalBoughtsCountLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var statusButton: UIButton!
  @IBOutlet weak var ratingTableViewHeightConstriant: NSLayoutConstraint!
  @IBOutlet weak var specificationTableViewHieghtConstraint: NSLayoutConstraint!
  @IBOutlet weak var imagesPageController: UIPageControl!
  @IBOutlet weak var addToBagView: CustomView!
  @IBOutlet weak var productImageCollectionView: UICollectionView! {
    didSet {
      productImageCollectionView.registerCellFromNib(cellID: "ProductDetailImageCollectionViewCell")
    }
  }
  
  @IBOutlet weak var colorsCollectionView: UICollectionView! {
    didSet {
      colorsCollectionView.registerCellFromNib(cellID: "ProductColoursCollectionViewCell")
    }
  }
  
  @IBOutlet weak var sizeCollectionView: UICollectionView! {
    didSet {
      sizeCollectionView.registerCellFromNib(cellID: "SizeVariantCollectionViewCell")
    }
  }
  
  @IBOutlet weak var specificationTableView: UITableView! {
    didSet {
      specificationTableView.registerCellFromNib(cellID: "ListTableViewCell")
    }
  }
  
  @IBOutlet weak var ratingsTableView: UITableView! {
    didSet {
      ratingsTableView.registerCellFromNib(cellID: "ProductRatingTableViewCell")
    }
  }
  
  private var selectedColourIndex = 0
  private var selectedSizeIndex = 0
  private var speifcationArray = [""]
  var productId: Int = 0
  private lazy var viewModel = ProductDetailsViewModel(hostVC: self)
  var productVariants: [ProductVariant] = []
  var coloursList: [ColorsLisDataModel] = []
  var sizesList: [SizeListDataModel] = []
  private var selectedVariant: ProductVariant?
  private var sizeChartUrl :String? = ""
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.getProductDetailsService()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    DispatchQueue.main.async {
      self.specificationTableViewHieghtConstraint.constant = self.specificationTableView.contentSize.height
      self.ratingTableViewHeightConstriant.constant = self.ratingsTableView.contentSize.height
    }
  }
  
  
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  // MARK: - Page Control Tap Handling
  @IBAction func pageControlChanged(_ sender: UIPageControl) {
    let page = sender.currentPage
    let indexPath = IndexPath(item: page, section: 0)
    productImageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
  }
  
  @IBAction func editDidTapped(_ sender: Any) {
    let nextVC = AddNewProductViewController.instantiate(fromAppStoryboard: .Product)
    nextVC.comingReason = .forEditProduct
    nextVC.productId = productId
    self.navigationController?.pushViewController(nextVC, animated: true)
  }
  
  @IBAction func deleteDidTapped(_ sender: Any) {
    self.showConfirmationAlert(msg: "Are you sure you want to delete this product?"){ [weak self] in
      guard let self = self else { return }
      viewModel.deleteProductDetailsService()
    }
  }
  
  @IBAction func updateStatusDidTapped(_ sender: Any) {
    guard let user = viewModel.productDetails else { return }
    let newStatus = user.productActiveStatus == 1 ? 0 : 1
    let params: [String: Any] = ["product_id": user.id ?? 0]
    
    viewModel.updateActiveStatus(param: params) { [weak self] success in
      guard let self = self else { return }
      if success {
        // Update the actual object in viewModel
        self.viewModel.productDetails?.productActiveStatus = newStatus
        
        // Refresh UI
        if let updatedUser = self.viewModel.productDetails {
          self.configData(data: updatedUser)
          let message = newStatus == 1 ? "Product has been activated Successfully" : "Product has been Deactivated Successfully"
          CommonUtils.showToast(message: message)
        }
      }
    }
  }
  
  @IBAction func sizeGuideDidTapped(_ sender: Any) {
    let nextVC = SizeChartViewController.instantiate(fromAppStoryboard: .Product)
    nextVC.sizeChartUrl = sizeChartUrl
    self.navigationController?.present(nextVC, animated: true)
  }
  
  func configData(data: ProductsList) {
    // MARK: - Basic Product info
    //      titlePageLabel.text = data.brand?.nameEnglish ?? ""
    if data.brand?.nameEnglish == "Other" {
      productNameLabel.text = data.otherEn
      titlePageLabel.text = data.otherEn
    } else {
      productNameLabel.text = data.brand?.nameEnglish
      titlePageLabel.text = data.brand?.nameEnglish
    }
    
    descriptionLAbel.text = data.productNameEn ?? "-"
    descriptionLabel.text = data.descriptionEn ?? "-"
    addedOnLabel.text = "Added on - \(convertDate(data.createdAt ?? ""))"
    brandCategoryLabel.text = data.category?.name ?? ""//"\(data.brand?.nameEnglish ?? "")  (\(data.category?.name ?? ""))"
    ratingCountLabel.text = " (\(data.reviewRating ?? "0"))"
    sizeChartUrl = data.uploadSizeChart
    let categoryName = data.category?.name ?? "Women"
    if categoryName == "Women" {
      womenDetailsView.isHidden = false
      bustView.isHidden = false
      hipView.isHidden = false
      waistView.isHidden = false
      shoulderView.isHidden = false
      sleeveLengthStackView.isHidden = false
      lengthStackView.isHidden = false
      womenStackView.isHidden = false
    } else {
      womenDetailsView.isHidden = true
      bustView.isHidden = true
      hipView.isHidden = true
      waistView.isHidden = true
      shoulderView.isHidden = true
      sleeveLengthStackView.isHidden = true
      lengthStackView.isHidden = true
      womenStackView.isHidden = true
    }
    // Status
    if data.productActiveStatus == 1 {
      statusLabel.text = "Active"
      statusButton.setImage(UIImage(named: "toggle_on"), for: .normal)
    } else {
      statusLabel.text = "Inactive"
      statusButton.setImage(UIImage(named: "toggle_off"), for: .normal)
    }
    
    // MARK: - Switch Labels (YES / NO)
    cashOnDeliveryLabel.text = data.cashOnDelivery == "1" ? "Yes" : "No"
    readyToShipLabel.text = data.readyToShip == "1" ? "Yes" : "No"
    customizableLabel.text = data.customizedProduct == "1" ? "Yes" : "No"
    affiliatedLabel.text = data.affiliatedProduct == "1" ? "Yes" : "No"
    ratingReviewALlowedLabel.text = data.reviewRating == "1" ? "Yes" : "No"
    returnAllowedLAbel.text = data.productReturn == "1" ? "\(data.returnDays ?? "") days" : "No"
    exchnageAllowedLAbel.text = data.productExchangable == "1" ? "\(data.exchangableDays ?? "") days" : "No"
    
    // In configData
    productVariants = data.productVariants ?? []
    
    // Get unique colors
    //      var uniqueColorsDict: [Int: ColorsLisDataModel] = [:]
    //      for variant in productVariants {
    //          if let color = variant.color {
    //              uniqueColorsDict[color.id ?? 0] = color
    //          }
    //      }
    //      coloursList = Array(uniqueColorsDict.values)
    //      colorsCollectionView.reloadData()
    //
    //      // Default: first variant
    //      selectedVariant = productVariants.first
    //      selectedColourIndex = coloursList.firstIndex(where: { $0.id == selectedVariant?.color?.id }) ?? 0
    //
    //      // Update sizes based on selected variant
    //      sizesList = productVariants
    //          .filter { $0.color?.id == selectedVariant?.color?.id }
    //          .compactMap { $0.size }
    //      sizeCollectionView.reloadData()
    //
    //      updateVariantUI()
    
    var uniqueColorsDict: [Int: ColorsLisDataModel] = [:]
    for variant in productVariants {
      if let color = variant.color {
        if uniqueColorsDict[color.id ?? 0] == nil { // Keep first occurrence only
          uniqueColorsDict[color.id ?? 0] = color
        }
      }
    }
    coloursList = Array(uniqueColorsDict.values) // Ordered by first appearance
    
    // SAFETY: Reload collection views first with empty/no selection
    colorsCollectionView.reloadData()
    sizeCollectionView.reloadData()
    
    // === CRITICAL FIX: Always default to index 0 color ===
    guard !coloursList.isEmpty else {
      selectedVariant = nil
      selectedColourIndex = 0
      selectedSizeIndex = 0
      updateVariantUI()
      return
    }
    
    // Force select the FIRST color (index 0)
    selectedColourIndex = 0
    let firstColor = coloursList[0]
    let firstColorId = firstColor.id
    
    if let defaultVariant = productVariants.first(where: { $0.color?.id == firstColorId }) {
      selectedVariant = defaultVariant
    } else if let anyVariant = productVariants.first {
      // Fallback: in case of corrupted data
      selectedVariant = anyVariant
      // Update selectedColourIndex to match this fallback color
      selectedColourIndex = coloursList.firstIndex(where: { $0.id == anyVariant.color?.id }) ?? 0
    }
    // Now build sizes list based on selected color
    sizesList = productVariants
      .filter { $0.color?.id == firstColorId }
      .compactMap { $0.size }
    
    // Default to first size
    selectedSizeIndex = 0
    
    // Now reload UI
    colorsCollectionView.reloadData()
    sizeCollectionView.reloadData()
    productImageCollectionView.reloadData()
    
    updateVariantUI()
    
    // MARK: Rating Section Reload
    ratingsTableView.reloadData()
    ratingTableViewHeightConstriant.constant = ratingsTableView.contentSize.height
    
    speifcationArray = data.productSpecifications?.compactMap {
      "● \($0.nameEn ?? "") - \($0.featureEn ?? "")"
    } ?? []
    specificationTableView.reloadData()
    specificationTableViewHieghtConstraint.constant = specificationTableView.contentSize.height
  }
  
  func updateVariantUI(updateImages: Bool = true) {
    guard let variant = selectedVariant else { return }
    
    // Only update images if needed
    if updateImages {
      let images = variant.variantImage ?? []
      imagesPageController.numberOfPages = images.count
      imagesPageController.currentPage = 0
      productImageCollectionView.setContentOffset(CGPoint.zero, animated: false)
      productImageCollectionView.reloadData()
    }
    
    // PRICE
    let discountType = variant.discountType ?? "1"
    if discountType == "1" {
      discountPriceALbel.text = "\(variant.discountValue ?? "")% Off"
    } else {
      discountPriceALbel.text = "\(variant.discountValue ?? "") KD Off"
    }
    finalPriceLabel.text = "\(variant.finalPrice ?? "0") KD"
    CommonUtils.setStrikethrough(label: actualPriceLAbel, text: "\(variant.actualPrice ?? "0") KD")
    
    // STOCK/SKU
    totalStocksLabel.text = variant.totalStock ?? "0"
    skuLabel.text = variant.sku ?? "-"
    skuThresholderLabel.text = variant.skuThresholdValue ?? "-"
    
    // MEASUREMENTS
    bustLabel.text = variant.bust ?? "-"
    waistLabel.text = variant.waist ?? "-"
    hipLabel.text = variant.hip ?? "-"
    shoulderLabel.text = variant.shoulder ?? "-"
    sleeveLenghtLabel.text = variant.sleeveLength ?? "-"
    lengthLabel.text = variant.length ?? "-"
    
    // Update sizes for selected color
    if let colorId = variant.color?.id {
      sizesList = productVariants
        .filter { $0.color?.id == colorId }
        .compactMap { $0.size }
      sizeCollectionView.reloadData()
    }
  }
  
  
  
  
  func convertDate(_ input: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
    inputFormatter.timeZone = TimeZone(abbreviation: "UTC")
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "dd/MM/yyyy"
    
    if let date = inputFormatter.date(from: input) {
      return outputFormatter.string(from: date)
    } else {
      return "Invalid date"
    }
  }
  
  
}

extension ProductDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch collectionView {
    case productImageCollectionView:
      return selectedVariant?.variantImage?.count ?? 0
    case colorsCollectionView:
      return coloursList.count
    case sizeCollectionView:
      return sizesList.count
    default:
      return 0
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch collectionView {
    case productImageCollectionView:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductDetailImageCollectionViewCell", for: indexPath) as! ProductDetailImageCollectionViewCell
      
      // Show images of the selected variant
      if let images = selectedVariant?.variantImage, images.count > indexPath.row {
        cell.configData(variantImageUrl: images[indexPath.row])
      }
      return cell
    case colorsCollectionView:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductColoursCollectionViewCell", for: indexPath) as! ProductColoursCollectionViewCell
      cell.mainView.backgroundColor = UIColor(hex: coloursList[indexPath.row].hexCode ?? "")
      if selectedColourIndex == indexPath.row {
        cell.borderView.layer.borderColor = UIColor.darkBrown.cgColor
      } else {
        cell.borderView.layer.borderColor = UIColor.white.cgColor
      }
      return cell
    case sizeCollectionView:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeVariantCollectionViewCell", for: indexPath) as! SizeVariantCollectionViewCell
      let size = sizesList[indexPath.row]
      
      cell.titleLabel.text = size.name
      
      // Get variant for selected color + this size
      if let colorId = selectedVariant?.color?.id,
         let variant = productVariants.first(where: { $0.color?.id == colorId && $0.size?.id == size.id }) {
        
        let stock = Int(variant.totalStock ?? "0") ?? 0
        
        if stock > 0 {
          cell.titleLabel.textColor = .black
          cell.mainView.alpha = 1.0
          cell.mainView.layer.borderColor = (selectedSizeIndex == indexPath.row ? UIColor.darkBrown : UIColor.lightGray).cgColor
        } else {
          cell.titleLabel.textColor = .gray
          cell.mainView.layer.borderColor = UIColor.lightGray.cgColor
          cell.mainView.alpha = 0.5
        }
      }
      
      return cell
    default:
      return UICollectionViewCell()
    }
    
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch collectionView {
    case productImageCollectionView:
      guard let images = selectedVariant?.variantImage else { return }
      let vc = FullscreenGalleryViewController()
      vc.images = images
      vc.startIndex = indexPath.row
      vc.modalPresentationStyle = .fullScreen
      present(vc, animated: true)
    case colorsCollectionView:
      selectedColourIndex = indexPath.row
      let selectedColorId = coloursList[indexPath.row].id
      
      // Pick first in-stock variant for this color
      if let firstInStockVariant = productVariants.first(where: { $0.color?.id == selectedColorId && (Int($0.totalStock ?? "0") ?? 0) > 0 }) {
        selectedVariant = firstInStockVariant
      } else {
        // fallback: pick first variant of this color
        selectedVariant = productVariants.first(where: { $0.color?.id == selectedColorId })
      }
      
      // Update sizes for selected color
      sizesList = productVariants
        .filter { $0.color?.id == selectedColorId }
        .compactMap { $0.size }
      
      // Select first in-stock size, else index 0
      if let firstInStockSizeIndex = sizesList.firstIndex(where: {_ in
        if let variant = productVariants.first(where: { $0.color?.id == selectedColorId && $0.size?.id == $0.id }) {
          return (Int(variant.totalStock ?? "0") ?? 0) > 0
        }
        return false
      }) {
        selectedSizeIndex = firstInStockSizeIndex
      } else {
        selectedSizeIndex = 0
      }
      
      colorsCollectionView.reloadData()
      sizeCollectionView.reloadData()
      updateVariantUI(updateImages: true)
    case sizeCollectionView:
      let size = sizesList[indexPath.row]
      guard let colorId = selectedVariant?.color?.id else { return }
      
      // Find variant for this color + size
      if let variant = productVariants.first(where: { $0.color?.id == colorId && $0.size?.id == size.id }) {
        
        let stock = Int(variant.totalStock ?? "0") ?? 0
        
        // Only allow selection if stock > 0
        guard stock > 0 else { return }
        
        selectedVariant = variant
        selectedSizeIndex = indexPath.row
        
        // Update all details except images
        updateVariantUI(updateImages: false)
        sizeCollectionView.reloadData()
      }
    default:
      print("")
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    switch collectionView {
    case productImageCollectionView:
      return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    case colorsCollectionView:
      return CGSize(width: 54, height: 45)
    case sizeCollectionView:
      return CGSize(width: 55, height: 42)
    default:
      return CGSize(width: 0, height: 0)
    }
    
  }
  
  // MARK: - Update Page Control on Scroll
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == productImageCollectionView {
      let pageIndex = Int(round(scrollView.contentOffset.x / productImageCollectionView.frame.width))
      imagesPageController.currentPage = pageIndex
    }
  }
  
}

extension ProductDetailViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch tableView {
    case specificationTableView:
      return speifcationArray.count
    case ratingsTableView:
      return 2
    default:
      return 0
    }
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch tableView {
    case specificationTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
      cell.titleLabel.text = speifcationArray[indexPath.row]
      return cell
    case ratingsTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "ProductRatingTableViewCell", for: indexPath) as! ProductRatingTableViewCell
      return cell
    default:
      return UITableViewCell()
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    viewWillLayoutSubviews()
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch tableView {
    case specificationTableView:
      return 30
    default:
      return UITableView.automaticDimension
    }
  }
  
}
