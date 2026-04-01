//
//  SelectVideoFromGalleryCollectionViewCell.swift
//  DesynatAdmin
//
//  Created by fluper on 07/01/26.
//

import UIKit

class SelectVideoFromGalleryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var mainImageView: CustomImageView!
  @IBOutlet weak var playPauseImageView: UIImageView!
  
  private let overlayView: UIView = {
         let view = UIView()
         view.backgroundColor = UIColor.black.withAlphaComponent(0.2) // 10% black
         view.translatesAutoresizingMaskIntoConstraints = false
         view.isUserInteractionEnabled = false
         return view
     }()

     override func awakeFromNib() {
         super.awakeFromNib()
         setupOverlay()
     }

     private func setupOverlay() {
       mainImageView.addSubview(overlayView)
         NSLayoutConstraint.activate([
             overlayView.leadingAnchor.constraint(equalTo: mainImageView.leadingAnchor),
             overlayView.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor),
             overlayView.topAnchor.constraint(equalTo: mainImageView.topAnchor),
             overlayView.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor)
         ])
     }

}
