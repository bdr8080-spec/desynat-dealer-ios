//
//  ReelsCollectionViewCell.swift
//  DesynatDealer
//
//  Created by fluper on 05/12/25.
//

import UIKit
import SDWebImage

class ReelsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var playButton: UIImageView!
    @IBOutlet weak var mainImageView: CustomImageView!
    private var currentVideoURL: URL?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - In ReelsCollectionViewCell
//    func configData(data: GetMyReelsList?) {
//        mainImageView.image = nil
//        mainImageView.contentMode = .scaleAspectFill
//        
//        guard let fileURLString = data?.file,
//              let url = URL(string: fileURLString) else {
//            mainImageView.image = UIImage(named: "placeholder")
//            return
//        }
//        
//        if fileURLString.lowercased().hasSuffix(".mp4") || fileURLString.lowercased().contains(".mp4") {
//            // Show placeholder immediately
//            mainImageView.image = UIImage(named: "placeholder")
//            
//            CommonUtils.generateThumbnail(url: url) { [weak self] image in
//                DispatchQueue.main.async {
//                    guard let self = self else { return }
//                    // Only update if this cell is still showing the same video (prevents wrong thumbnail in reused cells)
//                    if self.currentVideoURL == url {   // Add this property (see below)
//                        self.mainImageView.image = image ?? UIImage(named: "placeholder")
//                    }
//                }
//            }
//        } else {
//            // For images - use SDWebImage (uncomment and improve if needed)
//            mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
//        }
//    }
    
    // Add this property in ReelsCollectionViewCell class (at the top with other outlets)
//    private var currentVideoURL: URL?

    // MARK: - Config Function
    func configData(data: GetMyReelsList?) {
        
        // Reset cell state
        mainImageView.image = nil
        playButton.isHidden = true          // Assuming your play button outlet name is playButton
        currentVideoURL = nil
        
        guard let fileURLString = data?.file,
              let url = URL(string: fileURLString) else {
            mainImageView.image = UIImage(named: "placeholder")
            return
        }
        
        let isVideo = fileURLString.lowercased().hasSuffix(".mp4") ||
                      fileURLString.lowercased().contains(".mp4")
        
        if isVideo {
            // VIDEO CASE
            currentVideoURL = url
            
            // Show placeholder immediately for better UX
            mainImageView.image = UIImage(named: "placeholder")
            playButton.isHidden = false
            
            // Generate thumbnail
            CommonUtils.generateThumbnail(url: url) { [weak self] thumbnailImage in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    
                    // Safety check: only update if this cell is still displaying the same video
                    if self.currentVideoURL == url {
                        self.mainImageView.image = thumbnailImage ?? UIImage(named: "placeholder")
                    }
                }
            }
            
        } else {
            // IMAGE CASE
            playButton.isHidden = true
            
            // Load image using SDWebImage (recommended)
            mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            mainImageView.sd_setImage(
                with: url,
                placeholderImage: UIImage(named: "placeholder"),
                options: [.retryFailed, .scaleDownLargeImages]
            )
        }
    }

}
