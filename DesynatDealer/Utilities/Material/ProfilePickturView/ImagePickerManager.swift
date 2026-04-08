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
    
    static let shared = ImagePickerManager()
    var picker = UIImagePickerController();
    var alert = UIAlertController(title: "Choose File", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback: ((UIImage,String, URL?) -> ())?
    var allowPDFSelection: Bool = false // Add this property
    
    override init(){
        super.init()
        picker.delegate = self
    }
    
    private func setupAlert() {
        alert = UIAlertController(title: "Choose File", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.openCamera()
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { _ in
            self.openGallery()
        }
        
        // ✅ PDF option — only if allowed
        if allowPDFSelection {
            let pdfAction = UIAlertAction(title: "PDF / Files", style: .default) { _ in
                self.openDocumentPicker()
            }
            alert.addAction(pdfAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
    }
    
    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage, String, URL?) -> ())) {
        pickImageCallback = callback
        self.viewController = viewController
        setupAlert()
        alert.popoverPresentationController?.sourceView = viewController.view
        viewController.present(alert, animated: true)
    }
    
    func imagePickerControllerpickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage, String,URL?) -> ())) {
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
        
        // Check if it's a video first
        if let videoURL = info[.mediaURL] as? URL {
            // VIDEO
            let fileName = UUID().uuidString + ".mov"
            pickImageCallback?(UIImage(), fileName, videoURL)  // Pass empty UIImage + video URL
            return
        }
        
        // IMAGE
        guard let image = info[.originalImage] as? UIImage else {
            print("No image found in info: \(info)")
            return
        }
        
        let fileName = UUID().uuidString + ".jpg"
        pickImageCallback?(image, fileName, nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    }
    
    func openDocumentPicker() {
        alert.dismiss(animated: true)
        initializeDocument()
    }
    
    // MARK: - Media Picker (VIDEO ONLY)
    func pickMedia(_ viewController: UIViewController, _ callback: @escaping ((UIImage, String, URL?) -> ())) {
        self.viewController = viewController
        self.pickImageCallback = callback
        
        let mediaAlert = UIAlertController(title: "Select Video", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.openVideoCamera()
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { _ in
            self.openVideoGallery()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        mediaAlert.addAction(cameraAction)
        mediaAlert.addAction(galleryAction)
        mediaAlert.addAction(cancelAction)
        
        mediaAlert.popoverPresentationController?.sourceView = viewController.view
        viewController.present(mediaAlert, animated: true)
    }
    
    private func openVideoCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            let alertController = UIAlertController(title: "Warning", message: "Camera not available", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(action)
            viewController?.present(alertController, animated: true)
            return
        }
        
        picker.sourceType = .camera
        picker.mediaTypes = ["public.movie"]  // VIDEO ONLY
        picker.videoQuality = .typeHigh
        picker.videoMaximumDuration = 60.0    // 60 seconds max
        self.viewController!.present(picker, animated: true)
    }
    
    private func openVideoGallery() {
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.movie"]  // VIDEO ONLY
        picker.videoMaximumDuration = 60.0    // 60 seconds max
        self.viewController!.present(picker, animated: true)
    }
}

extension ImagePickerManager {
    // MARK: - Document Picker
    private func initializeDocument() {
        let doc = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
        doc.delegate = self
        viewController?.present(doc, animated: true)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        for url in urls {
            defer { url.stopAccessingSecurityScopedResource() }
            guard url.startAccessingSecurityScopedResource() else { return }
            pickImageCallback?(UIImage(), "", url)
        }
    }
}
