//
//  ReceiverChatTableViewCell.swift
//  DesynatDealer
//
//  Created by fluper on 05/01/26.
//

import UIKit
import FirebaseCore

class ReceiverChatTableViewCell: UITableViewCell {

  @IBOutlet weak var sendUnsendMessageView: UIImageView!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var messageView: UIView!
  @IBOutlet weak var messageLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
    messageView.layer.cornerRadius = 12
    messageView.layer.maskedCorners = [ .layerMinXMinYCorner,.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    messageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configData(data: Chat?) {
        messageLabel.text = data?.message
      if let date = data?.getCreatedOn() {
          self.timeLabel.text = date.change_DateIntoString(format: .h_mm_a)
      }
        
        if data?.read == 0 {
            sendUnsendMessageView.image = .unreadMessage
        } else {
            sendUnsendMessageView.image = .messageRead
        }
        
    }
    
}

