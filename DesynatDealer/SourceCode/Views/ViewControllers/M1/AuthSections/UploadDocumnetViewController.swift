//
//  UploadDocumnetViewController.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit
import SDWebImage

class UploadDocumnetViewController: UIViewController {
    lazy private var viewModel = UploadDocumentViewModel(hostVC: self)
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
    
    var imageOwnerDoc1:String = ""
    var imageOwnerDoc2:String = ""
    var imageStoreDoc1:String = ""
    var imageStoreDoc2:String = ""
    var imageAccountHolderDoc:String = ""

    var selectedOwnerDoc1: UIImage?
    var selectedOwnerDoc2: UIImage?
    var selectedStoreDoc1: UIImage?
    var selectedStoreDoc2: UIImage?
    var selectedAccountHolderDoc: UIImage?
    private var personalIsSelected: Bool = false
    var userId = ""
    var accountType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitDidTapped(_ sender: Any) {
        if viewModel.validFields() {
            viewModel.uploadDocumentApi()
        }
    }
    
    @IBAction func ownerDocumentImageDidTapped(_ sender: UIButton) {
//        ImagePickerManager().pickImage(self) { [weak self] image, fileName, url in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                if sender.tag == 0 {
//                    self.onwerDocImage1.image = image
//                    self.selectedOwnerDoc1 = image
//                } else {
//                    self.onwerDocImage2.image = image
//                    self.selectedOwnerDoc2 = image
//                }
//            }
//        }
        
        let tag = sender.tag
        
        if tag == 0 {
            ImagePickerHelper.shared.showPickerController {  image , imageName in
                if let image = image {
                    WebService.sharedInstance.uploadImage(withParams: image) { imageURL in
                        self.imageOwnerDoc1 = imageURL.url ?? ""
                        self.selectedOwnerDoc1 = image
                        print("image url--.\(self.imageOwnerDoc1)")
                        if let url = URL(string: imageURL.url ?? "") {
                            self.onwerDocImage1.sd_imageIndicator = SDWebImageActivityIndicator.gray
                            self.onwerDocImage1.sd_setImage(with: url,placeholderImage: UIImage(named: "user_ic"))
                        }
                    }
                }
            }
        }else{
            ImagePickerHelper.shared.showPickerController {  image , imageName in
                if let image = image {
                    WebService.sharedInstance.uploadImage(withParams: image) { imageURL in
                        self.imageOwnerDoc2 = imageURL.url ?? ""
                        self.selectedOwnerDoc2 = image
                        print("image url--.\(self.imageOwnerDoc2)")
                        if let url = URL(string: imageURL.url ?? "") {
                            self.onwerDocImage2.sd_imageIndicator = SDWebImageActivityIndicator.gray
                            self.onwerDocImage2.sd_setImage(with: url,placeholderImage: UIImage(named: "user_ic"))
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func storeDocumentDidTapped(_ sender: UIButton) {
//        ImagePickerManager().pickImage(self) { [weak self] image, fileName, url in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                if sender.tag == 0 {
//                    self.storeDocImage1.image = image
//                    self.selectedStoreDoc1 = image
//                } else {
//                    self.storeDocImage2.image = image
//                    self.selectedStoreDoc2 = image
//                }
//            }
//        }
        
        let tag = sender.tag
        
        if tag == 0 {
            ImagePickerHelper.shared.showPickerController {  image , imageName in
                if let image = image {
                    WebService.sharedInstance.uploadImage(withParams: image) { imageURL in
                        self.imageStoreDoc1 = imageURL.url ?? ""
                        self.selectedStoreDoc1 = image
                        print("image url--.\(self.imageStoreDoc1)")
                        if let url = URL(string: imageURL.url ?? "") {
                            self.storeDocImage1.sd_imageIndicator = SDWebImageActivityIndicator.gray
                            self.storeDocImage1.sd_setImage(with: url,placeholderImage: UIImage(named: "user_ic"))
                        }
                    }
                }
            }
        }else{
            ImagePickerHelper.shared.showPickerController {  image , imageName in
                if let image = image {
                    WebService.sharedInstance.uploadImage(withParams: image) { imageURL in
                        self.imageStoreDoc2 = imageURL.url ?? ""
                        self.selectedStoreDoc2 = image
                        print("image url--.\(self.imageStoreDoc2)")
                        if let url = URL(string: imageURL.url ?? "") {
                            self.storeDocImage2.sd_imageIndicator = SDWebImageActivityIndicator.gray
                            self.storeDocImage2.sd_setImage(with: url,placeholderImage: UIImage(named: "user_ic"))
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func personalDidTappd(_ sender: Any) {
        personalAccountImage.image = UIImage(named: "radioSelected")
        businessAccountImage.image = UIImage(named: "radioUnselected")
        personalIsSelected = true
        accountType = 0
    }
    
    @IBAction func businessDidTapped(_ sender: Any) {
        businessAccountImage.image = UIImage(named: "radioSelected")
        personalAccountImage.image = UIImage(named: "radioUnselected")
        personalIsSelected = false
        accountType = 1
    }
    
    @IBAction func accountHolderImageDidTapped(_ sender: Any) {
//        ImagePickerManager().pickImage(self) { [weak self] image, fileName, url in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                self.accountHolderImageView.image = image
//                self.selectedAccountHolderDoc = image
//                
//            }
//        }
        ImagePickerHelper.shared.showPickerController {  image , imageName in
            if let image = image {
                WebService.sharedInstance.uploadImage(withParams: image) { imageURL in
                    self.imageAccountHolderDoc = imageURL.url ?? ""
                    self.selectedAccountHolderDoc = image
                    print("image url--.\(self.imageAccountHolderDoc)")
                    if let url = URL(string: imageURL.url ?? "") {
                        self.accountHolderImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        self.accountHolderImageView.sd_setImage(with: url,placeholderImage: UIImage(named: "user_ic"))
                    }
                }
            }
        }
    }
    
}
