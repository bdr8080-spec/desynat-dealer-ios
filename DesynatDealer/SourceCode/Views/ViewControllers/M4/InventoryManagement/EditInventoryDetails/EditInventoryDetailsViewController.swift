//
//  EditInventoryDetailsViewController.swift
//  DesynatDealer
//
//  Created by fluper on 05/12/25.
//

import UIKit

class EditInventoryDetailsViewController: UIViewController {
    
    @IBOutlet weak var priceSeparatorLabel: UILabel!
    @IBOutlet weak var titlePageLabel: UILabel!
    @IBOutlet weak var skuLimitTF: UITextField!
    @IBOutlet weak var totalStocksTF: UITextField!
    @IBOutlet weak var actualPriceLAbel: CustomLabelFont!
    @IBOutlet weak var discountPriceALbel: UILabel!
    @IBOutlet weak var finalPriceLabel: UILabel!
    @IBOutlet weak var descriptionLAbel: UILabel!
    @IBOutlet weak var brandCategoryLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var imagesPageController: UIPageControl!
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
    
    private var selectedColourIndex = 0
    private var selectedSizeIndex = 0
    private var speifcationArray = [""]
    var productId: Int = 0
    lazy var viewModel = EditInventoryDetailsViewModel(hostVC: self)
    var productVariants: [ProductVariant] = []
    var coloursList: [ColorsLisDataModel] = []
    var sizesList: [SizeListDataModel] = []
    var selectedVariant: ProductVariant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skuLimitTF.delegate = self
        totalStocksTF.delegate = self
        viewModel.populateData()
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
        let errors = viewModel.validateFieldsWithErrors()
        if !errors.isEmpty {
            showAlert(msg: errors)
            return
        } else {
            viewModel.updateInventoryDetails()
        }
    }
    
    @IBAction func updateStatusDidTapped(_ sender: Any) {
        guard let user = viewModel.productDetails else { return }
        let newStatus = user.productActiveStatus == 1 ? 0 : 1
        let params: [String: Any] = ["product_id": user.id ?? 0]
        viewModel.updateActiveStatus(param: params) { [weak self] success in
            guard let self = self else { return }
            if success {
                self.viewModel.productDetails?.productActiveStatus = newStatus
                if let updatedUser = self.viewModel.productDetails {
                    self.configData(data: updatedUser)
                    let message = newStatus == 1 ? "Product has been activated Successfully" : "Product has been Deactivated Successfully"
                    CommonUtils.showToast(message: message)
                }
            }
        }
    }
    
    func configData(data: ProductsList?) {
        guard let data = data else { return }
        
        // MARK: - Basic Product info
        if data.brand?.nameEnglish == "Other" {
            productNameLabel.text = data.otherEn
            titlePageLabel.text = data.otherEn
        } else {
            productNameLabel.text = data.brand?.nameEnglish
            titlePageLabel.text = data.brand?.nameEnglish
        }
        
        descriptionLAbel.text = data.productNameEn ?? "-"
        brandCategoryLabel.text = data.category?.name ?? ""
        ratingCountLabel.text = " (\(data.reviewRating ?? "0"))"
        
        // Status
        if data.productActiveStatus == 1 {
            statusLabel.text = "Active"
            statusButton.setImage(UIImage(named: "toggle_on"), for: .normal)
        } else {
            statusLabel.text = "Inactive"
            statusButton.setImage(UIImage(named: "toggle_off"), for: .normal)
        }
        
        // MARK: - Variants
        productVariants = data.productVariants ?? []
        
        // Unique Colors
        var uniqueColors: [Int: ColorsLisDataModel] = [:]
        for variant in productVariants {
            if let color = variant.color, let id = color.id {
                if uniqueColors[id] == nil {
                    uniqueColors[id] = color
                }
            }
        }
        coloursList = Array(uniqueColors.values)
        
        // No colors → fallback
        guard !coloursList.isEmpty else {
            selectedVariant = nil
            selectedColourIndex = 0
            selectedSizeIndex = 0
            updateVariantUI()
            return
        }
        
        if let passedVariant = selectedVariant {
            
            // 1️⃣ Find matching COLOR index
            if let colorId = passedVariant.color?.id,
               let index = coloursList.firstIndex(where: { $0.id == colorId }) {
                selectedColourIndex = index
            } else {
                selectedColourIndex = 0
            }
            
            // 2️⃣ Sizes for this color
            sizesList = productVariants
                .filter { $0.color?.id == passedVariant.color?.id }
                .compactMap { $0.size }
            
            // 3️⃣ Find matching SIZE index
            if let sizeId = passedVariant.size?.id,
               let index = sizesList.firstIndex(where: { $0.id == sizeId }) {
                selectedSizeIndex = index
            } else {
                selectedSizeIndex = 0
            }
            
            // 4️⃣ Update UI for the passed variant
            colorsCollectionView.reloadData()
            sizeCollectionView.reloadData()
            productImageCollectionView.reloadData()
            updateVariantUI(updateImages: true)
            
            return   // STOP — do not reset to first variant
        }
        
        selectedColourIndex = 0
        let firstColor = coloursList[0]
        let firstColorId = firstColor.id
        
        if let defaultVariant = productVariants.first(where: { $0.color?.id == firstColorId }) {
            selectedVariant = defaultVariant
        } else {
            selectedVariant = productVariants.first
            selectedColourIndex = coloursList.firstIndex(where: { $0.id == selectedVariant?.color?.id }) ?? 0
        }
        
        // Sizes for first color
        sizesList = productVariants
            .filter { $0.color?.id == firstColorId }
            .compactMap { $0.size }
        
        selectedSizeIndex = 0
        
        colorsCollectionView.reloadData()
        sizeCollectionView.reloadData()
        productImageCollectionView.reloadData()
        updateVariantUI(updateImages: true)
    }
    
    
    func updateVariantUI(updateImages: Bool = true) {
        guard let variant = selectedVariant else { return }
        if updateImages {
            let images = variant.variantImage ?? []
            imagesPageController.numberOfPages = images.count
            imagesPageController.currentPage = 0
            productImageCollectionView.setContentOffset(CGPoint.zero, animated: false)
            productImageCollectionView.reloadData()
        }
        finalPriceLabel.text = "\(variant.finalPrice ?? "0") KD"
        CommonUtils.setStrikethrough(label: actualPriceLAbel, text: "\(variant.actualPrice ?? "0") KD")
        
        CommonUtils.updateDiscountPercentageLabel(discountPriceALbel,
                                                  actualAmountLabel: actualPriceLAbel,
                                                  discountType: variant.discountType,
                                                  discountValue: variant.discountValue)
        let value = Double(variant.discountValue ?? "0") ?? 0
        if value > 0 {
            priceSeparatorLabel.isHidden = false
        } else {
            priceSeparatorLabel.isHidden = true
        }
        // STOCK/SKU
        totalStocksTF.text = variant.totalStock ?? "0"
        skuLimitTF.text = variant.sku ?? "-"
        
        // Update sizes for selected color
        if let colorId = variant.color?.id {
            sizesList = productVariants
                .filter { $0.color?.id == colorId }
                .compactMap { $0.size }
            sizeCollectionView.reloadData()
        }
    }
    
}

