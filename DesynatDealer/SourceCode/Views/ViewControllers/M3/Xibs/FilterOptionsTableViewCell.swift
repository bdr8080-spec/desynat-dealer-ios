//
//  FilterOptionsTableViewCell.swift
//  DesynatDealer
//
//  Created by fluper on 20/11/25.
//

import UIKit

class FilterOptionsTableViewCell: UITableViewCell {

  @IBOutlet weak var selectedImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
