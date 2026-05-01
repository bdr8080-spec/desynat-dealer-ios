//
//  myPlanTableViewCell.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 18/03/26.
//

import UIKit

class myPlanTableViewCell: UITableViewCell {

    @IBOutlet weak var renewStackView: UIStackView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var titleView: CustomView!
    @IBOutlet weak var lblPurchasedOn: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblPlanType: UILabel!
    
    var onRenewTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topSet()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topSet()
    }
    
    func topSet(){
        titleView.layer.cornerRadius = 12
        titleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        titleView.clipsToBounds = true
    }
    
    @IBAction func renewPlanbtn(_ sender: Any) {
        onRenewTapped?()
    }
    
    func configData(data: MySubscriptionPlanList?, hasActionPermission: Bool) {
        if let type = data?.planInfo?.durationType, type == 1 {
            durationLabel.text = "Monthly".localiz()
        } else {
            durationLabel.text = "Yearly".localiz()
        }
        
        if data?.isExpired == "0" {
            statusLabel.text = "Active".localiz()
            statusLabel.textColor = .darkBrown
            renewStackView.isHidden = true
        } else {
            statusLabel.text = "Expired".localiz()
            statusLabel.textColor = .black
            renewStackView.isHidden = !hasActionPermission
        }
        lblPurchasedOn.text = formatDate(data?.createdAt ?? "")
        lblAmount.text = CommonUtils.formatPriceStringInput("\(data?.planInfo?.price ?? 0)")
        lblPlanType.text = data?.planInfo?.planNameEnglish
    }
    
    func formatDate(_ isoDate: String) -> String {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC
        
        guard let date = inputFormatter.date(from: isoDate) else {
            return ""
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy 'at' hh:mm a"
        outputFormatter.locale = Locale(identifier: "en_US")
        outputFormatter.timeZone = TimeZone.current // convert to device local time
        
        return outputFormatter.string(from: date)
    }
    
}

