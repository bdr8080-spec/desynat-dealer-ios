//
//  ChangePassowrdViewModel.swift
//  DesynatUser
//
//  Created by Mohd Faizan on 07/11/25.
//

import Foundation
import UIKit

class ChangePassowrdViewModel:NSObject{
    private var hostVC:ChangePassowrdViewController
    
    init(hostVC: ChangePassowrdViewController) {
        self.hostVC = hostVC
    }
    
    func changePasswordApi(){
        let param:[String:Any] = [
            "old_password":self.hostVC.txtOldPassword.text ?? "",
            "new_password":self.hostVC.txtNewPass.text ?? "",
            "confirm_password":self.hostVC.txtConfirmPass.text ?? ""
        ]
        WebService.sharedInstance.changePasswordService(param : param) { user in
            self.hostVC.navigationController?.popViewController(animated: true)
        }
    }
}
