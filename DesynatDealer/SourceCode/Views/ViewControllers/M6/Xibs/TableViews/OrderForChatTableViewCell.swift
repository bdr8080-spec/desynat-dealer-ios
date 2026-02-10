//
//  OrderForChatTableViewCell.swift
//  DesynatDealer
//
//  Created by fluper on 05/01/26.
//

import UIKit
import SDWebImage

class OrderForChatTableViewCell: UITableViewCell {

  @IBOutlet weak var productImageView: CustomImageView!
  @IBOutlet weak var discountPriceLabel: UILabel!
  @IBOutlet weak var actualPriceLabel: CustomLabelFont!
  @IBOutlet weak var finalPriceLabel: UILabel!
  @IBOutlet weak var productDetailsLabel: UILabel!
  @IBOutlet weak var productNameLabel: UILabel!
  @IBOutlet weak var lblStatus: UILabel!
  
  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
      // Configure the view for the selected state
  }
  
  func configData(data: ProductVariation?) {
    if let imageUrl = data?.variantImage?.first, let url = URL(string: imageUrl) {
      productImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
      productImageView.sd_imageIndicator?.startAnimatingIndicator()
      productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
    } else {
      productImageView.image = UIImage(named: "")
    }
    productNameLabel.text = data?.productDetails?.productNameEn ?? ""
//    let discountType = data?.discountType ?? "1"
//    if discountType == "1" {
//      discountPriceLabel.text = "\(data?.discountValue ?? "")% Off"
//    } else {
//      discountPriceLabel.text = "\(data?.discountValue ?? "") KD Off"
//    }
    
    finalPriceLabel.text = "\(data?.finalPrice ?? "") KD"
    CommonUtils.setStrikethrough(label: actualPriceLabel, text: "\(data?.actualPrice ?? "0") KD")
      
      CommonUtils.updateDiscountPercentageLabel(discountPriceLabel,
                                                actualAmountLabel: actualPriceLabel,
                                                discountType: data?.discountType,
                                                discountValue: data?.discountValue)
    //setColorBox(size: data?.size?.name ?? "", label: productDetailsLabel, hexColor: data?.color?.hexCode ?? "#98ADFF", quantity: "1")
    setColorBoxWithoutQuantity(size: data?.size?.name ?? "", label: productDetailsLabel, hexColor: data?.color?.hexCode ?? "#98ADFF")
  }
  
  
    
}
