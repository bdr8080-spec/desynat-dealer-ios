//
//  LiveCoverageListTableViewCell.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 13/02/26.
//

import UIKit

class LiveCoverageListTableViewCell: UITableViewCell {

    @IBOutlet weak var statusLabel: CustomLabelFont!
    @IBOutlet weak var cancelRequestView: UIView!
    @IBOutlet weak var rehjectedView: UIView!
    
    var onCancelRequestTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func cancelReuqestDidTappedd(_ sender: Any) {
        onCancelRequestTapped?()
    }
    
}
