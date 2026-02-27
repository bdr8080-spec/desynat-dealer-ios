//
//  LiveCoverageRequestTableViewCell.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 16/02/26.
//

import UIKit

class LiveCoverageRequestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rejectedOnTitleLabel: CustomLabelFont!
    @IBOutlet weak var requestIDLabel: CustomLabelFont!
    @IBOutlet weak var rejectedDateView: UIView!
    @IBOutlet weak var statusLabel: CustomLabelFont!
    @IBOutlet weak var cancelRequestView: UIView!
    @IBOutlet weak var rejectedView: UIView!
    @IBOutlet weak var requestedOnLabel: CustomLabelFont!
    @IBOutlet weak var liveRequestDateLabel: CustomLabelFont!
    @IBOutlet weak var rejectedDateLabel: CustomLabelFont!
    @IBOutlet weak var rejectedReaonLabel: CustomLabelFont!
    @IBOutlet weak var rejectedREasonTitleLabel: CustomLabelFont!
    
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
    
    func configData(data: LiveCoverageRequestList?) {
        requestIDLabel.text = "#\(data?.orderID ?? 0)"
        requestedOnLabel.text = formatDate(data?.createdAt)
        let adminVerifyStaus = data?.adminVerify ?? 0
        rejectedDateView.isHidden = true
        rejectedView.isHidden = true
        cancelRequestView.isHidden = true
        switch adminVerifyStaus {
        case 3:
            statusLabel.text = "Cancelled"
            statusLabel.textColor = UIColor(hexString: "#D53B36")
            rejectedDateView.isHidden = false
            rejectedView.isHidden = false
            rejectedOnTitleLabel.text = "Cancelled On"
            rejectedREasonTitleLabel.text = "Cancelled Reason"
            rejectedDateLabel.text = formatDate(data?.updatedAt)
            rejectedReaonLabel.text = data?.cancelReason
        case 2:
            statusLabel.text = "Rejected"
            statusLabel.textColor = UIColor(hexString: "#D53B36")
            rejectedDateView.isHidden = false
            rejectedView.isHidden = false
            rejectedOnTitleLabel.text = "Rejected On"
            rejectedREasonTitleLabel.text = "Rejected Reason"
            rejectedDateLabel.text = formatDate(data?.updatedAt)
            rejectedReaonLabel.text = data?.rejectReason
        case 1:
            statusLabel.textColor = UIColor(hexString: "#68CA44")
            var isTimeslotOver = false

            if let timeslot = data?.timeslotDetails,
               let timeslotDate = timeslot.date,
               let toTime = timeslot.to {

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"   // ✅ FIXED
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")

                if let endDate = dateFormatter.date(from: "\(timeslotDate) \(toTime)") {
                    let now = Date()
                    if now >= endDate {
                        isTimeslotOver = true
                    }
                }
            }

            // Update status
            statusLabel.text = isTimeslotOver ? "Completed" : "Confirmed"
        default:
            statusLabel.text = "Pending"
            statusLabel.textColor = UIColor(hexString: "#E28F12")
            cancelRequestView.isHidden = false
        }
        
        liveRequestDateLabel.text = formatDateTime(date: data?.timeslotDetails?.date ?? "", time: data?.timeslotDetails?.from ?? "")
    }
    
    private func formatDate(_ dateString: String?) -> String {
        guard let dateString = dateString else { return "-" }
        
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        
        guard let date = inputFormatter.date(from: dateString) else {
            return dateString
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        outputFormatter.timeZone = TimeZone.current
        outputFormatter.dateFormat = "dd/MM/yyyy 'at' hh:mm a"
        
        return outputFormatter.string(from: date)
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
