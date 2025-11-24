//
//  ProductManagementTableViewCell.swift
//  DesynatDealer
//
//  Created by fluper on 19/11/25.
//

import UIKit

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
//    usernameLabel.text = data.fullName
//    if let imageUrlString = data.profileImage,
//       let url = URL(string: imageUrlString) {
//      mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
//      mainImageView.sd_imageIndicator?.startAnimatingIndicator()
//      mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "userProfile"))
//    } else {
//      mainImageView.image = UIImage(named: "userProfile")
//    }
//    
//    locationLabel.text = data.countryInfo?.name
//    let result = convertISOToDMY(data.createdAt ?? "") ?? ""
//    joinedLabel.text = "Joined on \(result)"
//    phoneLabel.text = "\(data.countryCode ?? "")-\(data.mobile ?? "")"
//    emailLabel.text = data.email
//    walletBalanceCount.text = "\(data.walletInfo?.amount ?? "") KD"
////    completedOrderCount.text = data.
//    if data.status == "1" {
//      statusButton.setImage(UIImage(named: "toggleOn"), for: .normal)
//    } else {
//      statusButton.setImage(UIImage(named: "toggleOff"), for: .normal)
//    }
  }
  
}

extension ProductManagementTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorsCollectionViewCell", for: indexPath) as! ColorsCollectionViewCell
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print("")
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 18, height: 18)
  }
}

