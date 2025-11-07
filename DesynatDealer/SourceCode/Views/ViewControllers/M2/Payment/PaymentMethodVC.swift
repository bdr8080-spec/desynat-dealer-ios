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
    //var selectedPaymentMethod: PaymentMethod?
    var getFatoorahResponse: MFPaymentStatusResponse?
    var transactionIds: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewCreditCard.isHidden = true
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSelectPaymentMethod(_ sender: Any) {
        viewCreditCard.isHidden = false
        cardPay()
    }
    
    @IBAction func btnPay(_ sender: Any) {
        let invoiceValue = Decimal(payAmount)
        
        let request = MFExecutePaymentRequest(invoiceValue: invoiceValue)
        
//        request.customerReference = self.orderId
//        
//        guard let supplierIDString = self.supplierId,
//              let supplierCode = Int(supplierIDString) else {
//            self.showAlert(msg: "Invalid supplier ID.")
//            return
//        }
//
//        let supplier = MFSupplier(
//            supplierCode: supplierCode, invoiceShare: invoiceValue
//        )
//        request.suppliers = [supplier]
        
        viewPayment.pay(request, .english) { [weak self] response, invoiceId in
            guard let self = self else { return }
            
            switch response {
            case .success(let paymentStatus):
                print("Payment successful with invoiceId: \(invoiceId ?? "N/A")")
                
                let transactionID = paymentStatus.invoiceTransactions?.first?.transactionID ?? ""
                let paymentGateway = paymentStatus.invoiceTransactions?.first?.paymentGateway ?? "card"
                
                completePlanPurchase(transactionId: transactionIds ?? "", paymentStatus: 1, onlineTransactionId: transactionID)
                
                DispatchQueue.main.async {
                    let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
                    vc.comingReason = .planPurchased
                    vc.callBackDismiss = {
                        kSharedSceneDelegate.navigateToDealerHomeVc()
                    }
                    self.present(vc, animated: true)
                }
                
                
                // customerrefence - orderif  or supplier id
//                self.checkOutOrder(transactionId: transactionID, paymentMethod: paymentGateway)
//                self.orderPlaced(with: paymentStatus)
                
            case .failure(let error):
                print("Payment Error: \(error.errorDescription)")
                self.showAlert(msg: "Payment Failed: \(error.errorDescription)")
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
    
