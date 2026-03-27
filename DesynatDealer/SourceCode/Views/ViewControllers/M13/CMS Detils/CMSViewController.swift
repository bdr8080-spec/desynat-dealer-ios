//
//  CMSViewController.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 20/03/26.
//

import UIKit

class CMSViewController: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var webView: UIWebView!
    
    var titleText : String?
    var comingReason : ComingFrom?
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = titleText
        initialSetup()
        let htmlString = """
                <html>
                <body>
                <h1>Welcome</h1>
                <p>This is WebView example</p>
                </body>
                </html>
                """
                
                webView.loadHTMLString(htmlString, baseURL: nil)
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func initialSetup(){
        switch comingReason {
        case .aboutUs:
            titleLbl.text = "About Us"
        case .termsAndConditions:
            titleLbl.text = "Terms & Condition"
        case .returnPolicy:
            titleLbl.text = "Return Policy"
        case .cancellationPolicy:
            titleLbl.text = "Cancellation Policy"
        case .exchangePolicy:
            titleLbl.text = "Exchange Policy"
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
