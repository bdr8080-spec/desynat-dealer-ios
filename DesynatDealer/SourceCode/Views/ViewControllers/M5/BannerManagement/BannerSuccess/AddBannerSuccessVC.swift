//
//  AddBannerSuccessVC.swift
//  DesynatDealer
//
//  Created by fluper on 18/12/25.
//

import UIKit

class AddBannerSuccessVC: UIViewController {
    
    @IBOutlet weak var thankYouForYourPatienceLabel: CustomLabelFont!
    @IBOutlet weak var descriptionLabel: CustomLabelFont!
    
    var comingReason: ComingReasonAtAddBannerSuccess = .forBanner
    var dismissCallBack: (()->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        thankYouForYourPatienceLabel.text = "Thank you for your patience \nTEAM DESYNAT ".localiz()
        switch comingReason {
        case .forBanner:
            descriptionLabel.text = "Your banner request has been successfully submitted for verification !\n\nOur team is currently reviewing your details please allow 3-4 hour for the verification process to be completed.\n\nyou will be notified once your banner is approved on the desynat platform".localiz()
        case .forStory:
            descriptionLabel.text = "Your story request has been successfully submitted for verification.\n\nOur team is currently reviewing your details. Please allow 3–4 hours for the verification process to be completed.\n\nYou will be notified once your story is approved on the Desynat platform.".localiz()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.dismiss(animated: true) {
                self.dismissCallBack?()
            }
        }
    }

}

enum ComingReasonAtAddBannerSuccess {
    case forBanner
    case forStory
}
