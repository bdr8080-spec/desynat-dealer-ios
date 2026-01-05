//
//  FiltersOptionsTableViewCell.swift
//  DesynatDealer
//
//  Created by fluper on 05/01/26.
//

import UIKit

class FiltersOptionsTableViewCell: UITableViewCell {

  @IBOutlet weak var mainImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func updateSelection(_ isSelected: Bool) {
          if isSelected {
              mainImageView.image = UIImage(named: "filledCheckbox")
          } else {
              mainImageView.image = UIImage(named: "checkBox")
          }
      }
    
}
