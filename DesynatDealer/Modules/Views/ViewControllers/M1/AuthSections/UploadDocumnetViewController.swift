//
//  UploadDocumnetViewController.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit

class UploadDocumnetViewController: UIViewController {
    
    @IBOutlet weak var onwerDocImage1: CustomImageView!
    @IBOutlet weak var onwerDocImage2: CustomImageView!
    @IBOutlet weak var storeDocImage1: CustomImageView!
    @IBOutlet weak var storeDocImage2: CustomImageView!
    @IBOutlet weak var personalAccountImage: UIImageView!
    @IBOutlet weak var businessAccountImage: UIImageView!
    @IBOutlet weak var ibanTextField: UITextField!
    @IBOutlet weak var swiftTextField: UITextField!
    @IBOutlet weak var bankNameTextField: UITextField!
    @IBOutlet weak var accountHolderTextField: UITextField!
    @IBOutlet weak var accountHolderImageView: CustomImageView!
    
    var selectedOwnerDoc1: UIImage?
    var selectedOwnerDoc2: UIImage?
    var selectedStoreDoc1: UIImage?
    var selectedStoreDoc2: UIImage?
    var selectedAccountHolderDoc: UIImage?
    private var personalIsSelected: Bool = false
    lazy private var viewModel = UploadDocumentViewModel(hostVC: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitDidTapped(_ sender: Any) {
        if viewModel.validFields() {
            let vc = AccountCreationDoneViewController.instantiate(fromAppStoryboard: .Main)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func ownerDocumentImageDidTapped(_ sender: UIButton) {
        ImagePickerManager().pickImage(self) { [weak self] image, fileName, url in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if sender.tag == 0 {
                    self.onwerDocImage1.image = image
                    self.selectedOwnerDoc1 = image
                } else {
                    self.onwerDocImage2.image = image
                    self.selectedOwnerDoc2 = image
                }
            }
        }
    }
    
    @IBAction func storeDocumentDidTapped(_ sender: UIButton) {
        ImagePickerManager().pickImage(self) { [weak self] image, fileName, url in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if sender.tag == 0 {
                    self.storeDocImage1.image = image
                    self.selectedStoreDoc1 = image
                } else {
                    self.storeDocImage2.image = image
                    self.selectedStoreDoc2 = image
                }
            }
        }
    }
    
    @IBAction func personalDidTappd(_ sender: Any) {
        personalAccountImage.image = UIImage(named: "radioSelected")
        businessAccountImage.image = UIImage(named: "radioUnselected")
        personalIsSelected = true
    }
    
    @IBAction func businessDidTapped(_ sender: Any) {
        businessAccountImage.image = UIImage(named: "radioSelected")
        personalAccountImage.image = UIImage(named: "radioUnselected")
        personalIsSelected = false
    }
    
    @IBAction func accountHolderImageDidTapped(_ sender: Any) {
        ImagePickerManager().pickImage(self) { [weak self] image, fileName, url in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.accountHolderImageView.image = image
                self.selectedAccountHolderDoc = image
                
            }
        }
    }
    
}
