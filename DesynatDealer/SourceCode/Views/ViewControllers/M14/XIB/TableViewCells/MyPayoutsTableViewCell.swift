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
    
    func configData() {
        transactionIdLabel.text = "#923"//"#\(data?.id ?? 0)"
        payoutReceivedLabel.text = formatDate("2024-08-21T07:30:00.000000Z")
//        myEarningLabel.text = CommonUtils.formatPriceStringInput(data?.affiliateCommission)
//        purchasedLabel.text = data?.userDetails?.fullName
//        productNameLabel.text = data?.productDetails?.productNameEn
//        categoryNameLabel.text = data?.productDetails?.category?.name
//        quantityLabel.text = "\(data?.quantity ?? 0)"
//        totalAmountLabel.text = CommonUtils.formatPriceStringInput(data?.amount)
//        purchasedOnLabel.text = formatDate(data?.createdAt ?? "")
//        configureStatus(with: data)
    }
    
    func formatDate(_ isoDate: String) -> String {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = inputFormatter.date(from: isoDate) else {
            return ""
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.timeZone = TimeZone.current
        
        // ✅ Localize month + AM/PM + digits
        if AppLanguageManager.shared.currentLanguage == .ar {
            outputFormatter.locale = Locale(identifier: "ar")
        } else {
            outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        }
        
        outputFormatter.dateFormat = "dd MMM yyyy 'at' hh:mm a"
        
        let localizedAt = "at".localiz()
        
        return outputFormatter
            .string(from: date)
            .replacingOccurrences(of: "at", with: localizedAt)
    }
    
}
