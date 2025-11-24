//
//  ProductManagementTableViewCell.swift
//  DesynatDealer
//
//  Created by fluper on 19/11/25.
//

import UIKit
import SDWebImage

class ProductManagementTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var colorsCollectionView: UICollectionView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var orifinalPriceLabel: UILabel!
    @IBOutlet weak var dirscountPriceLabel: CustomLabelFont!
    @IBOutlet weak var discuntPercentageLabel: UILabel!
    @IBOutlet weak var productImageView: CustomImageView!
    @IBOutlet weak var addedOnDateLaebl: UILabel!
    
    var onStatusToggle: (() -> Void)?
    var coloursList: [ColorsLisDataModel]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        colorsCollectionView.delegate = self
        colorsCollectionView.dataSource = self
        colorsCollectionView.registerCellFromNib(cellID: "ColorsCollectionViewCell")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func statusDidTapped(_ sender: Any) {
        onStatusToggle?()
    }
    
    func configData(data: ProductsList) {
        coloursList = data.productVariants?.compactMap { $0.color }
        colorsCollectionView.reloadData()
        productNameLabel.text = data.productNameEn
        descriptionLabel.text = data.descriptionEn
        let count = data.stock?.count ?? 0
        if count > 0 {
            stockLabel.text = "In Stock"
        } else {
            stockLabel.text = "Out of Stock"
        }
        if let imageUrlString = data.productVariants?.first?.variantImage?.first,
           let url = URL(string: imageUrlString) {
            productImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            productImageView.sd_imageIndicator?.startAnimatingIndicator()
            productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "userProfile"))
        } else {
            productImageView.image = UIImage(named: "userProfile")
        }
        
        ratingLabel.text = data.reviewRating
        
        orifinalPriceLabel.text = data.productVariants?.first?.finalPrice
        dirscountPriceLabel.text = data.productVariants?.first?.actualPrice
        discuntPercentageLabel.text = data.productVariants?.first?.discountValue
        
        if data.productActiveStatus == 1 {
            statusLabel.text = "Active"
            statusButton.setImage(UIImage(named: "toggleOn"), for: .normal)
        } else {
            statusLabel.text = "Deactive"
            statusButton.setImage(UIImage(named: "toggleOff"), for: .normal)
        }
        
        addedOnDateLaebl.text = "Added on- \(convertDate(data.createdAt ?? ""))"
    }
    
    func convertDate(_ input: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        inputFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy"
        
        if let date = inputFormatter.date(from: input) {
            return outputFormatter.string(from: date)
        } else {
            return "Invalid date"
        }
    }
    
    
}

extension ProductManagementTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coloursList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorsCollectionViewCell", for: indexPath) as! ColorsCollectionViewCell
        if let colorHex = coloursList?[indexPath.item].hexCode {
            cell.mainView.backgroundColor = UIColor(hex: colorHex)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 18, height: 18)
    }
}

