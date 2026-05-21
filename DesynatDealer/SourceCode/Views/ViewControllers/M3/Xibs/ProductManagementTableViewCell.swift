//
//  ProductManagementTableViewCell.swift
//  DesynatDealer
//
//  Created by fluper on 19/11/25.
//

import UIKit
import SDWebImage
import Cosmos

class ProductManagementTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var colorsCollectionView: UICollectionView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var orifinalPriceLabel: UILabel!
    @IBOutlet weak var dirscountPriceLabel: CustomLabelFont!
    @IBOutlet weak var discuntPercentageLabel: UILabel!
    @IBOutlet weak var productImageView: CustomImageView!
    @IBOutlet weak var addedOnDateLaebl: UILabel!
    
    var onStatusToggle: (() -> Void)?
    var coloursList: [ColorsLisDataModel]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        colorsCollectionView.delegate = self
        colorsCollectionView.dataSource = self
        colorsCollectionView.registerCellFromNib(cellID: "ColorsCollectionViewCell")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func statusDidTapped(_ sender: Any) {
        onStatusToggle?()
    }
    
    func configData(data: ProductsList) {
        // Safely extract colors from productVariants
        var colorsArray: [ColorsLisDataModel] = []
        if let variants = data.productVariants {
            var seenHexCodes = Set<String>()
            for variant in variants {
                if let color = variant.color, let hex = color.hexCode, !seenHexCodes.contains(hex) {
                    colorsArray.append(color)
                    seenHexCodes.insert(hex)
                }
            }
        }
        self.coloursList = colorsArray
        colorsCollectionView.reloadData()
        ratingView.rating = data.productRating ?? 0
        if AppLanguageManager.shared.currentLanguage == .ar {
            if data.brand?.nameEnglish == "Other" {
                productNameLabel.text = data.otherAr
            } else {
                productNameLabel.text = data.brand?.nameArabic
            }
            descriptionLabel.text = data.productNameAr
        } else {
            if data.brand?.nameEnglish == "Other" {
                productNameLabel.text = data.otherEn
            } else {
                productNameLabel.text = data.brand?.nameEnglish
            }
            descriptionLabel.text = data.productNameEn
        }
        
        let stock = data.stock ?? "In Stock"
        stockLabel.text = " \(stock.localiz()) "
        if let imageUrlString = data.productVariants?.first?.variantImage?.first,
           let url = URL(string: imageUrlString) {
            productImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            productImageView.sd_imageIndicator?.startAnimatingIndicator()
            productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
            productImageView.image = UIImage(named: "")
        }
        
        ratingLabel.text = "(\(data.reviewRating ?? "0"))"
        //      let text1 = "KD".localiz()
        orifinalPriceLabel.text = CommonUtils.formatPriceStringInput(data.productVariants?.first?.finalPrice ?? "")
        CommonUtils.setStrikethrough(label: dirscountPriceLabel, text: CommonUtils.formatPriceStringInput(data.productVariants?.first?.actualPrice ?? ""))
        CommonUtils.updateDiscountPercentageLabel(discuntPercentageLabel,
                                                  actualAmountLabel: dirscountPriceLabel,
                                                  discountType: data.productVariants?.first?.discountType,
                                                  discountValue: data.productVariants?.first?.discountValue)
        if data.productActiveStatus == 1 {
            statusLabel.text = "Active".localiz()
            statusLabel.textColor = UIColor(hex: "1A900D")
            statusButton.setImage(UIImage(named: "toggle_on"), for: .normal)
        } else {
            statusLabel.text = "Inactive".localiz()
            statusLabel.textColor = UIColor(hex: "E80B26")
            statusButton.setImage(UIImage(named: "toggle_off"), for: .normal)
        }
        let text2 = "Added on -".localiz()
        addedOnDateLaebl.text = "\(text2) \(convertDate(data.createdAt ?? ""))"
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
            return "Invalid date".localiz()
        }
    }
}

extension ProductManagementTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coloursList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorsCollectionViewCell", for: indexPath) as! ColorsCollectionViewCell
        if let colorHex = coloursList?[indexPath.item].hexCode {
            cell.mainView.backgroundColor = UIColor(hex: colorHex)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 18, height: 18)
    }
}
