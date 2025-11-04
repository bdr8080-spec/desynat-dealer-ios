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
        logoutApi()
    }

    
}

extension AccountCreationDoneViewController{
    func logoutApi(){
        WebService.sharedInstance.logoutService { user in
            kSharedSceneDelegate.logoutUser()
        }
    }
}
