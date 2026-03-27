//
//  DeleteAccountViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 24/03/26.
//

import UIKit

class DeleteAccountViewController: UIViewController {

    var onYesTapped: (()-> Void)?
   // var comingUserRole: UserRoleType = .normalUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func yesDidTapped(_ sender: Any) {
        onYesTapped?()
        self.dismiss(animated: true)
    }
    
    @IBAction func noDidTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
