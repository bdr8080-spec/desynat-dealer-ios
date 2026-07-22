//
//  StoryDetailsViewController.swift
//  DesynatDealer
//
//  Created by fluper_mac2 on 14/07/26.
//

import UIKit
import SDWebImage

class StoryDetailsViewController: UIViewController {
    
    @IBOutlet weak var rejectedReasonLabel: CustomLabelFont!
    @IBOutlet weak var rejectedReasonView: UIView!
    @IBOutlet weak var rejectedDateLabel: CustomLabelFont!
    @IBOutlet weak var rejectedDateView: UIView!
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var lblRequestedId: CustomLabelFont!
    @IBOutlet weak var lblRequestedDate: CustomLabelFont!
    @IBOutlet weak var lblRequestedStatus: CustomLabelFont!
    @IBOutlet weak var lblFromDate: CustomLabelFont!
    @IBOutlet weak var lblTotalPrice: CustomLabelFont!
    @IBOutlet weak var viewBtnPay: CustomButton!
    
    var story: StoryRequestList?
    var hasActionPermission: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setData()
    }
    
    private func setupUI() {
        imgBanner.layer.cornerRadius = 8
        imgBanner.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imgBanner.layer.masksToBounds = true
    }
    
    func setData() {
        let data = story
        if let imgUrl = data?.file, let url = URL(string: imgUrl) {
            imgBanner.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imgBanner.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
            imgBanner.image = UIImage(named: "")
        }
        imgBanner.enableFullscreenZoom()
        
        lblRequestedId.text = "#\(data?.id ?? 0)"
        lblRequestedDate.text = formatBannerDate(data?.createdAt)
        rejectedDateLabel.text = formatBannerDate(data?.updatedAt)
        rejectedReasonLabel.text = data?.rejectReason ?? "Nil".localiz()
        
        let adminStatus = data?.adminVerify ?? ""
        let paymentStatus = data?.paymentStatus ?? ""
        
        //Status
        switch adminStatus {
        case "0": //Pending
            lblRequestedStatus.text = "Pending".localiz()
            lblRequestedStatus.textColor = UIColor(hex: "#E28F12")
            viewBtnPay.isHidden = true
            rejectedReasonView.isHidden = true
            rejectedDateView.isHidden = true
        case "1": //Approved
            switch paymentStatus {
            case "0":
                lblRequestedStatus.text = "Confirmed".localiz()
                lblRequestedStatus.textColor = UIColor(hex: "#68CA44")
                viewBtnPay.isHidden = !hasActionPermission
                rejectedReasonView.isHidden = true
                rejectedDateView.isHidden = true
            case "1":
                let today = Calendar.current.startOfDay(for: Date())
                let startDate = apiDate(data?.startDate)
                let endDate = apiDate(data?.endDate)
                
                if let start = startDate, let end = endDate {
                    
                    if today < start {
                        // ✅ Future banner
                        lblRequestedStatus.text = "Confirmed".localiz()
                        lblRequestedStatus.textColor = UIColor(hex: "#68CA44")
                        
                    } else if isDate(today, between: start, and: end) {
                        // ✅ Currently active
                        lblRequestedStatus.text = "Active".localiz()
                        lblRequestedStatus.textColor = UIColor(hex: "#C4A176")
                        
                    } else if today > end {
                        // ✅ Expired banner
                        lblRequestedStatus.text = "Expired".localiz()
                        lblRequestedStatus.textColor = UIColor(hex: "#9E9E9E")
                    }
                    
                } else {
                    // Fallback
                    lblRequestedStatus.text = "Confirmed".localiz()
                    lblRequestedStatus.textColor = UIColor(hex: "#68CA44")
                }
                
                viewBtnPay.isHidden = true
                rejectedReasonView.isHidden = true
                rejectedDateView.isHidden = true
            case "2":
                lblRequestedStatus.text = "Rejected".localiz()
                lblRequestedStatus.textColor = UIColor(hex: "#D53B36")
                viewBtnPay.isHidden = true
                rejectedReasonView.isHidden = false
                rejectedDateView.isHidden = false
            default:
                return
            }
            
        case "2": //Rejected
            lblRequestedStatus.text = "Rejected".localiz()
            lblRequestedStatus.textColor = UIColor(hex: "#D53B36")
            viewBtnPay.isHidden = true
            rejectedReasonView.isHidden = false
            rejectedDateView.isHidden = false
        default:
            return
        }

        lblFromDate.text = formatDate(data?.startDate)
        lblTotalPrice.text = CommonUtils.formatPriceStringInput(data?.amount ?? "0")
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPay(_ sender: Any) {
        let vc = PaymentMethodVC.instantiate(fromAppStoryboard: .Main)
        vc.storyId = story?.id ?? 0
        vc.paymentFrom = .storyManagementPayment
//        vc.transactionIds = story?.orderID ?? ""
        vc.payAmount = Double(story?.amount ?? "") ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
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
    
}
