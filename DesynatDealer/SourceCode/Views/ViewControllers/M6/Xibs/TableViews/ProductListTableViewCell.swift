//
//  ProductListTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper on 17/12/25.
//

import UIKit

class ProductListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var serialNumberLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var colourLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var materialLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
//    func setData(data: OrderData?) {
//      self.nameLabel.text = data?.productDetails?.productNameEn ?? ""
//      self.priceLabel.text = "\(data?.variationDetails?.finalPrice ?? "") KD"
//        self.sizeLabel.text = data?.variationDetails?.size?.name ?? ""
//        self.colourLabel.text = data?.variationDetails?.color?.name ?? ""
//        self.categoryLabel.text = data?.productDetails?.category?.name ?? ""
//        self.quantityLabel.text = data?.quantity?.description
//        self.materialLabel.text = data?.productDetails?.brand?.nameEnglish ?? ""
//        self.productImageView.image = .placeholder
//      if let url = URL(string: data?.variationDetails?.variantImage?.first ?? "") {
//            self.productImageView.sd_setImage(with: url,placeholderImage: .placeholder)
//        }
//    }
}
