//
//  PaymentMethodVC.swift
//  DesynatDealer
//
//  Created by fluper on 07/11/25.
//

import UIKit
import MFSDK

class PaymentMethodVC: UIViewController {

    @IBOutlet weak var lblTotalAmt: CustomLabelFont!
    @IBOutlet weak var lblMonth: CustomLabelFont!
    @IBOutlet weak var viewCreditCard: UIView!
    @IBOutlet weak var viewPayment: MFPaymentCardView!
    
    var payAmount: Double = 0.0
    var getFatoorahResponse: MFPaymentStatusResponse?
    var transactionIds: String?
    var durationOfPlan: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        viewCreditCard.isHidden = true
        cardPay()
        lblMonth.text = durationOfPlan
        lblTotalAmt.text = "AED \(payAmount)"
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSelectPaymentMethod(_ sender: Any) {
//        viewCreditCard.isHidden = false
        
    }
    
    @IBAction func btnPay(_ sender: Any) {
        
//        let invoiceValue = Decimal(payAmount)
//        let request = MFExecutePaymentRequest(invoiceValue: invoiceValue)
//        viewPayment.pay(request, .english) { [weak self] response, invoiceId in
//            guard let self = self else { return }
//            
//            switch response {
//            case .success(let paymentStatus):
//                print("Payment successful with invoiceId: \(invoiceId ?? "N/A")")
//                
//                let transactionID = paymentStatus.invoiceTransactions?.first?.transactionID ?? ""
//                let paymentGateway = paymentStatus.invoiceTransactions?.first?.paymentGateway ?? "card"
//                
//                completePlanPurchase(transactionId: transactionIds ?? "", paymentStatus: 1, onlineTransactionId: transactionID)
//                
//                DispatchQueue.main.async {
//                    let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
//                    vc.comingReason = .planPurchased
//                    vc.callBackDismiss = {
//                        kSharedSceneDelegate.navigateToDealerHomeVc()
//                    }
//                    self.present(vc, animated: true)
//                }
//            case .failure(let error):
//                print("Payment Error: \(error.errorDescription)")
//                let errorMessage = error.errorDescription
//                completePlanPurchase(transactionId: transactionIds ?? "", paymentStatus: 2, onlineTransactionId: "")
////                if errorMessage == "User clicked cancel button" {
//                    self.showAlert(msg: "Payment Cancelled")
//                    self.navigationController?.popViewController(animated: true)
//            }
//        }
        
        
        // create request in advance (no harm)
            let invoiceValue = Decimal(payAmount)
            let request = MFExecutePaymentRequest(invoiceValue: invoiceValue)

            // Validate card fields first using the SDK's validate() method
            viewPayment.validate { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    // Validation passed — proceed with payment
//                    DispatchQueue.main.async {
//                        self.startLoading() // optional: show spinner
//                    }

                    self.viewPayment.pay(request, .english) { [weak self] response, invoiceId in
                        guard let self = self else { return }

                        switch response {
                        case .success(let paymentStatus):
                            print("Payment successful with invoiceId: \(invoiceId ?? "N/A")")

                            let transactionID = paymentStatus.invoiceTransactions?.first?.transactionID ?? ""
                            completePlanPurchase(transactionId: self.transactionIds ?? "",
                                                 paymentStatus: 1,
                                                 onlineTransactionId: transactionID)

                            DispatchQueue.main.async {
//                                self.stopLoading()
                                let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
                                vc.comingReason = .planPurchased
                                vc.callBackDismiss = {
                                    kSharedSceneDelegate.navigateToDealerHomeVc()
                                }
                                self.present(vc, animated: true)
                            }

                        case .failure(let error):
                            print("Payment Error: \(error.errorDescription)")
                            completePlanPurchase(transactionId: self.transactionIds ?? "",
                                                 paymentStatus: 2,
                                                 onlineTransactionId: "")
                            DispatchQueue.main.async {
//                                self.stopLoading()
                                self.showAlert(msg: "Payment Cancelled")
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }

                case .failure(let failError):
                    // Validation failed — show toast / alert
                    DispatchQueue.main.async {
                        // Customize message based on failError if needed
                        self.showAlert(msg: "Please enter valid card details") // your toast method
                    }
                }
            }
    }
    
    
}

extension PaymentMethodVC {
    func completePlanPurchase(transactionId: String, paymentStatus:Int, onlineTransactionId: String) {
        let params: [String: Any] = ["transaction_id": transactionId, "payment_status": paymentStatus, "online_transaction_id": onlineTransactionId]
        WebService.sharedInstance.purchasePlansListService(param: params) { result in
            
        }
    }
    
    func cardPay() {
        var configure = MFCardConfigureBuilder.default
        // but you can create yours
        // set placeholders
        configure.setPlaceholder(MFCardPlaceholder(cardHolderNamePlaceholder: "Name", cardNumberPlaceholder: "Number", expiryDatePlaceholder: "MM / YY", cvvPlaceholder: "CVV"))
        // set labels
        configure.setLabel(MFCardLabel(cardHolderNameLabel: "Card holder name", cardNumberLabel: "Card number", expiryDateLabel: "MM / YY", cvvLabel: "CVV", showLabels: true, fontWeight: .normal))
        // set theme
        let theme = MFCardTheme(inputColor: .black, labelColor: .black, errorColor: .red, borderColor: .black)
        theme.language = .english // select .arabic for rtl vie
        configure.setTheme(theme)
        // set height and margin of card inputs
        configure.setCardInput(MFCardInput(inputHeight: 32, inputMargin: 15))
        
        // set labels and texts font size
        configure.setFontSize(15)
        // set border width
        configure.setBorderWidth(1)
        // set border radius for input fields
        configure.setBorderRadius(8)
        // set the display of card icons
        configure.setHideCardIcon(false)
        // set Font Family
        configure.setFontFamily(.timesNewRoman)
        // set box shadow
        configure.setBoxShadow(MFBoxShadow(hOffset: 0, vOffset: 0, blur: 0, spread: 0, color: .gray))
        
        // create the new configure and assigned to payment card view
        viewPayment.configure = configure.build()
        cardPayInitiation()
    }
    
    func cardPayInitiation() {
        MFPaymentRequest.shared.initiateSession(apiLanguage: .english) { [weak self] response in
            switch response {
            case .success(let session):
                self?.viewPayment.load(initiateSession: session) { bin in
                    print("bin", bin)
                }
            case .failure(let error):
                print(error)
                //self?.showToast(error)
            }
        }
    }
}
    
