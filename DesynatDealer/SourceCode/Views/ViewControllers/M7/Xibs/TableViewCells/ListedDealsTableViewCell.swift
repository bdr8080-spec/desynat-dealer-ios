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
        case .expired:
            detailsStackView.isHidden = false
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
        fromLabel.text = friendlyStartDate(from: data?.to ?? "")
        addedOnLabel.text = data?.sellerDealCount?.description
        
        // Example Usage:
        if let status = categorizeDeal(from: data?.from ?? "", to: data?.to ?? "") {
            switch status {
            case .upcoming:
                statusLabel.text = "Upcoming"
                statusLabel.textColor = .black
            case .active:
                statusLabel.text = "Active"
                statusLabel.textColor = UIColor(hex: "#A27D57")
            case .expired:
                statusLabel.text = "Expired"
                statusLabel.textColor = .red
            }
        }
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
    
    func categorizeDeal(from fromDateString: String, to toDateString: String) -> DealStatus? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withFullDate] // yyyy-MM-dd
        
        guard let fromDate = isoFormatter.date(from: fromDateString),
              let toDate = isoFormatter.date(from: toDateString) else {
            return nil
        }
        
        let currentDate = Date()
        
        if currentDate < fromDate {
            return .upcoming
        } else if currentDate >= fromDate && currentDate <= toDate {
            return .active
        } else {
            return .expired
        }
    }




}

enum DealStatus {
    case upcoming
    case active
    case expired
}

