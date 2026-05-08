//
//  TicketManagementTableViewCell.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 19/03/26.
//

import UIKit

class TicketManagementTableViewCell: UITableViewCell {

    @IBOutlet weak var resolvedOnStackView: UIStackView!
    @IBOutlet weak var ticketTypeLabel: UILabel!
    @IBOutlet weak var ticketIdLabel: UILabel!
    @IBOutlet weak var raisedOnDateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var resolvedOnDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configData(data: SupportList?) {
        ticketIdLabel.text = data?.ticketID ?? ""
        if AppLanguageManager.shared.currentLanguage == .ar {
            ticketTypeLabel.text = data?.ticketTypeDetails?.nameArabic ?? ""
        } else {
            ticketTypeLabel.text = data?.ticketTypeDetails?.name ?? ""
        }
        raisedOnDateLabel.text = convertServerDate(data?.createdAt ?? "")
        let status = statusType(status: data?.status ?? 0)
        statusLabel.text = status.text.localiz()
        statusLabel.textColor = status.color
        resolvedOnStackView.isHidden = (data?.status != 1)
        resolvedOnDateLabel.text = convertServerDate(data?.updatedAt ?? "")
    }
    
    func statusType(status: Int) -> (text: String, color: UIColor) {
        let state = TicketStatus(rawValue: status)
        return (state?.text ?? "Unknown".localiz(), state?.color ?? .gray)
    }
    
    func convertServerDate(_ isoString: String) -> String {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"

        guard let date = formatter.date(from: isoString) else {
            return isoString
        }

        let outputFormatter = DateFormatter()

        if AppLanguageManager.shared.currentLanguage == .ar {
            outputFormatter.locale = Locale(identifier: "ar")
            outputFormatter.dateFormat = "dd MMM yy، h:mm a"
        } else {
            outputFormatter.locale = Locale(identifier: "en_US_POSIX")
            outputFormatter.dateFormat = "dd MMM yy, h:mm a"
        }

        return outputFormatter.string(from: date)
    }
}




