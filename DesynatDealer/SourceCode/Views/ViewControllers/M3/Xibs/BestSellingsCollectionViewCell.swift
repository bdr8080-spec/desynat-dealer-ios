//
//  BestSellingsCollectionViewCell.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit

class BestSellingsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var orginalPriceLabel: CustomLabelFont!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        mainImageView.layer.cornerRadius = 8
        mainImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        mainImageView.clipsToBounds = true
        }

}
