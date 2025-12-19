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
        
        //Status
        switch data?.adminVerify {
        case "0": //Pending
            lblRequestedStatus.text = "Pending"
            lblRequestedStatus.textColor = UIColor(hex: "#E28F12")
            viewBtnPay.isHidden = true

        case "1": //Approved
            lblRequestedStatus.text = "Approved"
            lblRequestedStatus.textColor = UIColor(hex: "#68CA44")
            viewBtnPay.isHidden = false
            
        case "2": //Rejected
            lblRequestedStatus.text = "Rejected"
            lblRequestedStatus.textColor = UIColor(hex: "#D53B36")
            viewBtnPay.isHidden = true
        
        default:
            return
        }
        
        // Banner position
        switch data?.bannerPosition {
        case "1":
            lblBannerPosition.text = "Home Top"
        case "2":
            lblBannerPosition.text = "Home Banner"
        case "3":
            lblBannerPosition.text = "Category"
        default:
            lblBannerPosition.text = "Nil"
        }
        
        lblFromDate.text = formatDate(data?.startDate)
        lblToDate.text = formatDate(data?.endDate)
        lblTotalDays.text = data?.totalDays ?? "0"
        lblTotalPrice.text = "\(data?.price ?? "0")"
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPay(_ sender: Any) {
        let vc = PaymentMethodVC.instantiate(fromAppStoryboard: .Main)
        vc.transactionIds = banners?.orderID ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
