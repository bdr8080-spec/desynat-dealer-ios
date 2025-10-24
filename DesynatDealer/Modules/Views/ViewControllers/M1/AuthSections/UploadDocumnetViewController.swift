//
//  UploadDocumnetViewController.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit

class UploadDocumnetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitDidTapped(_ sender: Any) {
        let vc = AccountCreationDoneViewController.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }


}
