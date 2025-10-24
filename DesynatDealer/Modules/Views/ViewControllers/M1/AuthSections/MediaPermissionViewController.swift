//
//  MediaPermissionViewController.swift
//  DesynatDriver
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit

class MediaPermissionViewController: UIViewController {

    var onPermissionCompletion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func allowDidTapped(_ sender: Any) {
        self.dismiss(animated: true) { [weak self] in
                self?.onPermissionCompletion?()
            }
    }
    
    
    
    @IBAction func denyDidTapped(_ sender: Any) {
        self.dismiss(animated: true) { [weak self] in
                self?.onPermissionCompletion?()
            }
    }
    
  
}
