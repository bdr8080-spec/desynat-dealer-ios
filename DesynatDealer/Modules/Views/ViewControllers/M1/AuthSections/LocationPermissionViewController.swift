//
//  LocationPermissionViewController.swift
//  DesynatUser
//
//  Created by Rakhi Kumari on 23/10/25.
//

import UIKit

class LocationPermissionViewController: UIViewController {

    var onPermissionCompletion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func denyDidTapped(_ sender: Any) {
        self.dismiss(animated: true) { [weak self] in
                self?.onPermissionCompletion?()
            }
    }
    
    @IBAction func allowDidTapped(_ sender: Any) {
        self.dismiss(animated: true) { [weak self] in
                self?.onPermissionCompletion?()
            }
    }
    
}
