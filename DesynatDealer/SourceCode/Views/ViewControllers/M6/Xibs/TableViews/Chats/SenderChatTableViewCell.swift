//
//  SenderChatTableViewCell.swift
//  DesynatDealer
//
//  Created by fluper on 05/01/26.
//

import UIKit

class SenderChatTableViewCell: UITableViewCell {

  @IBOutlet weak var messageView: UIView!
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
    messageView.layer.cornerRadius = 12
    messageView.layer.maskedCorners = [ .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    messageView.layer.masksToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configData(data: Chat?) {
        messageLabel.text = data?.message
      if let date = data?.getCreatedOn() {
          self.timeLabel.text = date.change_DateIntoString(format: .dd_MMM_yy_h_mm_a)
      }
    }
    
}
