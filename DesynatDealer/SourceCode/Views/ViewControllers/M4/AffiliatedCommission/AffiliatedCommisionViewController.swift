//
//  AffiliatedCommisionViewController.swift
//  DesynatDealer
//
//  Created by fluper on 05/12/25.
//

import UIKit

class AffiliatedCommisionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

  @IBAction func saveChangesDidTapped(_ sender: Any) {
    let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
    vc.comingReason = .affiliatedCommission
    vc.callBackDismiss = {
      self.navigationController?.popViewController(animated: true)
    }
    self.navigationController?.present(vc, animated: true)
  }
  
  @IBAction func bcakDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
}
