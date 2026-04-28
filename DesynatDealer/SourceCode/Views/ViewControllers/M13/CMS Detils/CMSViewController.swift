//
//  CMSViewController.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 20/03/26.
//

import UIKit
import WebKit

class CMSViewController: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    var titleText : String?
    var comingReason : ComingFrom?
    var selectedUserType = 2
    private lazy var viewmodel = CMSViewModel(hostVC: self)
    var hasActionPermission: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = titleText
        initialSetup()
        webView.scrollView.showsVerticalScrollIndicator = false
    }
    
    // MARK: - Navigation
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
//    func initialSetup(){
//        switch comingReason {
//        case .aboutUs:
//            titleLbl.text = "About Us"
//        
//        case .termsAndConditions:
//            titleLbl.text = "Terms & Condition"
//        case .returnPolicy:
//            titleLbl.text = "Return Policy"
//        case .cancellationPolicy:
//            titleLbl.text = "Cancellation Policy"
//        case .exchangePolicy:
//            titleLbl.text = "Exchange Policy"
//        default:
//            return
//        }
//    }
    
    func initialSetup() {
        switch comingReason {
        case .aboutUs:
            titleLbl.text = "About Us"
            viewmodel.getAboutUsRequest()
        case .termsAndConditions:
            titleLbl.text = "Terms & Condition"
            viewmodel.getTermsAndConditionRequest()
        case .returnPolicy:
            titleLbl.text = "Return Policy"
            viewmodel.getReturnPolicyRequest()
        case .cancellationPolicy:
            titleLbl.text = "Cancellation Policy"
            viewmodel.getCancellationPolicyRequest()
        case .exchangePolicy:
            titleLbl.text = "Exchange Policy"
            viewmodel.getExchangePolicyRequest()
        default:
            return
        }
    }
    
}

enum ComingFrom{
    case aboutUs
    case termsAndConditions
    case returnPolicy
    case cancellationPolicy
    case exchangePolicy
}
