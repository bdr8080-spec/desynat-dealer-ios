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
    
    func configData(data: GetTimeSlotsDataModel?) {
        titleLabel.text = formatDateTime(date: data?.date ?? "", time: data?.from ?? "")
    }
    
    func formatDateTime(date: String, time: String) -> String? {
        let combined = "\(date) \(time)"
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let dateObject = inputFormatter.date(from: combined) else {
            return nil
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy 'at' hh:mm a"
        
        return outputFormatter.string(from: dateObject)
    }

}
