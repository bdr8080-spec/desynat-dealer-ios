//
//  BannerMgmtTableCell.swift
//  DesynatDealer
//
//  Created by fluper on 18/12/25.
//

import UIKit
import SDWebImage

class BannerMgmtTableCell: UITableViewCell {
    
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var lblRequestedId: CustomLabelFont!
    @IBOutlet weak var lblTotalAmount: CustomLabelFont!
    @IBOutlet weak var lblRequestedOn: CustomLabelFont!
    @IBOutlet weak var lblStatus: CustomLabelFont!
    @IBOutlet weak var lblRejectedOn: CustomLabelFont!
    @IBOutlet weak var lblRejectReason: CustomLabelFont!
    @IBOutlet weak var viewBtnPay: UIView!
    @IBOutlet weak var viewRejectDate: UIView!
    @IBOutlet weak var viewRejectReason: UIView!
    
    var onPayTap: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        imgBanner.layer.cornerRadius = 8
        imgBanner.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imgBanner.layer.masksToBounds = true
    }
    
    func configure(with data: BannerModel, hasActionPermission: Bool) {
        if let imageUrlString = data.uploadBanner, let url = URL(string: imageUrlString) {
          imgBanner.sd_imageIndicator = SDWebImageActivityIndicator.gray
          imgBanner.sd_imageIndicator?.startAnimatingIndicator()
          imgBanner.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
          imgBanner.image = UIImage(named: "")
        }
        
        lblRequestedId.text = data.orderID ?? "Nil".localiz()
//        let text = "KD".localiz()
        lblTotalAmount.text = CommonUtils.formatPriceStringInput(data.price ?? "0")
        lblRequestedOn.text = formatDate(data.createdAt)
        
        
        viewBtnPay.isHidden = true
        viewRejectDate.isHidden = true
        viewRejectReason.isHidden = true
        let adminStatus = data.adminVerify ?? ""
        let paymentStatus = data.paymentStatus ?? ""
        
        switch adminStatus {
        case "0": //Pending
            lblStatus.text = "Pending".localiz()
            lblStatus.textColor = UIColor(hex: "#E28F12")
            viewBtnPay.isHidden = true
            viewRejectDate.isHidden = true
            viewRejectReason.isHidden = true
            
            
        case "1": //Approved
            switch paymentStatus {
            case "0":
                lblStatus.text = "Confirmed".localiz()
                lblStatus.textColor = UIColor(hex: "#68CA44")
                viewBtnPay.isHidden = !hasActionPermission
                viewRejectDate.isHidden = true
                viewRejectReason.isHidden = true
                
            case "1":
//                lblStatus.text = "Active"
//                lblStatus.textColor = UIColor(hex: "#C4A176")
//                viewBtnPay.isHidden = true
//                viewRejectDate.isHidden = true
//                viewRejectReason.isHidden = true
              
              
              let today = Calendar.current.startOfDay(for: Date())
                      let startDate = apiDate(data.startDate)
                      let endDate = apiDate(data.endDate)
                      
                      if let start = startDate, let end = endDate {
                          
                          if today < start {
                              // ✅ Future banner
                              lblStatus.text = "Confirmed".localiz()
                              lblStatus.textColor = UIColor(hex: "#68CA44")
                              
                          } else if isDate(today, between: start, and: end) {
                              // ✅ Currently active
                              lblStatus.text = "Active".localiz()
                              lblStatus.textColor = UIColor(hex: "#C4A176")
                              
                          } else if today > end {
                              // ✅ Expired banner
                              lblStatus.text = "Expired".localiz()
                              lblStatus.textColor = UIColor(hex: "#9E9E9E")
                          }
                          
                      } else {
                          // Fallback
                          lblStatus.text = "Confirmed".localiz()
                          lblStatus.textColor = UIColor(hex: "#68CA44")
                      }
                      
                      viewBtnPay.isHidden = true
                      viewRejectDate.isHidden = true
                      viewRejectReason.isHidden = true
                
            case "2":
                lblStatus.text = "Rejected".localiz()
                lblStatus.textColor = UIColor(hex: "#D53B36")
                viewBtnPay.isHidden = true
                viewRejectDate.isHidden = false
                viewRejectReason.isHidden = false
                //lblRejectedOn.text = data.re
                lblRejectReason.text = data.cancelledReason ?? "Nil".localiz()
                
            default:
                return
            }
            
        case "2": //Rejected
            lblStatus.text = "Rejected".localiz()
            lblStatus.textColor = UIColor(hex: "#D53B36")
            viewBtnPay.isHidden = true
            viewRejectDate.isHidden = false
            viewRejectReason.isHidden = false
            //lblRejectedOn.text = data.re
            lblRejectReason.text = data.cancelledReason ?? "Nil".localiz()
        
        default:
            return
        }
    
        
    }
  
  func isDate(_ date: Date, between startDate: Date, and endDate: Date) -> Bool {
      return (startDate ... endDate).contains(date)
  }

  func apiDate(_ dateString: String?) -> Date? {
      guard let dateString = dateString else { return nil }
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
      formatter.locale = Locale(identifier: "en_US_POSIX")
      return formatter.date(from: dateString)
  }

    
    @IBAction func btnPay(_ sender: Any) {
        onPayTap?()
    }
    
    
}

extension BannerMgmtTableCell {
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
