//
//  MyPlanDetailsViewController.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 18/03/26.
//

import UIKit

class MyPlanDetailsViewController: UIViewController {

    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var paidAmountLabel: UILabel!
    @IBOutlet weak var planButtonTitleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblPlan: UILabel!
    @IBOutlet weak var lblPurchasedOn: UILabel!
    @IBOutlet weak var lblExpiredOn: UILabel!
    @IBOutlet weak var lblTotalAmout: UILabel!
    @IBOutlet weak var lblTransactionId: UILabel!
    @IBOutlet weak var titleView: CustomView!
    
    var planDetails: MySubscriptionPlanList?
    var isToRenewPlan: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topSet()
        configData(data: planDetails)
    }
   
    // MARK: - Navigation
     @IBAction func Backbtn(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
     }
    
    @IBAction func upgradePlanDidTapped(_ sender: Any) {
        renewSubscriptionPlanApi(planId: planDetails?.planInfo?.id ?? 0)
    }
    
    private func topSet(){
        titleView.layer.cornerRadius = 12
        titleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        titleView.clipsToBounds = true
    }
    
    private func configData(data: MySubscriptionPlanList?) {
        let durationText: String
        if let duration = data?.planInfo?.duration, let type = data?.planInfo?.durationType {
            durationText = "\(duration) \(type == 1 ? "Month" : "Years")"
        } else {
            durationText = "N/A"
        }
        lblDuration.text = durationText
        
        if data?.isExpired == "0" {
            statusLabel.text = "Active"
            statusLabel.textColor = .darkBrown
            planButtonTitleLabel.text = "Upgrade Plan"
            isToRenewPlan = false
            buttonView.isHidden = true
        } else {
            statusLabel.text = "Expired"
            statusLabel.textColor = .black
            planButtonTitleLabel.text = "Renew Plan"
            isToRenewPlan = true
            buttonView.isHidden = false
        }
        lblPlan.text = data?.planInfo?.planNameEnglish
        lblPurchasedOn.text = formatDate(data?.createdAt ?? "")
        lblExpiredOn.text = formatDate(data?.planEndDate ?? "")
        lblTotalAmout.text = CommonUtils.formatPriceStringInput("\(data?.planInfo?.price ?? 0)")
        paidAmountLabel.text = CommonUtils.formatPriceStringInput("\(data?.planInfo?.price ?? 0)")
        lblTransactionId.text = data?.transactionID
    }
    
    private func formatDate(_ dateString: String) -> String {
        let inputFormats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'", // ISO with microseconds
            "yyyy-MM-dd HH:mm:ss",        // ISO basic
        ]
        
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        var parsedDate: Date?
        
        for format in inputFormats {
            inputFormatter.dateFormat = format
            
            // Set timezone based on format
            if format.contains("Z") {
                inputFormatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC
            } else {
                inputFormatter.timeZone = TimeZone.current
            }
            
            if let date = inputFormatter.date(from: dateString) {
                parsedDate = date
                break
            }
        }
        
        guard let date = parsedDate else {
            return ""
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yyyy 'at' hh:mm a"
        outputFormatter.locale = Locale(identifier: "en_US")
        outputFormatter.timeZone = TimeZone.current
        
        return outputFormatter.string(from: date)
    }
    
    private func renewSubscriptionPlanApi(planId: Int){
        let param: [String: Any] = ["plan_id" : planId]
        WebService.sharedInstance.renewSubscriptionPlanService(param: param) { (response) in
            let vc = PaymentMethodVC.instantiate(fromAppStoryboard: .Main)
            vc.paymentFrom = .mySubscriptionPlan
            vc.transactionIds = self.planDetails?.transactionID ?? ""
            vc.payAmount = self.planDetails?.planInfo?.price ?? 0
            if let duration = self.planDetails?.planInfo?.duration, let type = self.planDetails?.planInfo?.durationType {
                vc.durationOfPlan = "for \(duration) \(type == 1 ? "Month" : "Years")"
            } else {
                vc.durationOfPlan = "N/A"
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
