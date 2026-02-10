//
//  DealsDetailsViewController.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 22/01/26.
//

import UIKit
import SDWebImage

class DealsDetailsViewController: UIViewController {
    
    @IBOutlet weak var addToDealsButton: CustomButton!
    @IBOutlet weak var noDataFound: UILabel!
    @IBOutlet weak var totalRevenueLabel: CustomLabelFont!
    @IBOutlet weak var descriptionLabel: CustomLabelFont!
    @IBOutlet weak var subCategoryLabel: CustomLabelFont!
    @IBOutlet weak var categoryLabel: CustomLabelFont!
    @IBOutlet weak var discountPercentageLabel: CustomLabelFont!
    @IBOutlet weak var endsOn: CustomLabelFont!
    @IBOutlet weak var startsOnLabel: CustomLabelFont!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var totalRevenueView: CustomView!
    @IBOutlet weak var addMoreProdutsView: UIView!
    @IBOutlet weak var addToDealsView: UIView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var heightOfProductCollectionViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var productsCollectionView: UICollectionView! {
        didSet {
            productsCollectionView.registerCellFromNib(cellID: "ProductsCollectionViewCell")
        }
    }
    
    private lazy var viewModel = DealsDetailsViewModel(hostVC: self)
    var tabType: DealsListedType = .listedDeals
    var dealID: Int? = 0
    private var searchWorkItem: DispatchWorkItem?
    var selectedProductIDs: Set<Int> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        searchTF.delegate = self
        mainImageView.layer.cornerRadius = 8
            mainImageView.layer.maskedCorners = [
                .layerMinXMinYCorner,   // top-left
                .layerMaxXMinYCorner    // top-right
            ]
            mainImageView.clipsToBounds = true
        updateAddToDealsButtonState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.dealDetailsRequest()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCollectionsHeight()
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addMoreDidTapped(_ sender: Any) {
        let nextVC = AddMoreProductsViewController.instantiate(fromAppStoryboard: .OrderAndChat)
        nextVC.dealID = viewModel.dealData?.id
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func addToDealsDidTapped(_ sender: Any) {
        guard !selectedProductIDs.isEmpty else {
            self.showAlert(msg: "Please select at least one product.")
            return
        }
        let selectedIDsArray = Array(selectedProductIDs)
        viewModel.addProductsRequest(ids: selectedIDsArray)
    }
    
    func updateCollectionsHeight() {
        heightOfProductCollectionViewConstraint.constant =
            productsCollectionView.collectionViewLayout.collectionViewContentSize.height
    }

    func updateAddToDealsButtonState() {
        let isEnabled = !selectedProductIDs.isEmpty
        addToDealsButton.isEnabled = isEnabled
        addToDealsButton.alpha = isEnabled ? 1.0 : 0.5
    }
    
    func initialSetup() {
        addToDealsView.isHidden = true
        addMoreProdutsView.isHidden = true
        totalRevenueView.isHidden = true
        switch tabType {
        case .listedDeals:
            addToDealsView.isHidden = false
        case .enrolled:
            addMoreProdutsView.isHidden = false
        case .expired:
            totalRevenueView.isHidden = false
        }
    }
    
    func configDealData() {
        guard let data = viewModel.dealData else { return }
        if let imageUrlString = data.image,
           let url = URL(string: imageUrlString) {
            mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            mainImageView.sd_imageIndicator?.startAnimatingIndicator()
            mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
            mainImageView.image = UIImage(named: "")
        }
        
        startsOnLabel.text = friendlyStartDate(from: data.from ?? "")
//        endsOn.text = friendlyStartDate(from: data.to ?? "")
        let fromDate = convertDateFormat(data.from ?? "")
        let endDate = convertDateFormat(data.to ?? "")
        endsOn.text = "\(fromDate) - \(endDate)"
        discountPercentageLabel.text = "\(CommonUtils.formatPriceAmount(data.discount))%"
        categoryLabel.text = data.categoryDetails?.name
//        subCategoryLabel.text = data.subCategoryDetails?.nameEnglish
        subCategoryLabel.text = data.subCategoryDetails?.compactMap({ $0.nameEnglish }).joined(separator: ", ")
        descriptionLabel.text = data.nameEnglish
        //        totalRevenueLabel.text = CommonUtils.formatPrice(data.re, currency: <#T##String#>)
        
        productsCollectionView.reloadData()

            // Important part
            DispatchQueue.main.async {
                self.productsCollectionView.layoutIfNeeded()
                self.updateCollectionsHeight()
            }
    }
    
    func convertDateFormat(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy"

        guard let date = inputFormatter.date(from: dateString) else {
            return ""
        }

        return outputFormatter.string(from: date)
    }
    
    func friendlyStartDate(from isoDate: String) -> String? {
        // 1️⃣ Parse ISO date string
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withFullDate] // yyyy-MM-dd
        guard let date = isoFormatter.date(from: isoDate) else { return nil }
        
        // 2️⃣ Get day, month, year components
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        // 3️⃣ Get month name
        let monthName = DateFormatter().monthSymbols[month - 1] // monthSymbols is 0-based
        
        // 4️⃣ Add ordinal suffix to day
        func ordinal(_ number: Int) -> String {
            let ones = number % 10
            let tens = (number / 10) % 10
            if tens == 1 { return "\(number)th" }
            switch ones {
            case 1: return "\(number)st"
            case 2: return "\(number)nd"
            case 3: return "\(number)rd"
            default: return "\(number)th"
            }
        }
        
        let dayWithOrdinal = ordinal(day)
        
        // 5️⃣ Combine into final string
        return "\(dayWithOrdinal) \(monthName) \(year)"
    }
    
}

