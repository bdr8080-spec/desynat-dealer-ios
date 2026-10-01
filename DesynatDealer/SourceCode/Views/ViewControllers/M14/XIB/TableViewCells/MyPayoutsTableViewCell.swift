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
    
    func configMyPayoutData(data: MyPayoutDataList?) {
        transactionIdLabel.text = "#\(data?.transactionID ?? "")"
        payoutReceivedLabel.text = formatDate(data?.payoutDate ?? "")
        totalAmountReceivedLabel.text = CommonUtils.formatPriceStringInput(data?.amount)
        totalCommissionLabel.text = CommonUtils.formatPriceStringInput(data?.totalCommission)
    }
    
    func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy 'at' hh:mm a"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = inputFormatter.date(from: dateString) else {
            return dateString
        }

        return outputFormatter.string(from: date)
    }
    
}
