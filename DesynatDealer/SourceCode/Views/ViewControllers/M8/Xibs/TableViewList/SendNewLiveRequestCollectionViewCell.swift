//
//  SendNewLiveRequestCollectionViewCell.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 13/02/26.
//

import UIKit

class SendNewLiveRequestCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configData(data: GetTimeSlotsDataModel?) { //10:30 AM TO 11:30 AM
//        titleLabel.text = "\(data?.from ?? "") TO \(data?.to ?? "")"//formatDateTime(date: data?.date ?? "", time: data?.from ?? "")
        
        let fromTime = customizeChangeDateFormatZone(
            inputDate: data?.from ?? "",
            inputFormat: "hh:mm a",
            outputFormat: "h:mm a"
        )

        let toTime = customizeChangeDateFormatZone(
            inputDate: data?.to ?? "",
            inputFormat: "hh:mm a",
            outputFormat: "h:mm a"
        )

        titleLabel.text = "\(fromTime) - \(toTime)"
    }
    
    func customizeChangeDateFormatZone(
        inputDate: String,
        inputFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
        outputFormat: String = "hh:mm a"
    ) -> String {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // ✅ Server timezone (Kuwait)
        inputFormatter.timeZone = TimeZone(identifier: "Asia/Kuwait")
        
        guard let date = inputFormatter.date(from: inputDate) else {
            print("❌ Parse failed: \(inputDate)")
            return ""
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // ✅ Local timezone
        outputFormatter.timeZone = TimeZone.current
        
        return outputFormatter.string(from: date)
    }

}
