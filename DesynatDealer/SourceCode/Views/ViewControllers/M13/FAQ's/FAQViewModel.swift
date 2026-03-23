//
//  FAQViewModel.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 16/03/26.
//

import Foundation

class FAQViewModel {
    
    private var hostVC: FAQViewController
    var faqListData: [FAQListDataModel]?
    
    init(hostVC: FAQViewController) {
        self.hostVC = hostVC
    }
    
    func getFAQRequest() {
//        let param: [String: Any] = ["type": hostVC.selectedUserType]
//        WebService.shared.getFaqService(parameter: param) { [weak self] response in
//            guard let self = self else { return }
//            faqListData = response
//            hostVC.listTableView.reloadData()
//        }
    }
    
}
