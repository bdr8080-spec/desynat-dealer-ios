//
//  PaymentsViewController.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit

class PaymentsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logoutDidTapped(_ sender: Any) {
        self.showConfirmationAlert(msg: "Are you sure you want to logout?"){ [weak self] in
            guard let self = self else { return }
                    kSharedSceneDelegate.logoutUser()
        }
    }

}
