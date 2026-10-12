//
//  PaymentsHistoryTableViewCell.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 02/03/26.
//

import UIKit

class PaymentsHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var totalCommissionStackView: UIStackView!
    @IBOutlet weak var transactionIdLabel: CustomLabelFont!
    @IBOutlet weak var dateAndTimeLabel: CustomLabelFont!
    @IBOutlet weak var customerNameLabel: CustomLabelFont!
    @IBOutlet weak var orderIdLabel: CustomLabelFont!
    @IBOutlet weak var totalAmountLabel: CustomLabelFont!
    @IBOutlet weak var totalComissionLabel: CustomLabelFont!
    @IBOutlet weak var paymentModeLabel: CustomLabelFont!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configAllTransactionData(data: TransactionsPayoutList?) {
        transactionIdLabel.text = "#\(data?.transactionID ?? "")"
        dateAndTimeLabel.text = formatDate(data?.transactionDate ?? "")
        paymentModeLabel.text = data?.transactionLabel
        orderIdLabel.text = "#\(data?.orderID ?? 0)"
        totalAmountLabel.text = CommonUtils.formatPriceStringInput(data?.amount)
        totalComissionLabel.text = CommonUtils.formatPriceStringInput(data?.totalCommission)
        if let totalCommission = data?.totalCommission,
           let commissionValue = Double(totalCommission),
           commissionValue > 0 {
            totalCommissionStackView.isHidden = false
        } else {
            totalCommissionStackView.isHidden = true
        }
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
