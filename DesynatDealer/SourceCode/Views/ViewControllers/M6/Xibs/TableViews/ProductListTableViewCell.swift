//
//  ProductListTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper on 17/12/25.
//

import UIKit

class ProductListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var serialNumberLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var colourLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var perItemPriceLabel: UILabel!
    @IBOutlet weak var materialLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configData(data: OrdersListData?, isCustomOrder: Bool) {
        if AppLanguageManager.shared.currentLanguage == .ar {
            nameLabel.text = data?.productDetails?.productNameAr ?? ""
            self.materialLabel.text = data?.productDetails?.brand?.nameArabic ?? ""
            categoryLabel.text = data?.productDetails?.category?.nameAr ?? ""
            self.sizeLabel.text = data?.variationDetails?.size?.nameAr ?? ""
            self.colourLabel.text = data?.variationDetails?.color?.nameAr ?? ""
        } else {
            nameLabel.text = data?.productDetails?.productNameEn ?? ""
            materialLabel.text = data?.productDetails?.brand?.nameEnglish ?? ""
            categoryLabel.text = data?.productDetails?.category?.name ?? ""
            self.sizeLabel.text = data?.variationDetails?.size?.name ?? ""
            self.colourLabel.text = data?.variationDetails?.color?.name ?? ""
        }
        let totalPrice = (Double(data?.variationDetails?.finalPrice ?? "") ?? 0)
        * Double(data?.quantity ?? 1)
        
        
        
        //    self.perItemPriceLabel.text = data?.variationDetails?.finalPrice
//        self.sizeLabel.text = data?.variationDetails?.size?.name ?? ""
//        self.colourLabel.text = data?.variationDetails?.color?.name ?? ""
        
        if let url = URL(string: data?.variationDetails?.variantImage?.first ?? "") {
            self.productImageView.sd_setImage(with: url,placeholderImage: UIImage(named: ""))
        }
        if isCustomOrder {
            priceLabel.text = CommonUtils.formatPriceStringInput(data?.chatRoomrecords?.totalAmount)
            quantityLabel.text = "Per Item Price".localiz()
            let priceString = data?.amount ?? "0"
            perItemPriceLabel.text = CommonUtils.formatPriceStringInput(priceString)
        } else {
            priceLabel.text = CommonUtils.formatPrice(totalPrice)
            quantityLabel.text = "Quantity".localiz()
            let priceString = data?.amount ?? "0"
            perItemPriceLabel.text = "\(CommonUtils.formatPriceStringInput(priceString)) x \(data?.quantity ?? 1)"
        }
    }
}
