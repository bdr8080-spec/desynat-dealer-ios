//
//  AddBannerSuccessVC.swift
//  DesynatDealer
//
//  Created by fluper on 18/12/25.
//

import UIKit

class AddBannerSuccessVC: UIViewController {
    
    var dismissCallBack: (()->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.dismiss(animated: true) {
                self.dismissCallBack?()
            }
        }
    }

}
