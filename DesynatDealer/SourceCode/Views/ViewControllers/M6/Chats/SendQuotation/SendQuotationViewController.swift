//
//  SendQuotationViewController.swift
//  DesynatDealer
//
//  Created by fluper on 06/01/26.
//

import UIKit

class SendQuotationViewController: UIViewController {
    
    @IBOutlet weak var totalAmountTF: UITextField!
    @IBOutlet weak var taxTF: UITextField!
    @IBOutlet weak var shippingFeesTF: UITextField!
    @IBOutlet weak var itemPriceTF: UITextField!
    @IBOutlet weak var buttonTitleLabel: UILabel!
    @IBOutlet weak var viewButtonOutlet: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    
    var onQuotationSent: (() -> Void)?
    var comingReason: ComingReasonAtChatScreen = .quotationSentForFirstTime
    lazy var viewModel = SendQuotationViewModel(hostVC: self)
    var quotationData: Record?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
        setupTextFieldValidation()
        totalAmountTF.isUserInteractionEnabled = false
    }
    
    @IBAction func dismissDidTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func confirmAndSendDidTapped(_ sender: Any) {
        if viewModel.validateQuotationFields() {
            viewModel.modifyQuotationRequest()
        }
    }
    
    @IBAction func viewRequestDidTapped(_ sender: Any) {
        let nextVC = ViewRequestViewController.instantiate(fromAppStoryboard: .OrderAndChat)
        nextVC.quotationData = quotationData
        self.present(nextVC, animated: true)
    }
    
    private func setupTextFieldValidation() {
        let textFields = [itemPriceTF, shippingFeesTF, taxTF]
        textFields.forEach {
            $0?.keyboardType = .numberPad
            $0?.delegate = self
            $0?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    
    private func calculateTotalAmount() {
        let itemPrice = Double(itemPriceTF.text ?? "") ?? 0
        let quantity = Double(viewModel.itemQuantity) ?? 1
        let total = (itemPrice * quantity)
        totalAmountTF.text = CommonUtils.formatPriceWithoutKd(total)
    }
    
    func handleNavigationAfterSuccess() {
        let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
        switch comingReason {
        case .quotationSentForFirstTime:
            vc.comingReason = .sendQuotation
        default:
            vc.comingReason = .modifyQuotation
        }
        vc.callBackDismiss = { [weak self] in
            self?.dismiss(animated: true) {
                self?.onQuotationSent?()
            }
        }
        self.present(vc, animated: true)
    }
    
    private func handleUISetup() {
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
        switch comingReason {
        case .quotationSentForFirstTime:
            titleLabel.text = "Send Quotation"
            buttonTitleLabel.text = "Confirm & Send "
            viewButtonOutlet.isHidden = true
        default:
            titleLabel.text = "Modify Quotation"
            buttonTitleLabel.text = "Confirm & Modify"
            viewButtonOutlet.isHidden = false
            itemPriceTF.text = CommonUtils.formatPriceAmount(quotationData?.price)
            shippingFeesTF.text = CommonUtils.formatPriceAmount(quotationData?.shipping)
            taxTF.text = CommonUtils.formatPriceAmount(quotationData?.tax)
            totalAmountTF.text = CommonUtils.formatPriceAmount(quotationData?.totalAmount)
        }
    }
}

extension SendQuotationViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        
        // Allow only numbers
        if !string.isEmpty && !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) {
            return false
        }
        
        // Max 7 digits
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        return updatedText.count <= 7
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        calculateTotalAmount()
    }
}

extension String {
    func numericValue() -> Double {
        let filtered = self.replacingOccurrences(
            of: "[^0-9.]",
            with: "",
            options: .regularExpression
        )
        return Double(filtered) ?? 0
    }
}
