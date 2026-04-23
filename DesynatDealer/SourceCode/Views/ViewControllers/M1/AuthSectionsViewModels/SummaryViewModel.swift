//
//  SummaryViewModel.swift
//  DesynatDealer
//
//  Created by Mohd Faizan on 31/10/25.
//

import Foundation
import UIKit
import SDWebImage

class SummaryViewModel:NSObject{
    private var hostVC:SummaryViewController
    
    init(hostVC: SummaryViewController) {
        self.hostVC = hostVC
    }
    
    //Mark:->SummaryAPi
    func getSummaryApi(userId:String){
        let param:[String:Any] = [APIKeys.userId:userId]
        
        WebService.sharedInstance.summaryService(withParams:param) { user in
            self.hostVC.imgPersonalInfo.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.hostVC.imgPersonalInfo.sd_setImage(with: URL(string: user.profilePic ?? ""),placeholderImage: nil)

            self.hostVC.lblFullName.text = "\(user.firstName ?? "") \(user.lastName ?? "")"
            self.hostVC.lblPhoneNumber.text = "\(user.countryCode ?? "")-\(user.mobile ?? "")"
            self.hostVC.lblMailId.text = user.email
            
            
            self.hostVC.lblStoreName.text = user.storeInfo?.storeName
//            self.hostVC.lblAddress.text = user.storeInfo?.storeAddress
            let storeAddress = user.storeInfo?.storeAddress ?? ""
            let addressLine1 = user.storeInfo?.addressLine1 ?? ""
            let addressLine2 = user.storeInfo?.addressLine2 ?? ""

            // Combine non-empty parts safely
            let fullAddress = [storeAddress, addressLine1, addressLine2]
                .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
                .joined(separator: ", ")

            // Set the label
            self.hostVC.lblAddress.text = fullAddress.isEmpty ? "N/A" : fullAddress
            
            self.hostVC.lblStorePhoneNumber.text = "\(user.storeInfo?.countryCode ?? "")-\(user.storeInfo?.storePhone ?? "")"
            self.hostVC.imgStoreInfo.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.hostVC.imgStoreInfo.sd_setImage(with: URL(string: user.storeInfo?.storeImage ?? ""),placeholderImage: nil)

            self.hostVC.lblStoreMailId.text = user.storeInfo?.storeMailID
            self.hostVC.lblBio.text = user.storeInfo?.bio
            
//            self.hostVC.imgOwnerDoc1.sd_setImage(with:URL(string:user.ownerDocument?[0].documentPath ?? ""), placeholderImage:nil)
//            self.hostVC.imgOwnerDoc2.sd_setImage(with:URL(string:user.ownerDocument?[1].documentPath ?? ""), placeholderImage:nil)
//            
//            self.hostVC.imgStoreDoc1.sd_setImage(with:URL(string:user.storeDocument?[0].documentPath ?? ""), placeholderImage:nil)
//            self.hostVC.imgStoreDoc2.sd_setImage(with:URL(string:user.storeDocument?[1].documentPath ?? ""), placeholderImage:nil)
            
            // Owner Documents
            self.hostVC.imgOwnerDoc1.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.hostVC.imgOwnerDoc1.sd_setImage(
                with: URL(string: user.ownerDocument?[0].documentPath ?? ""),
                placeholderImage: nil
            )

            self.hostVC.imgOwnerDoc2.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.hostVC.imgOwnerDoc2.sd_setImage(
                with: URL(string: user.ownerDocument?[1].documentPath ?? ""),
                placeholderImage: nil
            )

            // Store Documents
            self.hostVC.imgStoreDoc1.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.hostVC.imgStoreDoc1.sd_setImage(
                with: URL(string: user.storeDocument?[0].documentPath ?? ""),
                placeholderImage: nil
            )

            self.hostVC.imgStoreDoc2.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.hostVC.imgStoreDoc2.sd_setImage(
                with: URL(string: user.storeDocument?[1].documentPath ?? ""),
                placeholderImage: nil
            )

            
            let type = user.sellerBankDetails?.accountType ?? "0"
            if type == "0" {
                self.hostVC.lblAccountType.text = "Personal"
            } else {
                self.hostVC.lblAccountType.text = "Business"
            }
            
            if let iban = user.sellerBankDetails?.iban, !iban.isEmpty {
                self.hostVC.ibanView.isHidden = false
                self.hostVC.lblIban.text = iban
            } else {
                self.hostVC.ibanView.isHidden = true
            }
            
            if let swift = user.sellerBankDetails?.swift, !swift.isEmpty {
                self.hostVC.swiftView.isHidden = false
                self.hostVC.lblSwift.text = swift
            } else {
                self.hostVC.swiftView.isHidden = true
            }
            
//            self.hostVC.lblSwift.text = user.sellerBankDetails?.swift
            self.hostVC.lblBankName.text = user.sellerBankDetails?.bankName
            self.hostVC.lblAccountHolderName.text = user.sellerBankDetails?.accountHolderName
//            self.hostVC.imgProofOfAccount.sd_setImage(with:URL(string:user.sellerBankDetails?.uploadProof ?? ""), placeholderImage:nil)
            
            self.hostVC.imgProofOfAccount.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.hostVC.imgProofOfAccount.sd_setImage(
                with: URL(string: user.sellerBankDetails?.uploadProof ?? ""),
                placeholderImage: nil
            )
        }
    }

    //Mark:->SubmitSummaryApi
    func submitSummaryApi(userId:String){
        let param:[String:Any] = [ APIKeys.userId:userId,
                                   "device_type": 1,//0 web 1 ios 2 andriod
                                   "fcm_token": kSharedUserDefaults.retrieveModelFor(key: .deviceToken, model: String.self) ?? ""]
        WebService.sharedInstance.submitSummaryService(withParams:param) { user in
            let vc = AccountCreationDoneViewController.instantiate(fromAppStoryboard: .Main)
            self.hostVC.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
}
