//
//  HomeViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnTapLogout(_ sender: UIButton) {
        kSharedSceneDelegate.navigateToSelectLanguage()
        UserDefaults.standard.setValue("No", forKey:"isLogin")
    }
   

}
