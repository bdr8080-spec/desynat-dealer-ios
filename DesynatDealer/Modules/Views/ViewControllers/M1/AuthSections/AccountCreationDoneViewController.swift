//
//  AccountCreationDoneViewController.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit

class AccountCreationDoneViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutDidTapped(_ sender: Any) {
        self.navigationController?.popToViewController(ofClass: LoginViewController.self, animated: true)
    }
}
