//
//  BannerDetailVC.swift
//  DesynatDealer
//
//  Created by fluper on 18/12/25.
//

import UIKit
import SDWebImage

class BannerDetailVC: UIViewController {

    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var lblRequestedId: CustomLabelFont!
    @IBOutlet weak var lblRequestedDate: CustomLabelFont!
    @IBOutlet weak var lblRequestedStatus: CustomLabelFont!
    @IBOutlet weak var lblBannerPosition: CustomLabelFont!
    @IBOutlet weak var lblFromDate: CustomLabelFont!
    @IBOutlet weak var lblToDate: CustomLabelFont!
    @IBOutlet weak var lblTotalDays: CustomLabelFont!
    @IBOutlet weak var lblTotalPrice: CustomLabelFont!
    @IBOutlet weak var viewBtnPay: CustomButton!
    @IBOutlet weak var viewSubCategory: UIView!
    @IBOutlet weak var lblSubCategory: CustomLabelFont!
    
    var banners: BannerModel?
    
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
        let data = banners
        if let imgUrl = data?.uploadBanner, let url = URL(string: imgUrl) {
            imgBanner.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imgBanner.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        } else {
            imgBanner.image = UIImage(named: "")
        }
        
        lblRequestedId.text = data?.orderID ?? "Nil"
        lblRequestedDate.text = formatBannerDate(data?.createdAt)
        
        let adminStatus = data?.adminVerify ?? ""
        let paymentStatus = data?.paymentStatus ?? ""
        
        //Status
        switch adminStatus {
        case "0": //Pending
            lblRequestedStatus.text = "Pending"
            lblRequestedStatus.textColor = UIColor(hex: "#E28F12")
            viewBtnPay.isHidden = true

        case "1": //Approved
            switch paymentStatus {
            case "0":
                lblRequestedStatus.text = "Confirmed"
                lblRequestedStatus.textColor = UIColor(hex: "#68CA44")
                viewBtnPay.isHidden = false
              
            case "1":
//                lblRequestedStatus.text = "Active"
//                lblRequestedStatus.textColor = UIColor(hex: "#C4A176")
//                viewBtnPay.isHidden = true
              
              let today = Calendar.current.startOfDay(for: Date())
              let startDate = apiDate(data?.startDate)
              let endDate = apiDate(data?.endDate)
                      
                      if let start = startDate, let end = endDate {
                          
                          if today < start {
                              // ✅ Future banner
                            lblRequestedStatus.text = "Confirmed"
                            lblRequestedStatus.textColor = UIColor(hex: "#68CA44")
                              
                          } else if isDate(today, between: start, and: end) {
                              // ✅ Currently active
                            lblRequestedStatus.text = "Active"
                            lblRequestedStatus.textColor = UIColor(hex: "#C4A176")
                              
                          } else if today > end {
                              // ✅ Expired banner
                            lblRequestedStatus.text = "Expired"
                            lblRequestedStatus.textColor = UIColor(hex: "#9E9E9E")
                          }
                          
                      } else {
                          // Fallback
                        lblRequestedStatus.text = "Confirmed"
                        lblRequestedStatus.textColor = UIColor(hex: "#68CA44")
                      }
                      
              viewBtnPay.isHidden = true
                
            case "2":
                lblRequestedStatus.text = "Rejected"
                lblRequestedStatus.textColor = UIColor(hex: "#D53B36")
                viewBtnPay.isHidden = true
                
            default:
                return
            }
            
        case "2": //Rejected
            lblRequestedStatus.text = "Rejected"
            lblRequestedStatus.textColor = UIColor(hex: "#D53B36")
            viewBtnPay.isHidden = true
        
        default:
            return
        }
        
        viewSubCategory.isHidden = true
        // Banner position
        switch data?.bannerPosition {
        case "1":
            lblBannerPosition.text = "Home Top"
        case "2":
            lblBannerPosition.text = "Home Banner"
        case "3":
            viewSubCategory.isHidden = false
            lblBannerPosition.text = "Category"
            lblSubCategory.text = data?.subcategoryDetails?.nameEnglish ?? ""
        default:
            lblBannerPosition.text = "Nil"
        }
        
        lblFromDate.text = formatDate(data?.startDate)
        lblToDate.text = formatDate(data?.endDate)
        lblTotalDays.text = data?.totalDays ?? "0"
        lblTotalPrice.text = "\(data?.price ?? "0") KD"
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPay(_ sender: Any) {
        let vc = PaymentMethodVC.instantiate(fromAppStoryboard: .Main)
        vc.paymentFrom = .banner
        vc.transactionIds = banners?.orderID ?? ""
        vc.payAmount = Int(banners?.price ?? "") ?? 0
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
