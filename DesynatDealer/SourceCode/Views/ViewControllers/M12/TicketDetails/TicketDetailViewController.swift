//
//  TicketDetailViewController.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 20/03/26.
//

import UIKit

class TicketDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation

    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
