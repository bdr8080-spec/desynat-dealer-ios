//
//  OTPViewModel.swift
//  DesynatDealer
//
//  Created by Mohd Faizan on 30/10/25.
//

import Foundation
import UIKit

class OTPViewModel:NSObject{
    private var hostVC:OTPViewController

    init(hostVC: OTPViewController) {
        self.hostVC = hostVC
    }
    
    //Mark:->otpVerificationAPi
    func otpVerificationAPi(){
        let param:[String:Any] = [
            APIKeys.userId:hostVC.userId,
            APIKeys.otp:hostVC.otpDigits,
            APIKeys.type:hostVC.type
        ]
        WebService.sharedInstance.otpVerificationService(withParams:param) { user in
            if self.hostVC.comingReason == .signup{
                let vc = StoreInformationViewController.instantiate(fromAppStoryboard: .Main)
                vc.userId = user.id ?? 0
                self.hostVC.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = ResetPasswordViewController.instantiate(fromAppStoryboard: .Main)
                self.hostVC.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