extension DealsDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch tabType {
        case .listedDeals:
            return viewModel.remainingProduct?.count ?? 0
        case .enrolled:
            return viewModel.addedProducts?.count ?? 0
        case .expired:
            return viewModel.addedProducts?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ProductsCollectionViewCell",
            for: indexPath
        ) as! ProductsCollectionViewCell
        cell.configData(type: tabType)
        switch tabType {
        case .listedDeals:
            cell.configDealData(data: viewModel.remainingProduct?[indexPath.row])
            let productID = viewModel.remainingProduct?[indexPath.row].id ?? 0

            if selectedProductIDs.contains(productID) {
                cell.checkboxButton.setImage(UIImage(named: "filledCheckbox"), for: .normal)
            } else {
                cell.checkboxButton.setImage(UIImage(named: "checkBox"), for: .normal)
            }
        case .enrolled:
            cell.configDealDataForAddedProduct(data: viewModel.addedProducts?[indexPath.row])
         case .expired:
            cell.configDealDataForAddedProduct(data: viewModel.addedProducts?[indexPath.row])
        }
//        cell.checkboxButtonTapped = { [weak self] in
//            guard let self = self else { return }
//            let productData = self.viewModel.remainingProduct?[indexPath.row]
//            guard let productID = productData?.id else { return }
//            
//            // Toggle selection
//            if self.selectedProductIDs.contains(productID) {
//                self.selectedProductIDs.remove(productID)
//                cell.checkboxButton.setImage(UIImage(named: "filledCheckbox"), for: .normal)
//            } else {
//                self.selectedProductIDs.insert(productID)
//                cell.checkboxButton.setImage(UIImage(named: "checkBox"), for: .normal)
//            }
//        }
        
        cell.checkboxButtonTapped = { [weak self] in
            guard let self = self else { return }
            guard let productID = self.viewModel.remainingProduct?[indexPath.row].id else { return }

            if self.selectedProductIDs.contains(productID) {
                self.selectedProductIDs.remove(productID)
            } else {
                self.selectedProductIDs.insert(productID)
            }
            self.updateAddToDealsButtonState()
            // Reload only this cell
            self.productsCollectionView.reloadItems(at: [indexPath])
        }

        cell.deleteButtonTapped = { [weak self] in
            guard let self = self,
                  let productID = self.viewModel.addedProducts?[indexPath.row].id else { return }
            self.showConfirmationAlert(msg: "Are you sure you want to remove this product?"){ [weak self] in
                guard let self = self else { return }
                self.viewModel.deleteProductsRequest(productIs: productID)
            }
        }
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 10
        let totalSpacing = spacing * 2
        let width = (collectionView.frame.width - totalSpacing) / 2
        switch tabType {
        case .expired:
            return CGSize(width: width, height: 285)
        default:
            return CGSize(width: width, height: 245)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("")
    }
    
}

extension DealsDetailsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            viewModel.dealDetailsRequest()
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}
