//
//  SummaryViewController.swift
//  DesynatDealer
//
//  Created by Mohd Faizan on 31/10/25.
//

import UIKit

class SummaryViewController: UIViewController {
    
    @IBOutlet weak var imgPersonalInfo: CustomImageView!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblMailId: UILabel!
    @IBOutlet weak var imgStoreInfo: CustomImageView!
    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblStorePhoneNumber: UILabel!
    @IBOutlet weak var lblStoreMailId: UILabel!
    @IBOutlet weak var lblBio: UILabel!
    @IBOutlet weak var imgOwnerDoc1: CustomImageView!
    @IBOutlet weak var imgOwnerDoc2: CustomImageView!
    @IBOutlet weak var imgStoreDoc1: CustomImageView!
    @IBOutlet weak var imgStoreDoc2: CustomImageView!
    @IBOutlet weak var lblAccountType: UILabel!
    @IBOutlet weak var lblIban: UILabel!
    @IBOutlet weak var lblSwift: UILabel!
    @IBOutlet weak var lblBankName: UILabel!
    @IBOutlet weak var lblAccountHolderName: UILabel!
    @IBOutlet weak var imgProofOfAccount: CustomImageView!
    @IBOutlet weak var swiftView: UIView!
    @IBOutlet weak var ibanView: UIView!
    
    var userId = ""
    private lazy var viewModel =  SummaryViewModel(hostVC:self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getSummaryApi(userId: self.userId)
    }
    
    @IBAction func btnTapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated:true)
    }
    
    @IBAction func btnTapSubmit(_ sender: UIButton) {
        viewModel.submitSummaryApi(userId:self.userId)
    }
}
