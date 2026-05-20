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
    @IBOutlet weak var otherBrandArabicTF: ArabicTextField!
    @IBOutlet weak var producNameEngTF: UITextField!
    @IBOutlet weak var productNameArabicTF: ArabicTextField!
    @IBOutlet weak var descriptionEngTextView: UITextView!
    @IBOutlet weak var descriptionArabicTextView: ArabicTextView!
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
    @IBOutlet weak var lblSelectCatTitle: UILabel!
    @IBOutlet weak var lblSubCAteTitle: UILabel!
    
    private lazy var viewModel = AddNewProductViewModel(hostVC: self)
    var comingReason: ComingReasonAtAddToProduct = .forAddingProduct
    var specifications: [Spefication] = [Spefication()]
    var variantArray: [Variant] = [Variant()]
    var colorsList: [ColorsLisDataModel] = []
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
        lblSelectCatTitle.text = "Select Category".localiz()
        lblSubCAteTitle.text = "Sub Category".localiz()
        viewModel.getCategoriesListApi()
        viewModel.getBrandListApi()
        viewModel.getColoursListApi()
        viewModel.getSizeListApi()
        initialSetup()
        setupTextViewPlaceholder()
        variantTableView.rowHeight = UITableView.automaticDimension
        variantTableView.estimatedRowHeight = 200
        variantTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    deinit {
        variantTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey] {
                let newsize  = newvalue as! CGSize
                varaintTableViewHeightConstriant.constant = newsize.height
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            self.updateSpecificationTableHeight()
        }
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addSpecificationsDidTapped(_ sender: Any) {
        let lastIndex = specifications.count - 1
        if let lastCell = specificationTableView.cellForRow(at: IndexPath(row: lastIndex, section: 0)) as? AddSpecificationTableViewCell {
            let errors = lastCell.validateSpecificationFields()
            if !errors.isEmpty {
                showAlert(msg: errors)
                return
            }
            var spec = specifications[lastIndex]
            spec.product_spe_en = lastCell.nameEngTF.text ?? ""
            spec.product_spe_feature_en = lastCell.featuresEngTF.text ?? ""
            spec.product_spe_ar = lastCell.nameARTF.text ?? ""
            spec.product_spe_feature_ar = lastCell.featuresARTF.text ?? ""
            specifications[lastIndex] = spec
        }
        let newSpec = Spefication()
        specifications.append(newSpec)
        let newIndexPath = IndexPath(row: specifications.count - 1, section: 0)
        specificationTableView.performBatchUpdates({
            specificationTableView.insertRows(at: [newIndexPath], with: .automatic)
        }) { _ in
            self.updateSpecificationTableHeight()
            self.specificationTableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
        addSpecificationButtonOutlet.isHidden = true
    }
    
    @IBAction func addVariantDidTapped(_ sender: Any)  {
        
        let lastIndex = variantArray.count - 1
        let indexPath = IndexPath(row: lastIndex, section: 0)
        
        guard let lastCell = variantTableView.cellForRow(at: indexPath) as? AddVariantTableViewCell else { return }
        
        // VALIDATION
        let errors = lastCell.validateFieldsWithErrors()
        if !errors.isEmpty {
            showAlert(msg: errors)
            return
        }
        
        // SAVE SIZE VARIANTS FIRST (IMPORTANT)
        lastCell.saveVariantData()   // updates lastCell.variant correctly
        
        // MERGE into variantArray
        var variant = variantArray[lastIndex]
        
        variant.colorId = lastCell.variant.colorId
        variant.images = lastCell.variant.images
        variant.imageURLs = lastCell.variant.imageURLs
        
        // MERGE ALL SIZE VARIANTS WITHOUT LOSING PREVIOUS ONES
        variant.sizeVariants.removeAll()  // Reset
        variant.sizeVariants.append(contentsOf: lastCell.variant.sizeVariants)
        
        // ASSIGN BACK TO ARRAY
        variantArray[lastIndex] = variant
        
        // ADD NEW VARIANT ROW ONLY IF THIS ONE IS COMPLETE
        if variant.colorId != -1 && !variant.sizeVariants.isEmpty {
            variantArray.append(Variant())
            
            let newIndex = IndexPath(row: variantArray.count - 1, section: 0)
            variantTableView.performBatchUpdates({
                variantTableView.insertRows(at: [newIndex], with: .automatic)
            }) { _ in
                DispatchQueue.main.async {
                    self.variantTableView.scrollToRow(at: newIndex, at: .bottom, animated: true)
                }
            }
        } else {
            print("⚠️ Variant not complete. Not adding a new row.")
        }
    }
    
    @IBAction func subCatgeoryAction(_ sender: UIButton) {
//        let subCategoryNames = viewModel.subcategoriesList.map { subcategories -> String in
//            let list = subcategories.nameEnglish ?? ""
//            return "\(list)"
//        }
//        kSharedAppDelegate.dropDown(dataSource: subCategoryNames, anchorView: sender) { index, item in
//            let selectedsubCategory = self.viewModel.subcategoriesList[index]
//            self.subCatgeoryTF.text = selectedsubCategory.nameEnglish ?? ""
//            self.selectedSubCategoriesId = selectedsubCategory.id
//        }
        
        let subCategoryNames = viewModel.subcategoriesList.map { subcategories -> String in
            if AppLanguageManager.shared.currentLanguage == .ar {
                return subcategories.nameArabic ?? ""
            } else {
                return subcategories.nameEnglish ?? ""
            }
        }
        kSharedAppDelegate.dropDown(dataSource: subCategoryNames,anchorView: sender) { index, item in
            let selectedsubCategory = self.viewModel.subcategoriesList[index]
            if AppLanguageManager.shared.currentLanguage == .ar {
                self.subCatgeoryTF.text = selectedsubCategory.nameArabic ?? ""
            } else {
                self.subCatgeoryTF.text = selectedsubCategory.nameEnglish ?? ""
            }
            self.selectedSubCategoriesId = selectedsubCategory.id
        }
    }
    
    @IBAction func brandListAction(_ sender: UIButton) {
        let brandNames = viewModel.brandsList.map { brands -> String in
            if AppLanguageManager.shared.currentLanguage == .ar {
                return brands.nameArabic ?? ""
            } else {
                return brands.nameEnglish ?? ""
            }
        }
        kSharedAppDelegate.dropDown(dataSource: brandNames,anchorView: sender) { index, item in
            let selectedsubCategory = self.viewModel.brandsList[index]
            if AppLanguageManager.shared.currentLanguage == .ar {
                self.selectedBrandTF.text = selectedsubCategory.nameArabic ?? ""
            } else {
                self.selectedBrandTF.text = selectedsubCategory.nameEnglish ?? ""
            }
            
            self.selectedBrandId = selectedsubCategory.id
            
            // ✅ Check using English key from API
            if (selectedsubCategory.nameEnglish?.lowercased() == "other") {
                self.otherStackView.isHidden = false
            } else {
                self.otherStackView.isHidden = true
            }
        }
    }
    
    @IBAction func addProductDidTapepd(_ sender: Any) {
        saveLastVariantIfNeeded()  // IMPORTANT
        if viewModel.validFields() {
            viewModel.variantArray = self.variantArray  // MOVE ARRAY TO VIEWMODEL
            switch comingReason {
            case .forEditProduct: viewModel.editProductApi()
            case .forAddingProduct: viewModel.addProductApi()
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
                        self.sizeChartImageView.sd_setImage(with: url,placeholderImage: UIImage(named: "bannerDashed"))
                    }
                }
            }
        }
    }
    
    @IBAction func deleteDidTapped(_ sender: Any) {
        self.showConfirmationAlert(msg: "Are you sure you want to delete this product?".localiz()){ [weak self] in
            guard let self = self else { return }
            viewModel.deleteProductDetailsService()
        }
    }
    
    func saveLastVariantIfNeeded() {
        let lastIndex = variantArray.count - 1
        guard lastIndex >= 0 else { return }
        
        let indexPath = IndexPath(row: lastIndex, section: 0)
        guard let lastCell = variantTableView.cellForRow(at: indexPath) as? AddVariantTableViewCell else { return }
        
        // Save variant-level data
        lastCell.saveVariantData()
        
        // Save last size row if it exists
        if let sizeTable = lastCell.sizeVariantTableView,
           !lastCell.sizeVariants.isEmpty {
            
            let lastSizeIndex = lastCell.sizeVariants.count - 1
            let lastSizeIndexPath = IndexPath(row: lastSizeIndex, section: 0)
            
            if let lastSizeCell = sizeTable.cellForRow(at: lastSizeIndexPath) as? AddNewSizeVariantTableViewCell {
                var lastSize = lastCell.sizeVariants[lastSizeIndex]
                lastSize.sizeId = lastSizeCell.selectedSizeId
                lastSize.bust = lastSizeCell.bustTF.text ?? ""
                lastSize.waist = lastSizeCell.waistTF.text ?? ""
                lastSize.hip = lastSizeCell.hipTF.text ?? ""
                lastSize.shoulder = lastSizeCell.shoulderTF.text ?? ""
                lastSize.sleeveLength = lastSizeCell.sleeveLengthTF.text ?? ""
                lastSize.length = lastSizeCell.lengthTF.text ?? ""
                lastSize.totalStock = lastSizeCell.totalStocksTF.text ?? ""
                lastSize.sku = lastSizeCell.skuLimitTF.text ?? ""
                lastSize.actualPrice = lastSizeCell.actualPriceTF.text ?? ""
                lastSize.finalPrice = lastSizeCell.finalPriceTF.text ?? ""
                lastSize.discountValue = lastSizeCell.discountPriceTF.text ?? ""
                lastSize.discountTypeIsPercentage = lastSizeCell.discountTypeisPercentage
                
                lastCell.sizeVariants[lastSizeIndex] = lastSize
            }
        }
        
        // Merge updated data back to variantArray
        var variant = variantArray[lastIndex]
        variant.colorId = lastCell.variant.colorId
        variant.images = lastCell.variant.images
        variant.imageURLs = lastCell.variant.imageURLs
        variant.sizeVariants = lastCell.sizeVariants
        
        // Save back
        variantArray[lastIndex] = variant
    }
    
    private func refreshVariantCellDisplays() {
        // guard !viewModel.colorsList.isEmpty || !viewModel.sizesList.isEmpty else { return }
        
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
            titleLabel.text = "Add new product".localiz()
            addButtonLabel.text = "Add Product".localiz()
        case .forEditProduct:
            cancelView.isHidden = false
            titleLabel.text = "Edit product".localiz()
            addButtonLabel.text = "Edit Product".localiz()
            viewModel.getProductDetailsService()
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
    
    func updateSpecificationTableHeight() {
        specificationTableView.layoutIfNeeded()
        
        var height = specificationTableView.contentSize.height
        height += 20
        if height < 100 {
            height = 150
        }
        UIView.animate(withDuration: 0.1) {
            self.specificationTableViewHeightConstraint.constant = height
            self.view.layoutIfNeeded()
        }
    }
    
    func updateVariantTableHeight() {
        variantTableView.layoutIfNeeded()
        
        let height = max(variantTableView.contentSize.height + 20, 150)
        
        if varaintTableViewHeightConstriant.constant != height {
            UIView.animate(withDuration: 0.25) {
                self.varaintTableViewHeightConstriant.constant = height
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func updateRadioButtons(selected: Bool, yesButton: UIButton, noButton: UIButton) {
        let yesImageName = selected ? "radioSelected" : "radioUnselected"
        let noImageName = selected ? "radioUnselected" : "radioSelected"
        
        yesButton.setImage(UIImage(named: yesImageName), for: .normal)
        noButton.setImage(UIImage(named: noImageName), for: .normal)
    }
    
    func setupTextViewPlaceholder() {
        descriptionEngTextView.text = "Write Here".localiz()
        descriptionEngTextView.textColor = .lightGray
        descriptionEngTextView.delegate = self
        
        descriptionArabicTextView.text = "Write Here".localiz()
        descriptionArabicTextView.textColor = .lightGray
        descriptionArabicTextView.delegate = self
    }
    
    func prepareVariantData(isWomenCategory: Bool) -> [[String: Any]] {
        var productsArray: [[String: Any]] = []
        
        for variant in variantArray {
            
            // IMAGES
            let images = variant.imageURLs // Already array of URLs
            
            // PRODUCT VARIATIONS (sizes)
            var variationArray: [[String: Any]] = []
            
            for size in variant.sizeVariants {
                var sizeDict: [String: Any] = [
                    "size_id": size.sizeId ?? -1,
                    "total_stock": size.totalStock,
                    "sku": size.sku,
                    "actual_price": size.actualPrice,
                    "discount_type": size.discountTypeIsPercentage ? "1" : "2",
                    "discount_value": size.discountValue,
                    "final_price": size.finalPrice
                ]
                
                if isWomenCategory {
                    sizeDict["bust"] = size.bust
                    sizeDict["waist"] = size.waist
                    sizeDict["hip"] = size.hip
                    sizeDict["shoulder"] = size.shoulder
                    sizeDict["sleeve_length"] = size.sleeveLength
                    sizeDict["length"] = size.length
                }
                variationArray.append(sizeDict)
            }
            
            // FINAL PRODUCT DICTIONARY
            let productDict: [String: Any] = [
                "variant_image": images,
                "color_id": variant.colorId ?? -1,
                "product_variation": variationArray
            ]
            productsArray.append(productDict)
        }
        return productsArray
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
        
        return ["product_spe_en": product_spe_en,
                "product_spe_feature_en": product_spe_feature_en,
                "product_spe_ar": product_spe_ar,
                "product_spe_feature_ar": product_spe_feature_ar]
    }
    
    func prefillProductDetails(_ data: ProductsList) {
        selectedCategoriesSection = Int(data.categoryID ?? "0")
        categoriesCollectionView.reloadData()
        
        selectedSubCategoriesId = Int(data.subcategoryID ?? "0")
        if AppLanguageManager.shared.currentLanguage == .ar {
            subCatgeoryTF.text = data.subcategory?.nameArabic
            selectedBrandTF.text = data.brand?.nameArabic
        } else {
            subCatgeoryTF.text = data.subcategory?.nameEnglish
            selectedBrandTF.text = data.brand?.nameEnglish
        }
        
        selectedBrandId = Int(data.brandID ?? "0")
        
        
        otherStackView.isHidden = (data.brand?.nameEnglish?.lowercased() != "other")
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
            sizeChartImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "bannerDashed"))
        }
        
        // ---------------- SPECIFICATIONS ----------------
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
        
        // ---------------- VARIANTS ----------------
        variantArray.removeAll()
        colorsList.removeAll()
        
        let variants = data.productVariants ?? []
        
        // Group by color
        let groupedByColor = Dictionary(grouping: variants, by: { $0.colorID ?? "" })
        
        for (colorID, variantsForColor) in groupedByColor {
            guard let firstVariant = variantsForColor.first else { continue }
            
            var variant = Variant()
            variant.colorId = firstVariant.colorID?.toInt ?? -1
            
            // ----- Update Color List -----
            if let cid = firstVariant.colorID?.toInt,
               let cname = firstVariant.color?.name,
               let arname = firstVariant.color?.nameAr,
               let ccode = firstVariant.color?.hexCode,
               let created = firstVariant.createdAt,
               let updated = firstVariant.updatedAt {
                if !colorsList.contains(where: { $0.id == cid }) {
                    let colorModel = ColorsLisDataModel(
                        id: cid,
                        name: cname,
                        nameAr: arname,
                        hexCode: ccode,
                        createdAt: created,
                        updatedAt: updated
                    )
                    colorsList.append(colorModel)
                }
            }
            
            // ----- Attach all sizes for this color -----
            var sizeVariants: [SizeVariant] = []
            for v in variantsForColor {
                var sv = SizeVariant()
                sv.sizeId = v.sizeID?.toInt ?? -1
                sv.totalStock = v.totalStock ?? ""
                sv.sku = v.sku ?? ""
                sv.actualPrice = v.actualPrice ?? ""
                sv.discountTypeIsPercentage = (v.discountType == "1")
                sv.discountValue = v.discountValue ?? ""
                sv.finalPrice = v.finalPrice ?? ""
                
                sv.bust = v.bust ?? ""
                sv.hip = v.hip ?? ""
                sv.waist = v.waist ?? ""
                sv.length = v.length ?? ""
                sv.shoulder = v.shoulder ?? ""
                sv.sleeveLength = v.sleeveLength ?? ""
                
                sizeVariants.append(sv)
            }
            variant.sizeVariants = sizeVariants
            
            // ----- Attach images (first variant's images) -----
            if let imgs = firstVariant.variantImage, !imgs.isEmpty {
                variant.imageURLs = imgs
                variant.images = Array(repeating: UIImage(), count: imgs.count)
            } else {
                variant.imageURLs = []
                variant.images = []
            }
            
            variantArray.append(variant)
        }
        
        // ---------------- ASSIGN COLORS & SIZES TO VIEWMODEL ----------------
        viewModel.colorsList = colorsList
        //        viewModel.sizesList = variantArray.flatMap { $0.sizeVariants } as! [SizeListDataModel]
        
        variantTableView.reloadData()
        
        // ---------------- REFRESH VISIBLE CELLS ----------------
        DispatchQueue.main.async {
            self.refreshVariantCellDisplays()
        }
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
            
            // Hide header for first row
            cell.headerView.isHidden = indexPath.row == 0
            
            // Restore saved UI values (MOST IMPORTANT FIX)
            cell.sizeVariants = variant.sizeVariants
            cell.selectedColorId = variant.colorId
            cell.images = variant.images
            cell.imageURLs = variant.imageURLs
            
            // Restore color selection
            if let color = viewModel.colorsList.first(where: { $0.id == variant.colorId }) {
                cell.colorTF.text = AppLanguageManager.shared.currentLanguage == .ar
                ? (color.nameAr ?? color.name ?? "")
                : (color.name ?? "")
            } else {
                cell.colorTF.text = ""
            }
            
            // Load images
            for (index, urlString) in variant.imageURLs.enumerated() {
                guard let url = URL(string: urlString) else { continue }
                
                SDWebImageManager.shared.loadImage(
                    with: url,
                    options: [.highPriority, .retryFailed],
                    progress: nil
                ) { [weak cell] (image, _, _, _, _, _) in
                    guard let cell = cell, let image = image, index < cell.images.count else { return }
                    cell.images[index] = image
                    DispatchQueue.main.async { cell.reloadImageItem(at: index) }
                }
            }
            
            // Reload collection once
            DispatchQueue.main.async {
                cell.imagesCollectionView.reloadData()
            }
            
            cell.isWomenIsSelected = self.isWomenCategory
            cell.sizesList = viewModel.sizesList
            
            // Variant update callback
            cell.onVariantUpdated = { [weak self] updatedVariant in
                guard let self = self else { return }
                self.variantArray[indexPath.row] = updatedVariant
            }
            
            // Color picker button
            cell.onColorButtonTap = { [weak self, weak cell] in
                guard let self = self, let cell = cell else { return }
                self.showColorDropdown(from: cell.colorTF, in: cell)
            }
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
//    private func showColorDropdown(from textField: UITextField, in cell: AddVariantTableViewCell) {
//        let sizesNames = viewModel.colorsList.map { $0.name ?? "" }
//        kSharedAppDelegate.dropDown(dataSource: sizesNames, anchorView: textField) { [weak self] index, item in
//            guard let self = self else { return }
//            let selectedSize = self.viewModel.colorsList[index]
//            cell.colorTF.text = selectedSize.name
//            cell.selectedColorId = selectedSize.id
//        }
//    }
    
    private func showColorDropdown(from textField: UITextField, in cell: AddVariantTableViewCell) {
        let isArabic = AppLanguageManager.shared.currentLanguage == .ar
        let colorNames = viewModel.colorsList.map {
            isArabic
            ? ($0.nameAr ?? $0.name ?? "")
            : ($0.name ?? "")
        }
        kSharedAppDelegate.dropDown(dataSource: colorNames, anchorView: textField) { [weak self] index, item in
            guard let self = self else { return }
            let selectedColor = self.viewModel.colorsList[index]
            cell.colorTF.text = isArabic
                ? (selectedColor.nameAr ?? selectedColor.name ?? "")
                : (selectedColor.name ?? "")
            cell.selectedColorId = selectedColor.id
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
        if AppLanguageManager.shared.currentLanguage == .ar {
            cell.titleLabel.text = data.nameAr
        } else {
            cell.titleLabel.text = data.name
        }
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
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 0) / 3
        let height: CGFloat = 35
        return CGSize(width: width, height: height)
    }
    
}

extension AddNewProductViewController: AddSpecificationCellDelegate, AddVariantCellDelegate {
    
    func innerTableViewHeightChanged(from cell: AddVariantTableViewCell) {
        DispatchQueue.main.async {
            self.variantTableView.beginUpdates()
            self.variantTableView.endUpdates()
        }
    }
    
    
    func addImageTapped(from cell: AddVariantTableViewCell, at index: Int) {
        ImagePickerHelper.shared.showPickerController { [weak cell] image, imageName in
            guard let image = image, let cell = cell else { return }
            WebService.sharedInstance.uploadImage(withParams: image) { imageURL in
                DispatchQueue.main.async {
                    let insertIndex = cell.images.count
                    cell.images.append(image)
                    cell.imageURLs.append(imageURL.url ?? "")
                    let newItemIndexPath = IndexPath(item: insertIndex + 1, section: 0) // +1 because 0 is placeholder
                    cell.imagesCollectionView.performBatchUpdates({
                        cell.imagesCollectionView.insertItems(at: [newItemIndexPath])
                    }, completion: nil)
                    
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
            if self.variantArray.isEmpty {
                self.variantArray.append(Variant())
                let newIndexPath = IndexPath(row: 0, section: 0)
                self.variantTableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        })
    }
    
    func addSpecificationTapped(from cell: AddSpecificationTableViewCell) {
        guard let indexPath = specificationTableView.indexPath(for: cell) else { return }
        let errors = cell.validateSpecificationFields()
        if !errors.isEmpty {
            showAlert(msg: errors)
            specificationTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            return
        }
        var currentSpec = specifications[indexPath.row]
        currentSpec.product_spe_en = cell.nameEngTF.text ?? ""
        currentSpec.product_spe_feature_en = cell.featuresEngTF.text ?? ""
        currentSpec.product_spe_ar = cell.nameARTF.text ?? ""
        currentSpec.product_spe_feature_ar = cell.featuresARTF.text ?? ""
        specifications[indexPath.row] = currentSpec
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
}

extension AddNewProductViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let currentText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if string.isEmpty { return true }
        
        if currentText.hasPrefix(" ") { return false }
        let fieldsAllowingSpaces: [UITextField] = [otherBrandEnglishTF,otherBrandArabicTF, producNameEngTF,productNameArabicTF,]
        
        let numericFields = [minCartQuantityTF,maxCartQuantityTF,totalDaysReturningTF,exchangableTF]
        if numericFields.contains(textField) {
            if string == " " { return false }
            let allowedSet = CharacterSet.decimalDigits
            if string.rangeOfCharacter(from: allowedSet.inverted) != nil {
                return false
            }
            if currentText.count == 1 && currentText == "0" {
                return false
            }
            if (textField == minCartQuantityTF || textField == maxCartQuantityTF) && currentText.count > 6 {
                return false
            }
            if textField == maxCartQuantityTF {
                let minVal = Int(minCartQuantityTF.text ?? "") ?? 0
                let maxVal = Int(currentText) ?? 0
            } else if textField == minCartQuantityTF {
                let maxVal = Int(maxCartQuantityTF.text ?? "") ?? 0
                let minVal = Int(currentText) ?? 0
                if minVal > maxVal && maxVal != 0 {
                    CommonUtils.showToast(message: "Min quantity cannot be greater than Max quantity".localiz())
                    return false
                }
            }
            
            return true
        }
        if textField == otherBrandArabicTF || textField == productNameArabicTF {
            let allowedSet = CharacterSet(charactersIn: "\u{0600}"..."\u{06FF}")
                .union(CharacterSet(charactersIn: "\u{0750}"..."\u{077F}"))
                .union(CharacterSet(charactersIn: "\u{08A0}"..."\u{08FF}"))
                .union(CharacterSet.whitespaces)
            
            for scalar in string.unicodeScalars {
                if !allowedSet.contains(scalar) {
                    CommonUtils.showToast(message: "Please switch to Arabic keyboard".localiz())
                    return false
                }
            }
            return true
        }
        if textField == otherBrandEnglishTF || textField == producNameEngTF {
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        validateMinMaxQuantity()
    }
    
    func validateMinMaxQuantity() {
        let minVal = Int(minCartQuantityTF.text ?? "") ?? 0
        let maxVal = Int(maxCartQuantityTF.text ?? "") ?? 0
        if minVal >= maxVal && maxVal != 0 {
            CommonUtils.showToast(message: "Min Cart Quantity must be smaller than Max Cart Quantity".localiz())
        }
    }
    
}

extension AddNewProductViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if textView == descriptionEngTextView {
                textView.text = "Write Here".localiz()
            } else if textView == descriptionArabicTextView {
                textView.text = "Write Here".localiz()
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
                    CommonUtils.showToast(message: "Please switch to Arabic keyboard".localiz())
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

