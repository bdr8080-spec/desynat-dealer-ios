//
//  BannerDetailVC.swift
//  DesynatDealer
//
//  Created by fluper on 18/12/25.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPay(_ sender: Any) {
        let vc = PaymentMethodVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
