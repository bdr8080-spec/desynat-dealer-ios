//
//  RegisterationSuccessViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit

class RegisterationSuccessViewController: UIViewController {
  
  @IBOutlet weak var descriptionLabel: UILabel!
  
  var comingReason: ComingReasonAtRegisterationSuccess = .passwordUpdated
  var callBackDismiss: (()->())?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initialSetup()
    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
      self.dismiss(animated: true) {
        self.callBackDismiss?()
      }
    }
  }
  
  private func initialSetup() {
    switch comingReason {
    case .passwordUpdated:
      descriptionLabel.text = "Password Reset\nsuccessfully!"
    case .accountCreated:
      descriptionLabel.text = "Thank you for sinning up\nwith DESYNAT"
    case .planPurchased:
      descriptionLabel.text = "Plan purchased successfully!"
    case .bannerPlanPurchased:
      descriptionLabel.text = "Banner plan purchased succesfully!"
    case .affiliatedCommission:
      descriptionLabel.text = "Commisson saved"
    case .sendQuotation:
      descriptionLabel.text = "Request Sent\nsuccessfully!"
    case .modifyQuotation:
      descriptionLabel.text = "Modified\nsuccessfully!"
    }
  }
  
}

enum ComingReasonAtRegisterationSuccess {
  case passwordUpdated
  case accountCreated
  case planPurchased
  case affiliatedCommission
  case bannerPlanPurchased
  case sendQuotation
  case modifyQuotation
}
