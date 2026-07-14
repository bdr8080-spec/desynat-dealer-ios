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
            descriptionLabel.text = "Password Reset\nsuccessfully!".localiz()
        case .accountCreated:
            descriptionLabel.text = "Thank you for sinning up\nwith DESYNAT".localiz()
        case .planPurchased:
            descriptionLabel.text = "Plan purchased successfully!".localiz()
        case .bannerPlanPurchased:
            descriptionLabel.text = "Banner plan purchased succesfully!".localiz()
        case .affiliatedCommission:
            descriptionLabel.text = "Commisson saved".localiz()
        case .sendQuotation:
            descriptionLabel.text = "Quotation Sent\nsuccessfully!".localiz()
        case .modifyQuotation:
            descriptionLabel.text = "Modified\nsuccessfully!".localiz()
        case .dealAdded:
            descriptionLabel.text = "Items added to deals\nsuccessfully!".localiz()
        case .liveRequest:
            descriptionLabel.text = "Request Sent\nSuccessfully!".localiz()
        case .staffAdded:
            descriptionLabel.text = "Staff is added\nsuccessfully".localiz()
        case .ticketRaised:
            descriptionLabel.text = "Ticket is raised\nsuccessfully".localiz()
        case .storyPlanPurchased:
            descriptionLabel.text = "Plan purchased successfully!".localiz()
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
    case dealAdded
    case liveRequest
    case staffAdded
    case ticketRaised
    case storyPlanPurchased
}
