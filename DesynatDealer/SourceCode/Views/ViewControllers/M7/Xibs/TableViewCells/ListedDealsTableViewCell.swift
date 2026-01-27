//
//  ListedDealsTableViewCell.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 22/01/26.
//

import UIKit
import SDWebImage

class ListedDealsTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var statusLabel: CustomLabelFont!
    @IBOutlet weak var addedOnLabel: CustomLabelFont!
    @IBOutlet weak var fromLabel: CustomLabelFont!
    @IBOutlet weak var startsOnLabel: CustomLabelFont!
    @IBOutlet weak var starstFromLabel: CustomLabelFont!
    @IBOutlet weak var listedDealsView: UIView!
    @IBOutlet weak var detailsStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        mainImageView.layer.cornerRadius = 8
        mainImageView.layer.maskedCorners = [
            .layerMinXMinYCorner,   // top-left
            .layerMaxXMinYCorner    // top-right
        ]
        mainImageView.clipsToBounds = true
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configData(type: DealsListedType, data: ListedDeal?) {
        listedDealsView.isHidden = true
        detailsStackView.isHidden = true
        switch type {
        case .listedDeals:
            listedDealsView.isHidden = false
        case .enrolled:
            detailsStackView.isHidden = false
            if let status = categorizeDeal(from: data?.from ?? "", to: data?.to ?? "") {
                statusLabel.isHidden = false
                if status == .upcoming {
                    statusLabel.text = "Upcoming"
                    statusLabel.textColor = .black
                } else {
                    statusLabel.text = "Active"
                    statusLabel.textColor = UIColor(hex: "#A27D57")
                }
            }
        case .expired:
            detailsStackView.isHidden = false
            statusLabel.text = "Expired"
            statusLabel.textColor = .red
        }
        configDealData(data: data)
    }
    
    func configDealData(data: ListedDeal?) {
        if let imageUrlString = data?.image,
           let url = URL(string: imageUrlString) {
            mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            mainImageView.sd_imageIndicator?.startAnimatingIndicator()
            mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
            mainImageView.image = UIImage(named: "")
        }
        
        starstFromLabel.text = "Starts From - \(friendlyStartDate(from: data?.from ?? "") ?? "")"
        startsOnLabel.text = friendlyStartDate(from: data?.from ?? "")
        let fromDate = convertDateFormat(data?.from ?? "")
        let endDate = convertDateFormat(data?.to ?? "")
        fromLabel.text = "\(fromDate) - \(endDate)"
        addedOnLabel.text = data?.sellerDealCount?.description
        
    }
    
    func convertDateFormat(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy"

        guard let date = inputFormatter.date(from: dateString) else {
            return ""
        }

        return outputFormatter.string(from: date)
    }

    
    func friendlyStartDate(from isoDate: String) -> String? {
        // 1️⃣ Parse ISO date string
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withFullDate] // yyyy-MM-dd
        guard let date = isoFormatter.date(from: isoDate) else { return nil }
        
        // 2️⃣ Get day, month, year components
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        // 3️⃣ Get month name
        let monthName = DateFormatter().monthSymbols[month - 1] // monthSymbols is 0-based
        
        // 4️⃣ Add ordinal suffix to day
        func ordinal(_ number: Int) -> String {
            let ones = number % 10
            let tens = (number / 10) % 10
            if tens == 1 { return "\(number)th" }
            switch ones {
            case 1: return "\(number)st"
            case 2: return "\(number)nd"
            case 3: return "\(number)rd"
            default: return "\(number)th"
            }
        }
        
        let dayWithOrdinal = ordinal(day)
        
        // 5️⃣ Combine into final string
        return "\(dayWithOrdinal) \(monthName) \(year)"
    }
    
    func categorizeDeal(from fromDateString: String,
                        to toDateString: String) -> DealStatus? {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current   // local timezone (IST)

        guard let fromDate = formatter.date(from: fromDateString),
              let toDate = formatter.date(from: toDateString) else {
            return nil
        }

        let calendar = Calendar.current
        let now = Date()

        let startOfFromDate = calendar.startOfDay(for: fromDate)

        // End of "to" day → 23:59:59
        let endOfToDate = calendar.date(
            bySettingHour: 23,
            minute: 59,
            second: 59,
            of: toDate
        )!

        if now < startOfFromDate {
            return .upcoming
        }

        if now <= endOfToDate {
            return .active
        }

        // ❌ Do not show expired
        return nil
    }

}

enum DealStatus {
    case upcoming
    case active
    case expired
}

