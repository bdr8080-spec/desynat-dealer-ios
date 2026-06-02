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
    @IBOutlet weak var playButton: UIButton!
    
    var imageURL: String?
    var videoURL: String?
    
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
    
    func configure(mediaURL: String) {
        guard let url = URL(string: mediaURL) else {
            mainImageView.image = nil
            playButton.isHidden = true
            return
        }
        let ext = url.pathExtension.lowercased()
        if ["mp4", "mov", "m4v", "avi"].contains(ext) {
            playButton.isHidden = false
            videoURL = mediaURL
            CommonUtils.generateThumbnail(url: url) { image in
                DispatchQueue.main.async {
                    self.mainImageView.image = image
                }
            }
        } else {
            playButton.isHidden = true
            videoURL = nil
            mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            mainImageView.sd_setImage(with: url)
        }
    }
    
}
