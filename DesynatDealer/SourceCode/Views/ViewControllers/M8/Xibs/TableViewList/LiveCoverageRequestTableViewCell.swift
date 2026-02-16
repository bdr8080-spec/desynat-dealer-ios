//
//  LiveCoverageRequestTableViewCell.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 16/02/26.
//

import UIKit

class LiveCoverageRequestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var requestIDLabel: CustomLabelFont!
    @IBOutlet weak var rejectedDateView: UIView!
    @IBOutlet weak var statusLabel: CustomLabelFont!
    @IBOutlet weak var cancelRequestView: UIView!
    @IBOutlet weak var rejectedView: UIView!
    @IBOutlet weak var requestedOnLabel: CustomLabelFont!
    @IBOutlet weak var liveRequestDateLabel: CustomLabelFont!
    @IBOutlet weak var rejectedDateLabel: CustomLabelFont!
    @IBOutlet weak var rejectedReaonLabel: CustomLabelFont!
    
    var onCancelRequest: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func cancelDidTapped(_ sender: Any) {
        onCancelRequest?()
    }
}