extension EditInventoryDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
            if let colorId = selectedVariant?.color?.id,
               let variant = productVariants.first(where: { $0.color?.id == colorId && $0.size?.id == size.id }) {
                cell.titleLabel.textColor = .black
                cell.mainView.alpha = 1.0
                cell.mainView.layer.borderColor = (selectedSizeIndex == indexPath.row ? UIColor.darkBrown : UIColor.lightGray).cgColor
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
            if let firstInStockVariant = productVariants.first(where: { $0.color?.id == selectedColorId && (Int($0.totalStock ?? "0") ?? 0) > 0 }) {
                selectedVariant = firstInStockVariant
            } else {
                selectedVariant = productVariants.first(where: { $0.color?.id == selectedColorId })
            }
            sizesList = productVariants
                .filter { $0.color?.id == selectedColorId }
                .compactMap { $0.size }
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
            if let variant = productVariants.first(where: { $0.color?.id == colorId && $0.size?.id == size.id }) {
                selectedVariant = variant
                selectedSizeIndex = indexPath.row
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

extension EditInventoryDetailsViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // Allow deleting text
        if string.isEmpty {
            return true
        }
        
        // Disallow spaces in any numeric field
        if string.contains(" ") {
            return false
        }
        
        // Only allow digits
        if string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil {
            return false
        }
        
        // Handle totalStocksTF
        if textField === totalStocksTF {
            // Limit to 6 digits
            if updatedText.count > 6 {
                return false
            }
            return true
        }
        
        // Handle skuLimitTF
        if textField === skuLimitTF {
            let totalText = totalStocksTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let totalStocks = Int(totalText) ?? Int.max // If totalStocks is empty, treat as unlimited
            
            if let updatedSKU = Int(updatedText), updatedSKU > totalStocks {
                CommonUtils.showToast(message: "SKU limit cannot be greater than Total stocks")
                return false
            }
            return true
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let rawText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        if textField == totalStocksTF {
            // Only limit digits if user entered something
            if !rawText.isEmpty && rawText.count > 6 {
                textField.text = String(rawText.prefix(6))
                CommonUtils.showToast(message: "Total stocks cannot exceed 6 digits")
            }
            
            // Only warn if both fields are not empty
            if let skuText = skuLimitTF.text?.trimmingCharacters(in: .whitespacesAndNewlines),
               !skuText.isEmpty,
               let totalStocks = Int(rawText),
               let skuValue = Int(skuText),
               skuValue > totalStocks {
                CommonUtils.showToast(message: "SKU Limit cannot exceed total stocks (\(totalStocks))")
            }
            
            return
        }
        
        if textField == skuLimitTF {
            // Only validate if user entered something
            if !rawText.isEmpty {
                let totalStocks = Int(totalStocksTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "") ?? Int.max
                if let skuValue = Int(rawText), skuValue > totalStocks {
                    textField.text = "\(totalStocks)" // Optional: update to max allowed
                    CommonUtils.showToast(message: "SKU Limit cannot exceed total stocks (\(totalStocks))")
                }
            }
        }
    }
}
