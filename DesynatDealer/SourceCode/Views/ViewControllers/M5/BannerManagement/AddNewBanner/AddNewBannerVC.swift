//
//  AddNewBannerVC.swift
//  DesynatDealer
//
//  Created by fluper on 18/12/25.
//

import UIKit
import SDWebImage

class AddNewBannerVC: UIViewController {
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblSubCategory: UILabel!
    @IBOutlet weak var txtFromDate: UITextField!
    @IBOutlet weak var txtToDate: UITextField!
    @IBOutlet weak var lblTotalDays: UILabel!
    @IBOutlet weak var imgBanner: CustomImageView!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var viewSubCategory: UIView!
    
    lazy private var viewModel = AddNewBannerVM(hostVC: self)
    var selectedImg: Int?
    var bannerImageUrl: String = ""
    let datePicker = UIDatePicker()
    private var activeTextField: UITextField?
    var categoriesList: [CategoryDataModel] = []
    var subcategoriesList: [SubCategoryDataModel] = []
    var selectedCategoryId: Int?
    var selectedSubCategoriesId: Int? = -1
    var onBannerAdded: (() -> Void)?
    var pricePerDay: Int = 0
    var pickedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFields()
        viewModel.getCategoriesListApi()
        viewCategory.isHidden = true
        viewSubCategory.isHidden = true
        
        let defaultBtn = UIButton()
        defaultBtn.tag = 0
        btnSelectPosition(defaultBtn)
    }
    
    private func resetRadio() {
        img1.image = UIImage(named: "radioUnselected")
        img2.image = UIImage(named: "radioUnselected")
        img3.image = UIImage(named: "radioUnselected")
    }
    
    private func resetCategoryData() {
        lblCategory.text = "Select Category"
        lblSubCategory.text = "Select Sub-Category"
        selectedCategoryId = nil
        selectedSubCategoriesId = nil
        subcategoriesList.removeAll()
    }
    
    func calculateFinalPrice() {
        guard let daysTxt = lblTotalDays.text, let days = Int(daysTxt), let priceTxt = lblTotalPrice.text else { return }
        
        let priceOnly = priceTxt
            .replacingOccurrences(of: " KD", with: "")
            .trimmingCharacters(in: .whitespaces)
        
        guard let pricePerDay = Int(priceOnly) else { return }
        
        let totalPrice = days * pricePerDay
        lblTotalPrice.text = "\(totalPrice) KD"
    }
    
    func getNumericBannerAmount() -> Int {
        let priceText = lblTotalPrice.text ?? ""
        
        let numericText = priceText
            .replacingOccurrences(of: "KD", with: "")
            .replacingOccurrences(of: " ", with: "")
        
        return Int(numericText) ?? 0
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSelectPosition(_ sender: UIButton) {
        resetRadio()
        txtFromDate.text = ""
        txtToDate.text = ""
        lblTotalDays.text = "days"
        lblTotalPrice.text = "0 KD"
        //        lblTotalPrice.text = "\(pricePerDay) KD"
        
        var bannerType = "1"
        
        switch sender.tag {
        case 0:
            img1.image = UIImage(named: "radioSelected")
            viewCategory.isHidden = true
            viewSubCategory.isHidden = true
            resetCategoryData()
            bannerType = "1"
            
        case 1:
            img2.image = UIImage(named: "radioSelected")
            viewCategory.isHidden = true
            viewSubCategory.isHidden = true
            resetCategoryData()
            bannerType = "2"
            
        case 2:
            img3.image = UIImage(named: "radioSelected")
            viewCategory.isHidden = false
            viewSubCategory.isHidden = false
            resetCategoryData()
            bannerType = "3"
            
            if categoriesList.isEmpty {
                viewModel.getCategoriesListApi()
            }
            
        default:
            break
        }
        selectedImg = sender.tag
        viewModel.getPrice(type: bannerType)
    }
    
    @IBAction func btnUploadImg(_ sender: Any) {
        ImagePickerHelper.shared.showPickerController {  image , imageName in
            self.imgBanner.image = image
            if let image = image {
//                self.viewModel.uploadFullScreenBanner(file: image, isImage: true) { [weak self] uploadedUrl in
//                    guard let self = self else { return }
//                    DispatchQueue.main.async {
//                        self.bannerImageUrl = uploadedUrl
                        self.pickedImage = image
//                    }
//                }
            }
        }
    }
    
    @IBAction func catgeoryAction(_ sender: UIButton) {
        let categoryNames = categoriesList.map { $0.name ?? "" }
        kSharedAppDelegate.dropDown(dataSource: categoryNames, anchorView: sender) { index, item in
            let selectedCategory = self.categoriesList[index]
            self.lblCategory.text = selectedCategory.name ?? ""
            self.selectedCategoryId = selectedCategory.id
            self.selectedSubCategoriesId = nil
            self.subcategoriesList.removeAll()
            self.viewModel.getSubCategoriesListApi(categoryId: selectedCategory.id ?? 0)
        }
    }
    
    @IBAction func subCatgeoryAction(_ sender: UIButton) {
        
        guard let _ = selectedCategoryId else {
            showAlert(msg: "Please select the category first")
            return
        }
        
        //If no subcategories available
        guard !subcategoriesList.isEmpty else {
            showAlert(msg: "No subcategories available")
            return
        }
        
        let subCategoryNames = self.subcategoriesList.map { $0.nameEnglish ?? "" }
        
        kSharedAppDelegate.dropDown(dataSource: subCategoryNames, anchorView: sender) { index, item in
            let selectedsubCategory = self.subcategoriesList[index]
            self.lblSubCategory.text = selectedsubCategory.nameEnglish ?? ""
            self.selectedSubCategoriesId = selectedsubCategory.id
        }
    }
    
    @IBAction func btnSendRequest(_ sender: Any) {
        if viewModel.validation() {
            uploadBannerThenSubmit()
        }
    }
    
    private func uploadBannerThenSubmit() {
        // Image upload
        if let image = pickedImage {
            viewModel.uploadFullScreenBanner(
                file: image,
                isImage: true,
            ) { [weak self] url in
                self?.bannerImageUrl = url
                self?.viewModel.addBanner()
            }
            return
        }
        
        // Add flow safety
        //        showAlert(msg: "Please select image")
    }
}

