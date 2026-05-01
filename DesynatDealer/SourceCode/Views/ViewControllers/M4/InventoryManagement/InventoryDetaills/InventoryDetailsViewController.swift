//
//  InventoryDetailsViewController.swift
//  DesynatDealer
//
//  Created by fluper on 05/12/25.
//

import UIKit

class InventoryDetailsViewController: UIViewController {
    
    @IBOutlet weak var priceSeparatorLabel: UILabel!
    @IBOutlet weak var titlePageLabel: UILabel!
    @IBOutlet weak var skuLimitLabel: UILabel!
    @IBOutlet weak var totalStocksLabel: UILabel!
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
    
    @IBOutlet weak var editInvertoryView: UIView!
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
    private lazy var viewModel = InventoryDetailsViewModel(hostVC: self)
    var productVariants: [ProductVariant] = []
    var coloursList: [ColorsLisDataModel] = []
    var sizesList: [SizeListDataModel] = []
    private var selectedVariant: ProductVariant?
    var hasActionPermission: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusButton.isUserInteractionEnabled = hasActionPermission
        editInvertoryView.isHidden = !hasActionPermission
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getProductDetailsService()
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
        let nextVC = EditInventoryDetailsViewController.instantiate(fromAppStoryboard: .InventoryAffilate)
        nextVC.productId = viewModel.productDetails?.id ?? 0
        
        // Pass the entire product details
        nextVC.viewModel.productDetails = viewModel.productDetails
        
        // MOST IMPORTANT — Pass the currently selected variant
        nextVC.selectedVariant = self.selectedVariant
        
        self.navigationController?.pushViewController(nextVC, animated: true)
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
                    let message = newStatus == 1 ? "Product has been activated Successfully".localiz() : "Product has been Deactivated Successfully".localiz()
                    CommonUtils.showToast(message: message)
                }
            }
        }
    }
    
    func configData(data: ProductsList) {
        // MARK: - Basic Product info
        //      titlePageLabel.text = data.brand?.nameEnglish ?? ""
        if data.brand?.nameEnglish == "Other".localiz() {
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
            statusLabel.text = "Active".localiz()
            statusButton.setImage(UIImage(named: "toggle_on"), for: .normal)
        } else {
            statusLabel.text = "Inactive".localiz()
            statusButton.setImage(UIImage(named: "toggle_off"), for: .normal)
        }
        
        // MARK: - Switch Labels (YES / NO)
        
        productVariants = data.productVariants ?? []
        var uniqueColorsDict: [Int: ColorsLisDataModel] = [:]
        for variant in productVariants {
            if let color = variant.color {
                if uniqueColorsDict[color.id ?? 0] == nil {
                    uniqueColorsDict[color.id ?? 0] = color
                }
            }
        }
        coloursList = Array(uniqueColorsDict.values)
        colorsCollectionView.reloadData()
        sizeCollectionView.reloadData()
        guard !coloursList.isEmpty else {
            selectedVariant = nil
            selectedColourIndex = 0
            selectedSizeIndex = 0
            updateVariantUI()
            return
        }
        
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
        let text = "KD".localiz()
        finalPriceLabel.text = "\(variant.finalPrice ?? "0") \(text)"
        CommonUtils.setStrikethrough(label: actualPriceLAbel, text: "\(variant.actualPrice ?? "0") \(text)")
        
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
        totalStocksLabel.text = variant.totalStock ?? "0"
        skuLimitLabel.text = variant.sku ?? "-"
        
        // Update sizes for selected color
        if let colorId = variant.color?.id {
            sizesList = productVariants
                .filter { $0.color?.id == colorId }
                .compactMap { $0.size }
            sizeCollectionView.reloadData()
        }
    }
    
}

extension InventoryDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
                //let stock = Int(variant.totalStock ?? "0") ?? 0
                //guard stock > 0 else { return }
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
