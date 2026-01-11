//
//  ChatInboxTableViewCell.swift
//  DesynatDealer
//
//  Created by fluper on 05/01/26.
//

import UIKit

class ChatInboxTableViewCell: UITableViewCell {

    @IBOutlet weak var messageTypeStatusView: UIView!
    @IBOutlet weak var messageTypeLabel: UILabel!
    @IBOutlet weak var userProfileImageView: CustomImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configData(data: ChatInboxListModel?) {
//        if let imageUrlString = data?.userDetails?.profileImage,
//           let url = URL(string: imageUrlString) {
//          userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
//          userProfileImageView.sd_imageIndicator?.startAnimatingIndicator()
//          userProfileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "userProfile"))
//        } else {
//          userProfileImageView.image = UIImage(named: "userProfile")
//        }
    }
    
}
