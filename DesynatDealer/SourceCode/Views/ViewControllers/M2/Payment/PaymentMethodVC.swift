//
//  PaymentMethodVC.swift
//  DesynatDealer
//
//  Created by fluper on 07/11/25.
//

enum PayFrom {
    case plan
    case banner
    case mySubscriptionPlan
}

import UIKit
import MFSDK

class PaymentMethodVC: UIViewController {
    
    @IBOutlet weak var lblTotalAmt: CustomLabelFont!
    @IBOutlet weak var lblMonth: CustomLabelFont!
    @IBOutlet weak var viewCreditCard: UIView!
    @IBOutlet weak var viewPayment: MFPaymentCardView!
    @IBOutlet weak var cardSelectionImageView: UIImageView!
    
    var payAmount: Double = 0.0
    var getFatoorahResponse: MFPaymentStatusResponse?
    var transactionIds: String?
    var durationOfPlan: String? = ""
    var paymentFrom: PayFrom = .plan
    var paymentTransactionDetails: (transactionID: String, invoiceId: String, paymentGateway: String)?
    var paymentCompleted: Bool = false
    var isCardIsSlecteed: Bool = false
    var selectedPaymentMethodID: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isCardIsSlecteed = true
        lblMonth.text = durationOfPlan
        let text = "KD".localiz()
        switch paymentFrom {
        case .plan:
            lblTotalAmt.text = "\(payAmount) \(text)"
        case .banner:
            lblTotalAmt.text = "\(payAmount) \(text)"
         case .mySubscriptionPlan:
          lblTotalAmt.text = "\(payAmount) \(text)"
        }
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSelectPaymentMethod(_ sender: Any) {
        let supplierId = String(Int.random(in: 1000...9999))
        cardSelectionImageView.image = UIImage(named: "radioSelected")
        isCardIsSlecteed = true
        selectedPaymentMethodID = nil
        if paymentFrom == .plan || paymentFrom == .mySubscriptionPlan {
            creditDebitCardPayment(
                invoiceValue: Decimal(payAmount),
                orderId: transactionIds ?? "",
                supplierId: supplierId
            ) { [weak self] response, invoiceId, error in
                guard let self = self else { return }
                if let err = error {
                    self.showAlert(msg: err.localizedDescription)
                    return
                }
            }
        }
    }
    
    @IBAction func btnPay(_ sender: Any) {
        guard selectedPaymentMethodID != nil || isCardIsSlecteed else {
            showAlert(msg: "Please select a payment option".localiz())
            return
        }
        
        if isCardIsSlecteed {
            switch paymentFrom {
            case .plan, .mySubscriptionPlan :
//                if paymentCompleted, let details = paymentTransactionDetails {
//                    switch paymentFrom {
//                    case .plan:
//                        completePlanPurchase(transactionId: self.transactionIds ?? "", paymentStatus: 1, onlineTransactionId: details.transactionID)
//                    case .banner:
//                        bannerPayment(transactionId: details.transactionID, paymentStatus: 1, order_id: self.transactionIds ?? "")
//                        //                    case .mySubscriptionPlan:
//                        //                        print("Buy SubscriptionPlan")
//                    }
//                } else {
//                    showAlert(msg: "Please complete card payment")
//                }
                let supplierId = String(Int.random(in: 1000...9999))
                cardSelectionImageView.image = UIImage(named: "radioSelected")
                isCardIsSlecteed = true
                selectedPaymentMethodID = nil
//                if paymentFrom == .plan {
                    creditDebitCardPayment(
                        invoiceValue: Decimal(payAmount),
                        orderId: transactionIds ?? "",
                        supplierId: supplierId
                    ) { [weak self] response, invoiceId, error in
                        guard let self = self else { return }
                        if let err = error {
                            self.showAlert(msg: err.localizedDescription)
                            return
                        }
                    }
//                }
                
            case .banner:
                let supplierId = String(Int.random(in: 1000...9999))
                creditDebitCardPayment(
                    invoiceValue: Decimal(payAmount),
                    orderId: transactionIds ?? "",
                    supplierId: supplierId
                ) { [weak self] response, invoiceId, error in
                    guard let self = self else { return }
                    if let err = error {
                        self.showAlert(msg: err.localizedDescription)
                        return
                    }
                }
                //            case .mySubscriptionPlan:
                //                print("SubScription Plan")
            }
            
        }
    }
    
}

extension PaymentMethodVC {
    func updateCardSelectionUI() {
        cardSelectionImageView.image = isCardIsSlecteed
        ? UIImage(named: "radioSelected")
        : UIImage(named: "radioUnselected")
    }
    
    func bannerPayment(transactionId: String, paymentStatus: Int, order_id: String) {
        let params: [String: Any] = [
            "order_id": order_id,
            "payment_status": paymentStatus,
            "transaction_id": transactionId
        ]
        WebService.sharedInstance.bannerPayment(param: params) { result in
            DispatchQueue.main.async {
                let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
                vc.comingReason = .bannerPlanPurchased
                vc.callBackDismiss = {
                    self.navigationController?.popToViewController(ofClass: BannerManagemntVC.self, animated: true)
                }
                self.present(vc, animated: true)
            }
        }
    }
    
