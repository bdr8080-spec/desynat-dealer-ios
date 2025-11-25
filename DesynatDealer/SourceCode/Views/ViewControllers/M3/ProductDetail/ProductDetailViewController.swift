//
//  ProductDetailViewController.swift
//  DesynatUser
//
//  Created by fluper on 18/11/25.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
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
    private var speifcationArray = ["Type 1- Feature", "Type 2- Feature", "Type 3- Feature"]
    var productId: Int = 0
    private lazy var viewModel = ProductDetailsViewModel(hostVC: self)
    var productVariants: [ProductVariant] = []
    var coloursList: [ColorsLisDataModel] = []
    var sizesList: [SizeListDataModel] = []
    private var selectedVariant: ProductVariant?


    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func configData(data: ProductsList) {

        // MARK: - Basic Product info
        productNameLabel.text = data.productNameEn ?? "-"
        descriptionLabel.text = data.descriptionEn ?? "-"
        addedOnLabel.text = "Added on - \(convertDate(data.createdAt ?? ""))"
        brandCategoryLabel.text = "\(data.brand?.nameEnglish ?? "") | \(data.category?.name ?? "")"

        // Status
        if data.productActiveStatus == 1 {
            statusLabel.text = "Active"
            statusButton.setImage(UIImage(named: "toggleOn"), for: .normal)
        } else {
            statusLabel.text = "Inactive"
            statusButton.setImage(UIImage(named: "toggleOff"), for: .normal)
        }

        // MARK: - Switch Labels (YES / NO)
        cashOnDeliveryLabel.text = data.cashOnDelivery == "1" ? "Yes" : "No"
        readyToShipLabel.text = data.readyToShip == "1" ? "Yes" : "No"
        customizableLabel.text = data.customizedProduct == "1" ? "Yes" : "No"
        affiliatedLabel.text = data.affiliatedProduct == "1" ? "Yes" : "No"
        ratingReviewALlowedLabel.text = data.reviewRating == "1" ? "Allowed" : "Not Allowed"
        returnAllowedLAbel.text = data.productReturn == "1" ? "Yes, \(data.returnDays ?? "") days" : "No"
        exchnageAllowedLAbel.text = data.productExchangable == "1" ? "Yes, \(data.exchangableDays ?? "") days" : "No"

        // MARK: - Variants Setup
        productVariants = data.productVariants ?? []
        coloursList = data.productVariants?.compactMap { $0.color } ?? []
        colorsCollectionView.reloadData()

        // Default → Select first variant
        selectedColourIndex = 0
        selectedVariant = productVariants.first

        // Load sizes from selected variant
//        sizesList = selectedVariant?.size ?? []
        sizeCollectionView.reloadData()

        // Load specs / price / images
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
    
    func updateVariantUI() {
        guard let variant = selectedVariant else { return }

        // IMAGES
        imagesPageController.numberOfPages = variant.variantImage?.count ?? 0
        productImageCollectionView.reloadData()

        // PRICE
        actualPriceLAbel.text = "AED \(variant.actualPrice ?? "0")"
        discountPriceALbel.text = variant.discountValue ?? "0"
        finalPriceLabel.text = "AED \(variant.finalPrice ?? "0")"

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

        // SIZES BASED ON SELECTED VARIANT
//        sizesList = variant.size ?? []
        sizeCollectionView.reloadData()

        // SPECIFICATIONS
        
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
            return 5
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
                
                let images = selectedVariant?.variantImage ?? []
                if images.count > indexPath.row {
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
            cell.titleLabel.text = sizesList[indexPath.row].name
            if selectedSizeIndex == indexPath.row {
                cell.mainView.layer.borderColor = UIColor.darkBrown.cgColor
            } else {
                cell.mainView.layer.borderColor = UIColor.lightGray.cgColor
            }
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case productImageCollectionView:
            print("")
        case colorsCollectionView:
            selectedColourIndex = indexPath.row
                
                let selectedColorId = coloursList[indexPath.row].id
                
                if let variant = productVariants.first(where: { $0.color?.id == selectedColorId }) {
                    selectedVariant = variant
                    updateVariantUI()
                }
                
                colorsCollectionView.reloadData()
        case sizeCollectionView:
            selectedSizeIndex = indexPath.row
            sizeCollectionView.reloadData()
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
            cell.titleLabel.text = "● \(speifcationArray[indexPath.row])"
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
