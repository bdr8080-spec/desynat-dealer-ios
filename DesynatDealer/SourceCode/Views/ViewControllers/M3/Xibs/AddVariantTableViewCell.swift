//
//  AddVariantTableViewCell.swift
//  DesynatDealer
//
//  Created by fluper on 20/11/25.
//

import UIKit
import SDWebImage

class AddVariantTableViewCell: UITableViewCell {
    
  
  @IBOutlet weak var priceView: CustomView!
  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    weak var delegate: AddVariantCellDelegate?
    var images: [UIImage?] = [nil]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerCell()
    }
    
    private func registerCell() {
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        imagesCollectionView.register(UINib(nibName: "ProductDetailImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductDetailImageCollectionViewCell")
    }
  
  
  @IBAction func deleteDidTapped(_ sender: Any) {
    delegate?.removeVariantTapped(from: self)
  }
  
  func scrollToLastItem() {
          let lastIndex = images.count - 1
          if lastIndex >= 0 {
              imagesCollectionView.scrollToItem(at: IndexPath(item: lastIndex, section: 0), at: .right, animated: true)
          }
      }
}

extension AddVariantTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductDetailImageCollectionViewCell", for: indexPath) as! ProductDetailImageCollectionViewCell
      cell.mainImageView.layer.cornerRadius = 12
        if let image = images[indexPath.item] {
            cell.mainImageView.image = image
        } else {
            cell.mainImageView.image = UIImage(named: "uploadImages")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.addImageTapped(from: self, at: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let spacing: CGFloat = 10
//        let width = (collectionView.frame.width - spacing) / 2
        return CGSize(width: 162, height: 120)
    }
}



protocol AddVariantCellDelegate: AnyObject {
  func removeVariantTapped(from cell: AddVariantTableViewCell)
  func addImageTapped(from cell: AddVariantTableViewCell, at index: Int)
}

struct VariantImage {
    var image: UIImage?    // selected image
    var isPlaceholder: Bool  // true if this cell is a placeholder
}
