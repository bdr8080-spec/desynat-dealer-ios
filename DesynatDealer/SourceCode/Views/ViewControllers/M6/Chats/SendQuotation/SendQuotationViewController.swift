//
//  SendQuotationViewController.swift
//  DesynatDealer
//
//  Created by fluper on 06/01/26.
//

import UIKit

class SendQuotationViewController: UIViewController {

  @IBOutlet weak var buttonTitleLabel: UILabel!
  @IBOutlet weak var viewButtonOutlet: UIButton!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var headerView: UIView!
  
  var onQuotationSent: (() -> Void)?
  var comingReason: ComingReasonAtChatScreen = .quotationSentForFirstTime
  private lazy var viewModel = SendQuotationViewModel(hostVC: self)
  
    override func viewDidLoad() {
        super.viewDidLoad()
      handleUISetup()
    }

  @IBAction func dismissDidTapped(_ sender: Any) {
    self.dismiss(animated: true)
  }
  
  @IBAction func confirmAndSendDidTapped(_ sender: Any) {
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
        self.present(vc, animated: true) // ✅ FIX
  }
  
  @IBAction func viewRequestDidTapped(_ sender: Any) {
    let nextVC = ViewRequestViewController.instantiate(fromAppStoryboard: .OrderAndChat)
    self.present(nextVC, animated: true)
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
    }
  }
}
