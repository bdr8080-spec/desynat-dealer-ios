//
//  ImageDocumentHelper.swift
//  ClupPeRestaurant
//
//  Created by Fluper on 08/02/24.
//
import Foundation
import MobileCoreServices
import UIKit

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIDocumentPickerDelegate {
    
    var picker = UIImagePickerController();
    var alert = UIAlertController(title: "Choose File", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback: ((UIImage,String, URL?) -> ())?
    var allowPDFSelection: Bool = false // Add this property
    
    override init(){
        super.init()
        
        
        if kSharedAppDelegate.forOpenFilePickerView == "Coverimage"{
            let cameraAction = UIAlertAction(title: "Camera", style: .default){
                UIAlertAction in
                self.openCamera()
            }
            let galleryAction = UIAlertAction(title: "Gallery", style: .default){
                UIAlertAction in
                self.openGallery()
            }
            
//            let documentAction = UIAlertAction(title: "Pdf Document", style: .default) {
//                UIAlertAction in
//
//                self.openDocumentPicker()
//
//            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
                UIAlertAction in
            }
            picker.delegate = self
            
            alert.addAction(cameraAction)
            alert.addAction(galleryAction)
            alert.addAction(cancelAction)
//            alert.addAction(documentAction)
        }else {
            let cameraAction = UIAlertAction(title: "Camera", style: .default){
                UIAlertAction in
                self.openCamera()
            }
            let galleryAction = UIAlertAction(title: "Gallery", style: .default){
                UIAlertAction in
                self.openGallery()
            }
            
            let documentAction = UIAlertAction(title: "Pdf Document", style: .default) {
                UIAlertAction in
//                self.openDocumentPicker()
                self.initializeDocument()

            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
                UIAlertAction in
            }
            picker.delegate = self
            
            alert.addAction(cameraAction)
            alert.addAction(galleryAction)
            alert.addAction(cancelAction)
            //alert.addAction(documentAction)
        }
        
    }
    
    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage, String,URL?) -> ())) {
        pickImageCallback = callback
        self.viewController = viewController
        alert.popoverPresentationController?.sourceView = self.viewController!.view
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)) {
            picker.sourceType = .camera
            self.viewController!.present(picker, animated: true, completion: nil)
        } else {
            let alertController: UIAlertController = {
                let controller = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default)
                controller.addAction(action)
                return controller
            } ()
            viewController?.present(alertController, animated: true)
        }
    }
    
    func openGallery() {
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        self.viewController!.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        //let fileName = (info[.imageURL] as? URL)?.lastPathComponent ?? ""
        let fileName = UUID().uuidString + ".jpg"
        pickImageCallback?(image, fileName,nil )
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    }
    
    // MARK: PDF SECTION
//    func openDocumentPicker() {
//        alert.dismiss(animated: true, completion: nil)
//        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
//        documentPicker.delegate = self
//        self.viewController?.present(documentPicker, animated: true, completion: nil)
//    }
//
//    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//        guard let url = urls.first else {
//            return
//        }
//        let documentName = url.lastPathComponent
//        pickImageCallback?(UIImage(), documentName,url )
//    }
}

extension ImagePickerManager {
    private func initializeDocument() {
        let doc = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
        doc.delegate = self
        self.viewController?.present(doc, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true)
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        for url in urls {
            for url in urls {
                defer { url.stopAccessingSecurityScopedResource() }
                guard url.startAccessingSecurityScopedResource() else {
                    return
                }
                //                pickPDFCallback?(url)
                pickImageCallback?(UIImage(), "",url )
            }
            
        }
    }

}
