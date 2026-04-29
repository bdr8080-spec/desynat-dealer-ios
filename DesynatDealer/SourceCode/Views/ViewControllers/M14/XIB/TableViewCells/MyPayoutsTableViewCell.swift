//
//  MyPayoutsTableViewCell.swift
//  DesynatDealer
//
//  Created by fluper_mac2 on 29/04/26.
//

import UIKit

class MyPayoutsTableViewCell: UITableViewCell {

    @IBOutlet weak var fromLabel: CustomLabelFont!
    @IBOutlet weak var toLabel: CustomLabelFont!
    @IBOutlet weak var transactionIdLabel: CustomLabelFont!
    @IBOutlet weak var payoutReceivedLabel: CustomLabelFont!
    @IBOutlet weak var totalAmountReceivedLabel: CustomLabelFont!
    @IBOutlet weak var totalCommissionLabel: CustomLabelFont!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
