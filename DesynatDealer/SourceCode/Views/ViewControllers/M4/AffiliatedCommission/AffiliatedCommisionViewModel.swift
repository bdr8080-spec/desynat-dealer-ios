//
//  AffiliatedCommisionViewModel.swift
//  DesynatDealer
//
//  Created by fluper on 06/12/25.
//

import Foundation

class AffiliatedCommisionViewModel {
  
  private var hostVC: AffiliatedCommisionViewController
  
  init(hostVC: AffiliatedCommisionViewController) {
    self.hostVC = hostVC
  }
  
  func updateAffiliated() {
    let param: [String: Any] = ["affilate_commission": hostVC.commissionTF.text ?? ""]
      WebService.sharedInstance.updateAffiliated(param: param){ response in
        DispatchQueue.main.async {
          let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
          vc.comingReason = .affiliatedCommission
          vc.callBackDismiss = {
            self.hostVC.navigationController?.popViewController(animated: true)
          }
          self.hostVC.navigationController?.present(vc, animated: true)
        }

      }
  }
  
  func validCommissionFields() -> Bool {
    var errorMessage: AlertConstant = .none
    let commission = String.getString(hostVC.commissionTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
    if commission.isEmpty {
      errorMessage = .EnterComission
    }
    if errorMessage != .none {
      hostVC.showAlert(msg: errorMessage.rawValue)
    }
    hostVC.view.endEditing(true)
    return errorMessage == .none
  }
  
}
