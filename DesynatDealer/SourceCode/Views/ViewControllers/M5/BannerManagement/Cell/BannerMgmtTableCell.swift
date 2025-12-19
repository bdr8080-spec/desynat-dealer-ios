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
    
    func configure(with data: BannerModel) {
        if let imageUrlString = data.uploadBanner, let url = URL(string: imageUrlString) {
          imgBanner.sd_imageIndicator = SDWebImageActivityIndicator.gray
          imgBanner.sd_imageIndicator?.startAnimatingIndicator()
          imgBanner.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
          imgBanner.image = UIImage(named: "")
        }
        
        lblRequestedId.text = data.orderID ?? "Nil"
        lblTotalAmount.text = data.price ?? "Nil"
        lblRequestedOn.text = formatDate(data.createdAt)
        
        
        viewBtnPay.isHidden = true
        viewRejectDate.isHidden = true
        viewRejectReason.isHidden = true
        let status = data.adminVerify ?? ""
        
        switch status {
        case "0": //Pending
            lblStatus.text = "Pending"
            lblStatus.textColor = UIColor(hex: "#E28F12")
            viewBtnPay.isHidden = true
            viewRejectDate.isHidden = true
            viewRejectReason.isHidden = true
            
            
        case "1": //Approved
            lblStatus.text = "Approved"
            lblStatus.textColor = UIColor(hex: "#68CA44")
            viewBtnPay.isHidden = false
            viewRejectDate.isHidden = true
            viewRejectReason.isHidden = true
            
        case "2": //Rejected
            lblStatus.text = "Rejected"
            lblStatus.textColor = UIColor(hex: "#D53B36")
            viewBtnPay.isHidden = true
            viewRejectDate.isHidden = false
            viewRejectReason.isHidden = false
            //lblRejectedOn.text = data.re
            lblRejectReason.text = data.cancelledReason ?? "Nil"
        
        default:
            return
        }
    
        
    }
    
    @IBAction func btnPay(_ sender: Any) {
        onPayTap?()
    }
    
    
}

extension BannerMgmtTableCell {
    private func formatDate(_ dateString: String?) -> String {
        guard let dateString = dateString else { return "-" }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "dd MMM yyyy"
            return formatter.string(from: date)
        }
        return dateString
    }
}
