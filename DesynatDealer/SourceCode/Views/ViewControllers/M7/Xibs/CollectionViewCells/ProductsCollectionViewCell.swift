//
//  ProductsCollectionViewCell.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 22/01/26.
//

import UIKit
import Cosmos
import SDWebImage

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
    
    var wishlistButtonTapped: (() -> Void)?
    var deleteButtonTapped: (() -> Void)?
    var checkboxButtonTapped: (() -> Void)?
    var shareButtonTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainImageView.layer.cornerRadius = 8
        mainImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        mainImageView.layer.masksToBounds = true
        detailsView.layer.cornerRadius = 8
        detailsView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        detailsView.layer.masksToBounds = true
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        wishlistButtonTapped?()
    }
    
    @IBAction func checkboxDidTapped(_ sender: Any) {
        checkboxButtonTapped?()
    }
    
    @IBAction func deleteDidTapped(_ sender: Any) {
        deleteButtonTapped?()
    }
    
    @IBAction func shareDidTapped(_ sender: Any) {
        shareButtonTapped?()
    }
    
    func configData(type: DealsListedType, hasActionPermission: Bool) {
        deleteButton.isHidden = true
        checkboxButton.isHidden = true
        totalSoldView.isHidden = true
        switch type {
        case .listedDeals:
            checkboxButton.isHidden = !hasActionPermission
        case .enrolled:
            deleteButton.isHidden = !hasActionPermission
        case .expired:
            totalSoldView.isHidden = false
        }
    }
    
    func configDealData(data: ProductsList?) {
        if let imageUrlString = data?.productVariants?.first?.variantImage?.first,
           let url = URL(string: imageUrlString) {
            mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            mainImageView.sd_imageIndicator?.startAnimatingIndicator()
            mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
            mainImageView.image = UIImage(named: "")
        }
        titleLabel.text = data?.productNameEn
        if let ratingString = data?.avgProductRating {
            ratingView.rating = Double(Int(ratingString))
            ratingLabel.text = "(\(ratingString))"
        } else {
            ratingView.rating = 0.0
            ratingLabel.text = "(\(0))"
        }
        //        let text = "KD".localiz()
        finalPriceLabel.text = CommonUtils.formatPriceStringInput(data?.productVariants?.first?.finalPrice ?? "")
        CommonUtils.setStrikethrough(label: actualPriceLabel, text: CommonUtils.formatPriceStringInput(data?.productVariants?.first?.actualPrice ?? ""))
        CommonUtils.updateDiscountPercentageLabel(discountPriceLabel,
                                                  actualAmountLabel: actualPriceLabel,
                                                  discountType: data?.productVariants?.first?.discountType,
                                                  discountValue: data?.productVariants?.first?.discountValue)
    }
    
    func configDealDataForAddedProduct(data: AddedProductInDeal?) {
        if let imageUrlString = data?.productDetails?.productVariants?.first?.variantImage?.first,
           let url = URL(string: imageUrlString) {
            mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            mainImageView.sd_imageIndicator?.startAnimatingIndicator()
            mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
            mainImageView.image = UIImage(named: "")
        }
        titleLabel.text = data?.productDetails?.productNameEn
        if let ratingString = data?.productDetails?.avgProductRating {
            ratingView.rating = Double(Int(ratingString))
            ratingLabel.text = "(\(ratingString))"
        } else {
            ratingView.rating = 0.0
            ratingLabel.text = "(\(0))"
        }
        //        let text = "KD".localiz()
        finalPriceLabel.text = CommonUtils.formatPriceStringInput(data?.productDetails?.productVariants?.first?.finalPrice ?? "")
        CommonUtils.setStrikethrough(label: actualPriceLabel, text: CommonUtils.formatPriceStringInput(data?.productDetails?.productVariants?.first?.actualPrice ?? ""))
        CommonUtils.updateDiscountPercentageLabel(discountPriceLabel,
                                                  actualAmountLabel: actualPriceLabel,
                                                  discountType: data?.productDetails?.productVariants?.first?.discountType,
                                                  discountValue: data?.productDetails?.productVariants?.first?.discountValue)
    }
    
}
