//
//  AddVariantTableViewCell.swift
//  DesynatDealer
//
//  Created by fluper on 20/11/25.
//

import UIKit
import SDWebImage
import AVFoundation
import AVKit

protocol AddVariantCellDelegate: AnyObject {
    func removeVariantTapped(from cell: AddVariantTableViewCell)
    func addImageTapped(from cell: AddVariantTableViewCell, at index: Int)
    func innerTableViewHeightChanged(from cell: AddVariantTableViewCell)
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
    
    var mediaTypes: [String] = []      // "image" or "video"
    var localVideoURLs: [URL?] = []    // local video urls for playback
    
    var onColorButtonTap: (() -> Void)?
    var sizesList: [SizeListDataModel] = []
    var selectedColorId: Int? = -1
    var sizeVariants: [SizeVariant] = [SizeVariant()]
    var addedSizeVariantDetails: ((SizeVariant) -> SizeVariant)?
    var onSizeVariantsChanged: (([SizeVariant]) -> Void)?
    var onVariantUpdated: ((Variant) -> Void)?
    
    
    var isWomenIsSelected: Bool = false {
        didSet { sizeVariantTableView.reloadData() }
    }
    var variant = Variant()
    
    private var displayImages: [UIImage?] {
        return [nil] + images
    }
    
