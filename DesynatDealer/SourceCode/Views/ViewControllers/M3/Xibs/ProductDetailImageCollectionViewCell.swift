//
//  ProductDetailImageCollectionViewCell.swift
//  DesynatUser
//
//  Created by fluper on 18/11/25.
//

import UIKit
import SDWebImage

class ProductDetailImageCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var mainImageView: UIImageView!
  @IBOutlet weak var stackView: UIStackView!
  
  var imageURL: String?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func configData(variantImageUrl: String) {
    
    if //let imageUrlString = variantImageUrl,
      let url = URL(string: variantImageUrl) {
      mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
      mainImageView.sd_imageIndicator?.startAnimatingIndicator()
      mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
      
    } else {
      mainImageView.image = UIImage(named: "")
    }
//    mainImageView.enableFullscreenZoom()
  }
  
}
