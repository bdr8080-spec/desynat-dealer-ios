//
//  AccountCreationDoneViewController.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit

class AccountCreationDoneViewController: UIViewController {

    @IBOutlet weak var logoutView: UIView!
    
    var comingFromAppWithoutVerified:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        logoutView.isHidden = comingFromAppWithoutVerified
    }
    
    @IBAction func logoutDidTapped(_ sender: Any) {
        self.showConfirmationAlert(msg: "Are you sure you want to logout?"){ [weak self] in
            guard let self = self else { return }
            logoutApi()
        }
    }

    
}

extension AccountCreationDoneViewController{
    func logoutApi(){
        WebService.sharedInstance.logoutService { user in
            kSharedSceneDelegate.logoutUser()
        }
    }
}