// Date Picker
extension AddNewBannerVC {
    private func setUpTextFields() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.backgroundColor = .white
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        let textFields = [txtFromDate, txtToDate]
        textFields.forEach { textField in
            textField?.inputView = datePicker
            textField?.inputAccessoryView = toolbar
            textField?.delegate = self
        }
    }
    
    @objc private func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        guard let activeTextField = activeTextField else { return }
        
        let selectedDate = datePicker.date
        activeTextField.text = formatter.string(from: selectedDate)
        view.endEditing(true)
        
        // ✅ Case: From date changed
        if activeTextField == txtFromDate,
           let toText = txtToDate.text,
           !toText.isEmpty,
           let toDate = formatter.date(from: toText) {
            
            // 🚫 From > To → invalidate To
            if selectedDate > toDate {
                txtToDate.text = ""
                lblTotalDays.text = "days"
                lblTotalPrice.text = "0 KD"
                
                // 🔁 Force user to select To Date again
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.txtToDate.becomeFirstResponder()
                }
                return
            }
        }
        
        // ✅ Calculate only when both dates are valid
        calculateTotalDays()
    }
    
    
    
    @objc private func cancelDatePicker() {
        view.endEditing(true)
    }
    
    func calculateTotalDays() {
        guard
            let fromText = txtFromDate.text, !fromText.isEmpty,
            let toText = txtToDate.text, !toText.isEmpty
        else {
            lblTotalDays.text = "days"
            lblTotalPrice.text = "0 KD"
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        guard
            let startDate = formatter.date(from: fromText),
            let endDate = formatter.date(from: toText),
            startDate <= endDate
        else {
            lblTotalDays.text = "days"
            lblTotalPrice.text = "0 KD"
            return
        }
        
        let days = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
        let totalDays = days + 1   // inclusive
        
        lblTotalDays.text = "\(totalDays)"
        lblTotalPrice.text = "\(totalDays * pricePerDay) KD"
    }
    
}

//TExtField Delegate
extension AddNewBannerVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        if textField == txtToDate,
           let fromText = txtFromDate.text,
           let fromDate = formatter.date(from: fromText) {
            datePicker.minimumDate = fromDate
        } else {
            datePicker.minimumDate = Date()
        }
    }
    
}

extension String {
    func toAPIDate() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd/MM/yyyy"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: self) {
            return outputFormatter.string(from: date)
        }
        return ""
    }
}
