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
        let result = convertISOToDMY(data?.createdAt ?? "") ?? ""
        joinedOnLabel.text = "Joined on \(result)"
        let liveDateresult = convertDate(data?.timeslotDetails?.date ?? "")
        liveDateLabel.text = "Live Timing \(liveDateresult)"
        livetimeLabel.text = data?.timeslotDetails?.from ?? ""
        countryNameLabel.text = data?.timeslotDetails?.countryInfo?.name ?? ""
        let isLive = isEventLive(
                dateString: data?.timeslotDetails?.date,
                fromTime: data?.timeslotDetails?.from,
                toTime: data?.timeslotDetails?.to
            )
            
            watchLiveButton.isUserInteractionEnabled = isLive
            watchLiveButton.alpha = isLive ? 1.0 : 0.5   // dim when disabled
    }
    
//    func isEventLive(dateString: String?, fromTime: String?, toTime: String?) -> Bool {
//        
//        guard let dateString = dateString,
//              let fromTime = fromTime,
//              let toTime = toTime else { return false }
//        
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        
//        // ✅ Your API format
//        formatter.dateFormat = "yyyy-MM-dd hh:mm a"
//        
//        // ✅ Set Kuwait timezone (VERY IMPORTANT)
//        let kuwaitTimeZone = TimeZone(identifier: "Asia/Kuwait")!
//        formatter.timeZone = kuwaitTimeZone
//        
//        let fromDateString = "\(dateString) \(fromTime)"
//        let toDateString = "\(dateString) \(toTime)"
//        
//        guard let startDate = formatter.date(from: fromDateString),
//              let endDate = formatter.date(from: toDateString) else {
//            print("Date parsing failed")
//            return false
//        }
//        // ✅ Convert current device time to Kuwait time
//        let now = Date()
//        let nowInKuwait = Date(
//            timeInterval: TimeInterval(kuwaitTimeZone.secondsFromGMT(for: now)),
//            since: now
//        )
//        
//        print("Start:", startDate)
//        print("End:", endDate)
//        print("Now (Kuwait):", nowInKuwait)
//        
//        return nowInKuwait >= startDate && nowInKuwait <= endDate
//    }
//
    func isEventLive(dateString: String?, fromTime: String?, toTime: String?) -> Bool {
            guard let dateString = dateString,
                  let fromTime = fromTime,
                  let toTime = toTime else { return false }
     
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd hh:mm a"  // <-- IMPORTANT (12 hr + AM/PM)
     
            let startString = "\(dateString) \(fromTime)"
            let endString = "\(dateString) \(toTime)"
     
            guard let startDate = formatter.date(from: startString),
                  let endDate = formatter.date(from: endString) else {
                print("Parsing failed for:", startString, endString)
                return false
            }
     
            let now = Date()
            return now >= startDate && now <= endDate
        }
     
    private func convertISOToDMY(_ isoString: String) -> String? {
        // ISO8601 parser
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        // Parse to Date
        guard let date = isoFormatter.date(from: isoString) else {
            return nil
        }
        
        // Output formatter
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy"
        
        return outputFormatter.string(from: date)
    }
    
    func convertDate(_ input: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "M/dd/yy"  // → 2/08/25 format

        if let date = inputFormatter.date(from: input) {
            return outputFormatter.string(from: date)
        }

        return input  // fallback
    }

}
