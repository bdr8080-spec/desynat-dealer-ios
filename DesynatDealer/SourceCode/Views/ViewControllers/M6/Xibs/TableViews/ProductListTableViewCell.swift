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
  @IBOutlet weak var perItemPriceLabel: UILabel!
  @IBOutlet weak var materialLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func configData(data: OrdersListData?) {
    self.nameLabel.text = data?.productDetails?.productNameEn ?? ""
    let totalPrice = (Double(data?.variationDetails?.finalPrice ?? "") ?? 0)
                   * Double(data?.quantity ?? 1)
    priceLabel.text = CommonUtils.formatPrice(totalPrice)
    self.sizeLabel.text = data?.variationDetails?.size?.name ?? ""
    self.colourLabel.text = data?.variationDetails?.color?.name ?? ""
    self.categoryLabel.text = data?.productDetails?.category?.name ?? ""
    self.perItemPriceLabel.text = data?.variationDetails?.finalPrice
    self.sizeLabel.text = data?.variationDetails?.size?.name ?? ""
    self.colourLabel.text = data?.variationDetails?.color?.name ?? ""
    self.materialLabel.text = data?.productDetails?.brand?.nameEnglish ?? ""
    if let url = URL(string: data?.variationDetails?.variantImage?.first ?? "") {
      self.productImageView.sd_setImage(with: url,placeholderImage: UIImage(named: ""))
    }
  }
}
