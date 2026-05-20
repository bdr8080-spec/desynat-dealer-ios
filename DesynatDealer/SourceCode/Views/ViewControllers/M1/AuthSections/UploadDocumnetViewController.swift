//
//  UploadDocumnetViewController.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit
import SDWebImage

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
    
    lazy private var viewModel = UploadDocumentViewModel(hostVC: self)
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
        ibanTextField.delegate = self
        swiftTextField.delegate = self
        bankNameTextField.delegate = self
        accountHolderTextField.delegate = self
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
        let tag = sender.tag
        if tag == 0 {
            ImagePickerHelper.shared.showPickerController {  image , imageName in
                if let image = image {
                    WebService.sharedInstance.uploadImage(withParams: image) { imageURL in
                        self.imageOwnerDoc1 = imageURL.url ?? ""
                        self.selectedOwnerDoc1 = image
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
        let tag = sender.tag
        if tag == 0 {
            ImagePickerHelper.shared.showPickerController {  image , imageName in
                if let image = image {
                    WebService.sharedInstance.uploadImage(withParams: image) { imageURL in
                        self.imageStoreDoc1 = imageURL.url ?? ""
                        self.selectedStoreDoc1 = image
//                        print("image url--.\(self.imageStoreDoc1)")
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
//                        print("image url--.\(self.imageStoreDoc2)")
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
        ImagePickerHelper.shared.showPickerController {  image , imageName in
            if let image = image {
                WebService.sharedInstance.uploadImage(withParams: image) { imageURL in
                    self.imageAccountHolderDoc = imageURL.url ?? ""
                    self.selectedAccountHolderDoc = image
//                    print("image url--.\(self.imageAccountHolderDoc)")
                    if let url = URL(string: imageURL.url ?? "") {
                        self.accountHolderImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                        self.accountHolderImageView.sd_setImage(with: url,placeholderImage: UIImage(named: "user_ic"))
                    }
                }
            }
        }
    }
    
}

extension UploadDocumnetViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if string.isEmpty {
            return true
        }

        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)

        if textField == bankNameTextField {
            if currentText.isEmpty && string == " " {
                return false
            }
            let allowedCharacterSet = CharacterSet.letters.union(.whitespaces)
            return string.rangeOfCharacter(from: allowedCharacterSet.inverted) == nil
        }

        if textField == accountHolderTextField {
            if currentText.isEmpty && string == " " {
                return false
            }
            let allowedCharacterSet = CharacterSet.letters.union(.whitespaces)
            return string.rangeOfCharacter(from: allowedCharacterSet.inverted) == nil
        }

//        if textField == ibanTextField {
//            if string == " " {
//                return false
//            }
//            if newText.count > 20 {
//                return false
//            }
//            return true
//        }
//
//        if textField == swiftTextField {
//            if string == " " {
//                return false
//            }
//            return true
//        }
        
        if textField == ibanTextField {

            let uppercasedString = string.uppercased()

            let updatedText = (currentText as NSString)
                .replacingCharacters(in: range, with: uppercasedString)

            // No spaces
            if uppercasedString.contains(" ") {
                return false
            }

            // Only A-Z and 0-9
            let regex = "^[A-Z0-9]*$"

            if !NSPredicate(format: "SELF MATCHES %@", regex)
                .evaluate(with: uppercasedString) {
                return false
            }

            // Max length
            if updatedText.count > 34 {
                return false
            }

            // First 2 chars must be letters
            if updatedText.count <= 2 {

                let firstTwoRegex = "^[A-Z]*$"

                if !NSPredicate(format: "SELF MATCHES %@", firstTwoRegex)
                    .evaluate(with: uppercasedString) {
                    return false
                }
            }

            textField.text = updatedText.uppercased()

            return false
        }

        if textField == swiftTextField {

            let uppercasedString = string.uppercased()

            let updatedText = (currentText as NSString)
                .replacingCharacters(in: range, with: uppercasedString)

            // No spaces
            if uppercasedString.contains(" ") {
                return false
            }

            // Only A-Z and 0-9
            let regex = "^[A-Z0-9]*$"

            if !NSPredicate(format: "SELF MATCHES %@", regex)
                .evaluate(with: uppercasedString) {
                return false
            }

            // Max length
            if updatedText.count > 11 {
                return false
            }

            // First 6 chars letters only
            if updatedText.count <= 6 {

                let firstSixRegex = "^[A-Z]*$"

                if !NSPredicate(format: "SELF MATCHES %@", firstSixRegex)
                    .evaluate(with: uppercasedString) {
                    return false
                }
            }

            textField.text = updatedText.uppercased()

            return false
        }

        return true
    }
}
