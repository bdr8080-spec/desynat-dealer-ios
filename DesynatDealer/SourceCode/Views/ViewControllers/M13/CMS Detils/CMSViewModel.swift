//
//  CMSViewModel.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 22/04/26.
//


//
//  CMSViewModel.swift
//  DesynatUser
//
//  Created by  shailendra singh on 17/04/26.
//

import Foundation
class CMSViewModel {
    private var hostVC: CMSViewController
    var cmsDetailsData: CMSTermsConditionDataModel?
    
    init(hostVC: CMSViewController) {
        self.hostVC = hostVC
    }
    
    func getReturnPolicyRequest() {
        let param: [String: Any] = ["type": hostVC.selectedUserType]
        WebService.sharedInstance.getReturnPolicyService(parameter: param) { [weak self] response in
            guard let self = self else { return }
            cmsDetailsData = response
            CommonUtils.loadHTMLContent(response.contentEnglish ?? "N/A".localiz(), webView: hostVC.webView)
        }
    }
    
    func getAboutUsRequest() {
        let param: [String: Any] = ["type": hostVC.selectedUserType]
        WebService.sharedInstance.getAboutUsPolicyService(parameter: param) { [weak self] response in
            guard let self = self else { return }
            cmsDetailsData = response
            CommonUtils.loadHTMLContent(response.contentEnglish ?? "N/A".localiz(), webView: hostVC.webView)
        }
    }
    
    func getCancellationPolicyRequest() {
        let param: [String: Any] = ["type": hostVC.selectedUserType]
        WebService.sharedInstance.getCancellationPolicyService(parameter: param) { [weak self] response in
            guard let self = self else { return }
            cmsDetailsData = response
            CommonUtils.loadHTMLContent(response.contentEnglish ?? "N/A".localiz(), webView: hostVC.webView)
        }
    }
    
    func getExchangePolicyRequest() {
        let param: [String: Any] = ["type": hostVC.selectedUserType]
        WebService.sharedInstance.getExchangePolicyService(parameter: param) { [weak self] response in
            guard let self = self else { return }
            cmsDetailsData = response
            CommonUtils.loadHTMLContent(response.contentEnglish ?? "N/A".localiz(), webView: hostVC.webView)
        }
    }
    func getTermsAndConditionRequest() {
        let param: [String: Any] = ["type": hostVC.selectedUserType]
        WebService.sharedInstance.getTermsConditionService(parameter: param) { [weak self] response in
            guard let self = self else { return }
            cmsDetailsData = response
            CommonUtils.loadHTMLContent(response.contentEnglish ?? "N/A".localiz(), webView: hostVC.webView)
        }
    }
}
