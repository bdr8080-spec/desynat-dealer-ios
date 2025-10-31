//
//  SummaryViewModel.swift
//  DesynatDealer
//
//  Created by Mohd Faizan on 31/10/25.
//

import Foundation
import UIKit

class SummaryViewModel:NSObject{
    private var hostVC:SummaryViewController
    
    init(hostVC: SummaryViewController) {
        self.hostVC = hostVC
    }
    
    //Mark:->SummaryAPi
    func getSummaryApi(userId:String){
        let param:[String:Any] = [APIKeys.userId:userId]
        
        WebService.sharedInstance.summaryService(withParams:param) { user in
            self.hostVC.imgPersonalInfo.sd_setImage(with:URL(string:user.profilePic ?? ""), placeholderImage:nil)
            self.hostVC.lblFullName.text = "\(user.firstName ?? "") \(user.lastName ?? "")"
            self.hostVC.lblPhoneNumber.text = user.mobile
            self.hostVC.lblMailId.text = user.email
            
            self.hostVC.imgPersonalInfo.sd_setImage(with:URL(string:user.storeInfo?.storeImage ?? ""), placeholderImage:nil)
            self.hostVC.lblStoreName.text = user.storeInfo?.storeName
            self.hostVC.lblAddress.text = user.storeInfo?.storeAddress
            self.hostVC.lblStorePhoneNumber.text = user.storeInfo?.storePhone
            self.hostVC.lblStoreMailId.text = user.storeInfo?.storeMailID
            self.hostVC.lblBio.text = user.storeInfo?.bio
            
            self.hostVC.imgOwnerDoc1.sd_setImage(with:URL(string:user.ownerDocument?[0].documentPath ?? ""), placeholderImage:nil)
            self.hostVC.imgOwnerDoc2.sd_setImage(with:URL(string:user.ownerDocument?[1].documentPath ?? ""), placeholderImage:nil)
            
            self.hostVC.imgStoreDoc1.sd_setImage(with:URL(string:user.storeDocument?[0].documentPath ?? ""), placeholderImage:nil)
            self.hostVC.imgStoreDoc2.sd_setImage(with:URL(string:user.storeDocument?[1].documentPath ?? ""), placeholderImage:nil)
            
            self.hostVC.lblAccountType.text = user.sellerBankDetails?.accountType
            self.hostVC.lblIban.text = user.sellerBankDetails?.iban
            self.hostVC.lblSwift.text = user.sellerBankDetails?.swift
            self.hostVC.lblBankName.text = user.sellerBankDetails?.bankName
            self.hostVC.lblAccountHolderName.text = user.sellerBankDetails?.accountHolderName
            self.hostVC.imgProofOfAccount.sd_setImage(with:URL(string:user.sellerBankDetails?.uploadProof ?? ""), placeholderImage:nil)
        }
    }

    //Mark:->SubmitSummaryApi
    func submitSummaryApi(userId:String){
        let param:[String:Any] = [ APIKeys.userId:userId]
        WebService.sharedInstance.submitSummaryService(withParams:param) { user in
            let vc = AccountCreationDoneViewController.instantiate(fromAppStoryboard: .Main)
            self.hostVC.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
}
