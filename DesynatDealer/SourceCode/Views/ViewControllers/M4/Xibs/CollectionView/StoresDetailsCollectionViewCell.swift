//
//  StoresDetailsCollectionViewCell.swift
//  DesynatDealer
//
//  Created by fluper on 05/12/25.
//

import UIKit
import SDWebImage

class StoresDetailsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configData(data: GetHighLightsList?){
        let fileString = data?.highlights?.first?.file ?? ""
        let thumbnailString = data?.highlights?.first?.thumbnail ?? ""

        // Detect video
        let isVideo = fileString.lowercased().contains(".mp4")

        // Decide which URL to load
        let finalURLString = isVideo ? thumbnailString : fileString
        let url = URL(string: finalURLString)

        // Loader
        mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        mainImageView.sd_imageIndicator?.startAnimatingIndicator()

        // Set image
        mainImageView.sd_setImage(
            with: url,
            placeholderImage: UIImage(named: "placeholder")
        )
        lblTitle.text = data?.title
    }

}
