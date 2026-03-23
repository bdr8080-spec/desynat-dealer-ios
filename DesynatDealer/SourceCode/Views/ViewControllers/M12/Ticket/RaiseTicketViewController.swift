//
//  RaiseTicketViewController.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 19/03/26.
//

import UIKit

class RaiseTicketViewController: UIViewController {
    
    
    @IBOutlet weak var titleView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Navigation
    
    @IBAction func crossBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    func setUpUI(){
        
        titleView.layer.cornerRadius = 24
        titleView.layer.maskedCorners = [
            .layerMinXMinYCorner, // top-left
            .layerMaxXMinYCorner  // top-right
        ]
        titleView.clipsToBounds = true
    }
    
}
