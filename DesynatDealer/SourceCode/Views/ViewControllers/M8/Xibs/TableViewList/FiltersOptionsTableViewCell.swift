//
//  FiltersOptionsTableViewCell.swift
//  DesynatUser
//
//  Created by fluper on 17/11/25.
//

import UIKit

class FiltersOptionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var colourView: CustomView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectionImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(option: StoreFilterOption) {
        titleLabel.text = option.title
        
        let imageName = option.isSelected ? option.seletedImage : option.unselectedImage
        selectionImageView.image = UIImage(named: imageName)
    }
  
  func configureSortBy(option: SortOptionModel?) {
      titleLabel.text = option?.title
      
    let isSlected = option?.isSelected ?? false
      let imageName = isSlected ? "radioSelected" : "radioUnselected"
      selectionImageView.image = UIImage(named: imageName)
  }
    
    func configureProductFilter(option: ProductFilterOption) {
        titleLabel.text = option.title
        
        if option.havingColourCode {
            colourView.isHidden = false
            colourView.backgroundColor = UIColor(hexString: option.colourCode)
        } else {
            colourView.isHidden = true
        }

        selectionImageView.image = UIImage(named: option.isSelected ? "selectedFilterCheckBox" : "unslectedStoreFilter")
    }
  
//  func configureProductFilter(option: ProductFilterOption) {
//      titleLabel.text = option.title
//    selectionImageView.isHidden = !option.isSelected  // ✅ show/hide based on isSelected
//      if option.havingColourCode {
//        colourView.backgroundColor = UIColor(hex: option.colourCode)
//      }
//  }

    
}

