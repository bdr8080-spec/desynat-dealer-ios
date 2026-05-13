//
//  EventsTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 20/03/26.
//

import UIKit
import SDWebImage

class EventsTableViewCell: UITableViewCell {

    @IBOutlet weak var watchLiveButton: CustomButton!
    @IBOutlet weak var userProfileImageView: CustomImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var joinedOnLabel: UILabel!
    @IBOutlet weak var liveDateLabel: UILabel!
    @IBOutlet weak var livetimeLabel: UILabel!
    
    var onWatchLiveSelect: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func watchLiveDidTapped(_ sender: Any) {
        onWatchLiveSelect?()
    }
    
    func configData(data: ShowLiveEvenetsDataModel?) {
        usernameLabel.text = "\(data?.sellerDetails?.firstName ?? "") \(data?.sellerDetails?.lastName ?? "")"
        if let imageUrlString = data?.sellerDetails?.profilePic,
           let url = URL(string: imageUrlString) {
            userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            userProfileImageView.sd_imageIndicator?.startAnimatingIndicator()
            userProfileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "userProfile"))
        } else {
            userProfileImageView.image = UIImage(named: "userProfile")
        }
        
        let fromtime = customizeChangeDateFormatZone(
            inputDate: data?.timeslotDetails?.from ?? "",
            inputFormat: "hh:mm a",
            outputFormat: "h:mm a"
        )
        
        let result = convertISOToDMY(data?.createdAt ?? "") ?? ""
        let text = "Joined on".localiz()
        joinedOnLabel.text = "\(text) \(result)"
//        let liveDateresult = convertDate(data?.timeslotDetails?.date ?? "")
//        liveDateLabel.text = "Live Timing \(liveDateresult)"
        let liveDateresult = convertDate(data?.timeslotDetails?.date ?? "")
        let text1 = "Live Timing".localiz()
        liveDateLabel.text = "\(text1) \(liveDateresult)"
        livetimeLabel.text = fromtime
        countryNameLabel.text = data?.timeslotDetails?.countryInfo?.name ?? ""
//        let isLive = isEventLive(
//                dateString: data?.timeslotDetails?.date,
//                fromTime: data?.timeslotDetails?.from,
//                toTime: data?.timeslotDetails?.to
//            )
//            
//            watchLiveButton.isUserInteractionEnabled = isLive
//            watchLiveButton.alpha = isLive ? 1.0 : 0.5   // dim when disabled
        
        let isLive = isEventLive(
            dateString: data?.timeslotDetails?.date,
            fromTime: data?.timeslotDetails?.from,
            toTime: data?.timeslotDetails?.to
        )

        watchLiveButton.isUserInteractionEnabled = isLive
        watchLiveButton.alpha = isLive ? 1.0 : 0.5
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
    
    func isEventLive(dateString: String?, fromTime: String?, toTime: String?) -> Bool {
        guard let dateString = dateString,
              let fromTime = fromTime,
              let toTime = toTime else { return false }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        // ✅ Server timezone (Kuwait)
        formatter.timeZone = TimeZone(identifier: "Asia/Kuwait")
        formatter.dateFormat = "yyyy-MM-dd hh:mm a"

        let startString = "\(dateString) \(fromTime)"
        let endString = "\(dateString) \(toTime)"

        guard let startDate = formatter.date(from: startString),
              let endDate = formatter.date(from: endString) else {
//            print("Parsing failed:", startString, endString)
            return false
        }

        let now = Date() // local time but comparable correctly via absolute Date

        return now >= startDate && now <= endDate
    }
    
    func convertDate(_ input: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // ✅ Server timezone (Kuwait)
        inputFormatter.timeZone = TimeZone(identifier: "Asia/Kuwait")
        inputFormatter.dateFormat = "yyyy-MM-dd"

        guard let date = inputFormatter.date(from: input) else {
            return input
        }

        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // ✅ Local timezone
        outputFormatter.timeZone = TimeZone.current
        outputFormatter.dateFormat = "dd/MM/yyyy"

        return outputFormatter.string(from: date)
    }
    
    private func convertISOToDMY(_ isoString: String) -> String? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let date = isoFormatter.date(from: isoString) else {
            return nil
        }

        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        outputFormatter.timeZone = TimeZone.current   // ✅ LOCAL TIME
        outputFormatter.dateFormat = "dd/MM/yyyy"

        return outputFormatter.string(from: date)
    }
     
//    private func convertISOToDMY(_ isoString: String) -> String? {
//        // ISO8601 parser
//        let isoFormatter = ISO8601DateFormatter()
//        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
//        
//        // Parse to Date
//        guard let date = isoFormatter.date(from: isoString) else {
//            return nil
//        }
//        
//        // Output formatter
//        let outputFormatter = DateFormatter()
//        outputFormatter.dateFormat = "dd/MM/yyyy"
//        
//        return outputFormatter.string(from: date)
//    }
    
//    func convertDate(_ input: String) -> String {
//        let inputFormatter = DateFormatter()
//        inputFormatter.dateFormat = "yyyy-MM-dd"
//        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
//
//        let outputFormatter = DateFormatter()
//        outputFormatter.dateFormat = "M/dd/yy"  // → 2/08/25 format
//
//        if let date = inputFormatter.date(from: input) {
//            return outputFormatter.string(from: date)
//        }
//
//        return input  // fallback
//    }

}