    private var displayImageURLs: [String?] {
        return [nil] + imageURLs
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = "Variant 1".localiz()
        registerCell()
        self.sizeVariantTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    deinit {
        // Remove observer
        self.sizeVariantTableView.removeObserver(self, forKeyPath: "contentSize")
        //  print("Observer removed for tblClaimQty contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard keyPath == "contentSize",
              let newSize = change?[.newKey] as? CGSize else { return }
        
        tableViewHeightConstraint.constant = newSize.height
        self.layoutIfNeeded() // 🔥 required
        
        // Notify parent table
        delegate?.innerTableViewHeightChanged(from: self)
    }
    
    func saveVariantData() {
        
        variant.colorId = selectedColorId
        variant.images = images
        variant.imageURLs = imageURLs
        
        variant.mediaTypes = mediaTypes
        variant.localVideoURLs = localVideoURLs
        
        var cleanedSizes: [SizeVariant] = []
        
        let totalRows = sizeVariantTableView.numberOfRows(inSection: 0)
        
        for row in 0..<totalRows {
            let indexPath = IndexPath(row: row, section: 0)
            
            guard let cell = sizeVariantTableView.cellForRow(at: indexPath) as? AddNewSizeVariantTableViewCell else {
                continue // skip non-visible cells
            }
            
            // Update model from cell fields
            cell.saveToModel()
            let model = cell.sizeVariant
            
            // Skip placeholder / empty row
            if let id = model.sizeId, id != -1 {
                cleanedSizes.append(model)
            }
        }
        
        // Update final variant
        variant.sizeVariants = cleanedSizes
        
        //    for (i, s) in cleanedSizes.enumerated() {
        //      print("SIZE \(i + 1) → id: \(s.sizeId ?? 0), qty: \(s.totalStock), price: \(s.actualPrice)")
        //    }
        //    print("--------------------------------")
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
        self.sizesList = sizesList
        
        // Update colorTF only if selectedColorId exists
        if let colorId = self.selectedColorId,
           let color = colorsList.first(where: { $0.id == colorId }) {
            self.colorTF.text = AppLanguageManager.shared.currentLanguage == .ar
            ? (color.nameAr ?? color.name ?? "")
            : (color.name ?? "")
        } else if let firstColor = colorsList.first {
            self.colorTF.text = AppLanguageManager.shared.currentLanguage == .ar
            ? (firstColor.nameAr ?? firstColor.name ?? "")
            : (firstColor.name ?? "")
            self.selectedColorId = firstColor.id
        } else {
            self.colorTF.text = ""
        }
    }
    
    private func showSizeDropdown(from textField: UITextField, for indexPath: IndexPath) {
        let isArabic = AppLanguageManager.shared.currentLanguage == .ar
        let sizesNames = sizesList.map {
            isArabic
            ? ($0.nameAr ?? $0.name ?? "")
            : ($0.name ?? "")
        }
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
        cell.stackView.isHidden = true
//        if indexPath.item == 0 {
//            cell.mainImageView.image = UIImage(named: "dashedBorder")
//            cell.stackView.isHidden = false
//        } else {
//            let realIndex = indexPath.item - 1
//            if realIndex < images.count {
//                cell.mainImageView.image = images[realIndex]
//            } else {
//                cell.mainImageView.image = UIImage(named: "dashedBorder")
//                cell.stackView.isHidden = false
//            }
//        }
        
        if indexPath.item == 0 {
            cell.mainImageView.image = UIImage(named: "dashedBorder")
            cell.stackView.isHidden = false
            cell.playButton.isHidden = true
        } else {
            let realIndex = indexPath.item - 1
            if realIndex < images.count {
                cell.mainImageView.image = images[realIndex]
                if realIndex < mediaTypes.count {
                    cell.playButton.isHidden = mediaTypes[realIndex] != "video"
                } else {
                    cell.playButton.isHidden = true
                }
            } else {
                cell.mainImageView.image = UIImage(named: "dashedBorder")
                cell.stackView.isHidden = false
                cell.playButton.isHidden = true
            }
        }
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.item == 0 {
//            delegate?.addImageTapped(from: self, at: images.count)
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            delegate?.addImageTapped(from: self, at: images.count)
            return
        }
        let realIndex = indexPath.item - 1
        guard realIndex < mediaTypes.count else { return }
        if mediaTypes[realIndex] == "video" {
            guard let videoURL = localVideoURLs[realIndex] else { return }
            let player = AVPlayer(url: videoURL)
            let playerVC = AVPlayerViewController()
            playerVC.player = player
            UIApplication.shared.topViewController()?.present(playerVC,animated: true) {
                player.play()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 164, height: 120)
    }
}

extension AddVariantTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sizeVariants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewSizeVariantTableViewCell", for: indexPath) as! AddNewSizeVariantTableViewCell
        let sizeVar = sizeVariants[indexPath.row]
        if indexPath.row == 0 {
            cell.plusButonOutlet.isHidden = false
        } else {
            cell.plusButonOutlet.isHidden = true
        }
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
        // cell.configure(with: sizeVar)
        if let sizeId = sizeVar.sizeId,
           let sizeModel = self.sizesList.first(where: { $0.id == sizeId }) {
            cell.sizeTF.text = AppLanguageManager.shared.currentLanguage == .ar
            ? (sizeModel.nameAr ?? sizeModel.name ?? "")
            : (sizeModel.name ?? "")
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
        // 1. Validate ALL existing rows
        for row in 0..<sizeVariants.count {
            guard let cell = sizeVariantTableView.cellForRow(at: IndexPath(row: row, section: 0)) as? AddNewSizeVariantTableViewCell else { continue }
            let error = cell.validateFieldsWithErrors(isWomenCategory: isWomenIsSelected)
            if !error.isEmpty {
                let text = "Please fill all required fields in size row".localiz()
                CommonUtils.showToast(message: "\(text) \(row + 1)")
                return
            }
        }
        // 2. Save data of LAST ROW
        let lastIndex = sizeVariants.count - 1
        if let lastCell = sizeVariantTableView.cellForRow(at: IndexPath(row: lastIndex, section: 0)) as? AddNewSizeVariantTableViewCell {
            
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
        // 3. Append new blank variant
        let newSpec = SizeVariant()
        sizeVariants.append(newSpec)
        let newIndexPath = IndexPath(row: sizeVariants.count - 1, section: 0)
        sizeVariantTableView.performBatchUpdates({
            sizeVariantTableView.insertRows(at: [newIndexPath], with: .automatic)
        }) { _ in
            self.sizeVariantTableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
        // 4. Notify parent
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
        guard let indexPath = sizeVariantTableView.indexPath(for: cell) else { return }
        
        // Minimum 1 variant allowed
        guard sizeVariants.count > 1 else { return }
        
        sizeVariants.remove(at: indexPath.row)
        
        sizeVariantTableView.beginUpdates()
        sizeVariantTableView.deleteRows(at: [indexPath], with: .automatic)
        sizeVariantTableView.endUpdates()
        
        // Notify parent table for height update
        delegate?.innerTableViewHeightChanged(from: self)
    }
    
}

extension AddVariantTableViewCell {
    
    func validateFieldsWithErrors() -> String {
        
        func isEmpty(_ text: String?) -> Bool {
            return text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        }
        
        // Variant level checks
        if imageURLs.isEmpty { return "Please upload image".localiz() }
        if isEmpty(colorTF.text) { return "Please select colour".localiz() }
        
        // SIZE LEVEL VALIDATION
        if sizeVariants.isEmpty { return "Please add at least one size".localiz() }
        
        for (index, size) in sizeVariants.enumerated() {
            let indexPath = IndexPath(row: index, section: 0)
            
            guard let sizeCell = sizeVariantTableView.cellForRow(at: indexPath) as? AddNewSizeVariantTableViewCell else {
                continue
            }
            
            let sizeError = sizeCell.validateFieldsWithErrors(isWomenCategory: isWomenIsSelected)
            if !sizeError.isEmpty {
                return sizeError
            }
            
            // Save size data into model
            sizeCell.saveToModel()
            sizeVariants[index] = sizeCell.sizeVariant
        }
        
        return ""
    }
    
}
