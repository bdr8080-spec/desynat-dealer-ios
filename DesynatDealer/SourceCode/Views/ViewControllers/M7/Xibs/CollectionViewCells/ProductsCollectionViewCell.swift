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
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//
//        mainImageView.image = nil
//        titleLabel.text = nil
//        ratingLabel.text = "(0)"
//        ratingView.rating = 0
//        finalPriceLabel.text = nil
//        actualPriceLabel.text = nil
//        discountPriceLabel.text = nil
//        totalSoldLabel.text = nil
//
//        deleteButton.isHidden = true
//        checkboxButton.isHidden = true
//        totalSoldView.isHidden = true
//    }
    
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
        if let ratingString = data?.avgProductRating {//, let rating = Double(ratingString) {
            ratingView.rating = Double(Int(ratingString))
//            let ratingInt = Int(ratingString) ?? 0
            ratingLabel.text = "(\(ratingString))"
        } else {
            ratingView.rating = 0.0 // default value if conversion fails
            ratingLabel.text = "(\(0))"
        }

        finalPriceLabel.text = "\(data?.productVariants?.first?.finalPrice ?? "") KD"
        CommonUtils.setStrikethrough(label: actualPriceLabel, text: "\(data?.productVariants?.first?.actualPrice ?? "") KD")
//        let discountType = data?.productVariants?.first?.discountType ?? "1"
//        if discountType == "1" {
//          discountPriceLabel.text = "\(data?.productVariants?.first?.discountValue ?? "")% Off"
//        } else {
//            discountPriceLabel.text = "\(data?.productVariants?.first?.discountValue ?? "") KD Off"
//        }
        
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
        if let ratingString = data?.productDetails?.avgProductRating { //}, let rating = Double(ratingString) {
            ratingView.rating = Double(Int(ratingString))
//            let ratingInt = Int(ratingString) ?? 0
            ratingLabel.text = "(\(ratingString))"
        } else {
            ratingView.rating = 0.0 // default value if conversion fails
            ratingLabel.text = "(\(0))"
        }

        finalPriceLabel.text = "\(data?.productDetails?.productVariants?.first?.finalPrice ?? "") KD"
        CommonUtils.setStrikethrough(label: actualPriceLabel, text: "\(data?.productDetails?.productVariants?.first?.actualPrice ?? "") KD")
        //    iscountPriceLabel.text = "\(data?.productVariants?.first?.discountValue ?? "") KD"
//        let discountType = data?.productDetails?.productVariants?.first?.discountType ?? "1"
//        if discountType == "1" {
//            discountPriceLabel.text = "\(data?.productDetails?.productVariants?.first?.discountValue ?? "")% Off"
//        } else {
//            discountPriceLabel.text = "\(data?.productDetails?.productVariants?.first?.discountValue ?? "") KD Off"
//        }
        
        CommonUtils.updateDiscountPercentageLabel(discountPriceLabel,
                                                  actualAmountLabel: actualPriceLabel,
                                                  discountType: data?.productDetails?.productVariants?.first?.discountType,
                                                  discountValue: data?.productDetails?.productVariants?.first?.discountValue)
    }

}
