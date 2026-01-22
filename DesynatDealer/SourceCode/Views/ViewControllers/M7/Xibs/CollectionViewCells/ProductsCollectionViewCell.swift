//
//  ProductsCollectionViewCell.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 22/01/26.
//

import UIKit
import Cosmos

class ProductsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var detailsView: CustomView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var finalPriceLabel: UILabel!
    @IBOutlet weak var totalSoldView: CustomView!
    @IBOutlet weak var discountPriceLabel: UILabel!
    @IBOutlet weak var actualPriceLabel: CustomLabelFont!
    @IBOutlet weak var totalSoldLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainImageView.layer.cornerRadius = 8
        mainImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        mainImageView.layer.masksToBounds = true
        detailsView.layer.cornerRadius = 8
        detailsView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        detailsView.layer.masksToBounds = true
    }
    
    func configData(type: DealsListedType) {
        deleteButton.isHidden = true
        checkboxButton.isHidden = true
        totalSoldView.isHidden = true
        switch type {
        case .listedDeals:
            checkboxButton.isHidden = false
        case .enrolled:
            deleteButton.isHidden = false
        case .expired:
            deleteButton.isHidden = false
            totalSoldView.isHidden = false
        }
    }

}