    func completePlanPurchase(transactionId: String, paymentStatus:Int, onlineTransactionId: String) {
        let params: [String: Any] = [
            "transaction_id": transactionId,
            "payment_status": paymentStatus,
            "online_transaction_id": onlineTransactionId
        ]
        
        WebService.sharedInstance.completePurchasePlansListService(param: params) { result in
            DispatchQueue.main.async {
                //                                self.stopLoading()
                let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
                vc.comingReason = .planPurchased
                vc.callBackDismiss = {
                    if self.paymentFrom == .mySubscriptionPlan {
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        kSharedSceneDelegate.navigateToDealerHomeVc()
                    }
                }
                self.present(vc, animated: true)
            }
        }
    }
    
    func creditDebitCardPayment(invoiceValue: Decimal,
                                orderId: String,
                                supplierId: String?,
                                completion: @escaping (MFPaymentStatusResponse?, String?, Error?) -> Void) {
        let supplierId = Int.random(in: 1000...9999)
        let request = MFExecutePaymentRequest(invoiceValue: invoiceValue, paymentMethod: 2)
        request.customerReference = orderId
        
        let supplier = MFSupplier(supplierCode: supplierId, invoiceShare: invoiceValue)
        request.suppliers = [supplier]
        request.displayCurrencyIso = .kuwait_KWD
        MFPaymentRequest.shared.executePayment(request: request, apiLanguage: .english) { result, invoiceId in
            switch result {
            case .success(let paymentStatus):
                completion(paymentStatus, invoiceId, nil)
                
                let transactionID = paymentStatus.invoiceTransactions?.first?.transactionID ?? ""
                let paymentGateway = paymentStatus.invoiceTransactions?.first?.paymentGateway ?? "VisaPay".localiz()
                
                DispatchQueue.main.async {
                    self.paymentTransactionDetails = (transactionID, invoiceId ?? "", paymentGateway)
                    self.paymentCompleted = true
                    self.handlePaymentCompletion(transactionID: transactionID, invoiceId: invoiceId ?? "", gateway: paymentGateway)
                    
                }
            case .failure(let error):
                completion(nil, invoiceId,
                           NSError(domain: "", code: 0,
                                   userInfo: [NSLocalizedDescriptionKey: error.errorDescription]))
            }
        }
    }
    
    func paymentDoneWithCard() {
        let invoiceValue = Decimal(payAmount)
        let request = MFExecutePaymentRequest(invoiceValue: invoiceValue)
        request.customerReference = self.transactionIds ?? ""
        let supplierId = Int.random(in: 1000...9999)
        let supplier = MFSupplier(
            supplierCode: supplierId, invoiceShare: invoiceValue
        )
        request.suppliers = [supplier]
        
        viewPayment.pay(request, .english) { [weak self] response, invoiceId in
            guard let self = self else { return }
            
            switch response {
            case .success(let paymentStatus):
                print("Payment successful with invoiceId: \(invoiceId ?? "N/A")")
                let transactionID = paymentStatus.invoiceTransactions?.first?.transactionID ?? ""
                let paymentGateway = paymentStatus.invoiceTransactions?.first?.paymentGateway ?? "card".localiz()
                paymentTransactionDetails = (transactionID, invoiceId ?? "", paymentGateway)
                paymentCompleted = true
                self.handlePaymentCompletion(transactionID: transactionID, invoiceId: invoiceId ?? "", gateway: paymentGateway)
                
                //        viewModel.payForAddingCard(transactionId: transactionID)
            case .failure(let error):
                print("Payment Error: \(error.errorDescription)")
                let text = "Payment Failed:".localiz()
                self.showAlert(msg: "\(text) \(error.errorDescription)")
            }
        }
    }
    
    func didReceivePaymentError(_ message: String) {
        showAlert(msg: message)
    }
    
    func handlePaymentCompletion(transactionID: String, invoiceId: String, gateway: String) {
        paymentTransactionDetails = (transactionID, invoiceId, gateway)
        paymentCompleted = true
        if selectedPaymentMethodID != 3 {
            switch paymentFrom {
            case .plan, .mySubscriptionPlan:
                completePlanPurchase(transactionId: self.transactionIds ?? "", paymentStatus: 1, onlineTransactionId: transactionID)
            case .banner:
                bannerPayment(transactionId: transactionID, paymentStatus: 1, order_id: self.transactionIds ?? "")
            }
        }
    }
    
    func cardPay() {
        var configure = MFCardConfigureBuilder.default
        // but you can create yours
        // set placeholders
        configure.setPlaceholder(MFCardPlaceholder(cardHolderNamePlaceholder: "Name".localiz(), cardNumberPlaceholder: "Number".localiz(), expiryDatePlaceholder: "MM / YY".localiz(), cvvPlaceholder: "CVV".localiz()))
        // set labels
        configure.setLabel(MFCardLabel(cardHolderNameLabel: "Card holder name".localiz(), cardNumberLabel: "Card number".localiz(), expiryDateLabel: "MM / YY".localiz(), cvvLabel: "CVV".localiz(), showLabels: true, fontWeight: .normal))
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

