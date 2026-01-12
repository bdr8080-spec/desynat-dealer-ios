//
//  ReciverChatForImageTableViewCell.swift
//  DesynatDealer
//
//  Created by fluper on 12/01/26.
//

import UIKit
import SDWebImage

class ReciverChatForImageTableViewCell: UITableViewCell {

  @IBOutlet weak var mainImageView: CustomImageView!
  @IBOutlet weak var readUnreadMImage: UIImageView!
  @IBOutlet weak var timeLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func configData(data: Chat?) {
    if let imageUrlString = data?.message,
       let url = URL(string: imageUrlString) {
      mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
      mainImageView.sd_imageIndicator?.startAnimatingIndicator()
      mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
    } else {
      mainImageView.image = UIImage(named: "")
    }
    mainImageView.enableFullscreenZoom()
    if let date = data?.getCreatedOn() {
        self.timeLabel.text = date.change_DateIntoString(format: .dd_MMM_yy_h_mm_a)
    }
  }
    
}
