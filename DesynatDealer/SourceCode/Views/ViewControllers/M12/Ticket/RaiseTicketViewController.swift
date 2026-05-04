//
//  RaiseTicketViewController.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 19/03/26.
//

import UIKit

class RaiseTicketViewController: UIViewController {
    
    @IBOutlet weak var ticketTypeLabel: UILabel!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var attachmentImageView: CustomImageView!
    
    private lazy var viewModel = RaiseTicketViewModel(hostVC: self)
    var selectedImageUrl: String? = ""
    var selectedTicketTypeIndex: Int = -1
    var isTicketRaised: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        viewModel.ticketTypeListApi()
        descriptionTextView.placeholderLabel?.text = "Enter Description".localiz()
        if AppLanguageManager.shared.currentLanguage == .ar {
            descriptionTextView.placeholderLabel?.textAlignment = .right
            descriptionTextView.textAlignment = .right
        }else {
            descriptionTextView.placeholderLabel?.textAlignment = .left
            descriptionTextView.textAlignment = .left
        }
    }
    
    // MARK: - Navigation
    @IBAction func crossBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func ticketTypeDidTapped(_ sender: UIButton) {
        let ticketsName = viewModel.ticketsTypeList.map { list -> String in
            let name = list.name ?? ""
            return name
        }
        kSharedAppDelegate.dropDown(dataSource: ticketsName, anchorView: sender) { index, item in
            let selectedTicket = self.viewModel.ticketsTypeList[index]
            let name = selectedTicket.name
            self.ticketTypeLabel.text = name
            self.selectedTicketTypeIndex = selectedTicket.id ?? -1
        }
    }
    
    @IBAction func attachmentDidTapped(_ sender: Any) {
        let picker = ImagePickerManager.shared
        picker.allowPDFSelection = true  // Enable PDF selection
        
        picker.pickImage(self) { [weak self] image, fileName, url in
            guard let self = self else { return }
            
            // Check if the picked file is a PDF
            if let url = url, url.pathExtension.lowercased() == "pdf" {
                DispatchQueue.main.async {
                    self.attachmentImageView.image = UIImage(named: "pdf_uploaded_sec") // PDF placeholder
                }
                // Upload PDF as Data
                if let pdfData = try? Data(contentsOf: url) {
                    self.viewModel.uploadDocument(file: pdfData, isImage: false) { uploadedUrl in
                        DispatchQueue.main.async {
                            self.selectedImageUrl = uploadedUrl
                        }
                    }
                }
            } else {
                // Handle image
                DispatchQueue.main.async {
                    self.attachmentImageView.image = image
                }
                
                if let compressedData = image.jpegData(compressionQuality: 0.25),
                   let finalImage = UIImage(data: compressedData) {
                    self.viewModel.uploadDocument(file: finalImage, isImage: true) { uploadedUrl in
                        DispatchQueue.main.async {
                            self.selectedImageUrl = uploadedUrl
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func submitDidTapped(_ sender: Any) {
        if viewModel.validFields() {
            viewModel.raiseTicket()
        }
    }
    
    func setUpUI(){
        titleView.layer.cornerRadius = 24
        titleView.layer.maskedCorners = [
            .layerMinXMinYCorner, // top-left
            .layerMaxXMinYCorner  // top-right
        ]
        titleView.clipsToBounds = true
    }
    
}
