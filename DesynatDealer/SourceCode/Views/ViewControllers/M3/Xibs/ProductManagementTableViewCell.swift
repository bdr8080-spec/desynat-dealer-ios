//
//  ProductManagementTableViewCell.swift
//  DesynatDealer
//
//  Created by fluper on 19/11/25.
//

import UIKit

class ProductManagementTableViewCell: UITableViewCell {
  
  @IBOutlet weak var colorsCollectionView: UICollectionView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    colorsCollectionView.delegate = self
    colorsCollectionView.dataSource = self
    colorsCollectionView.registerCellFromNib(cellID: "ColorsCollectionViewCell")
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
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

