

import Foundation

var pickerCallBack:PickerImage = nil
typealias PickerImage = ((UIImage?,String) -> (Void))?
enum OpenMediaType: Int {
    case camera = 0
    case photoLibrary
    case videoCamera
    case videoLibrary
    case documentUpload
}
import UIKit
import AVFoundation

class ImagePickerHelper: NSObject {
    
    private override init() {
    }
    private var isMediaPickerMode = false
    static var shared : ImagePickerHelper = ImagePickerHelper()
    var picker = UIImagePickerController()
    typealias PickerMedia = ((UIImage?, URL?, Bool) -> Void)?
    var pickerMediaCallBack: PickerMedia = nil
    
    //MARK: - Action Sheet
    
    func showActionSheet(withTitle title: String?, withAlertMessage message: String?, withOptions options: [String], handler:@escaping (_ selectedIndex: Int) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for strAction in options {
            let anyAction =  UIAlertAction(title: strAction, style: .default){ (action) -> Void in
                return handler(options.firstIndex(of: strAction)!)
            }
            alert.addAction(anyAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localiz(), style: .cancel){ (action) -> Void in
            return handler(-1)
        }
        alert.addAction(cancelAction)
        presetImagePicker(pickerVC: alert)
        
    }
    
    func showMediaPicker(_ handler: PickerMedia) {

        isMediaPickerMode = true
        pickerMediaCallBack = handler

        self.showActionSheet(
            withTitle: "Choose Option".localiz(),
            withAlertMessage: nil,
            withOptions: [
                "Take Photo".localiz(),
                "Open Gallery".localiz()
            ]
        ) { selectedIndex in

            switch selectedIndex {
            case OpenMediaType.camera.rawValue:
                self.showMediaCamera(handler)

            case OpenMediaType.photoLibrary.rawValue:
                self.openMediaGallery(handler)

            default:
                break
            }
        }
    }
    
    func showMediaCamera(_ handler: PickerMedia = nil) {

        if UIImagePickerController.isSourceTypeAvailable(.camera) {

            picker.delegate = self
            picker.sourceType = .camera
            picker.mediaTypes = ["public.image", "public.movie"]
            picker.videoQuality = .typeHigh

            presetImagePicker(pickerVC: picker)
        }

        pickerMediaCallBack = handler
    }
    
    func openMediaGallery(_ handler: PickerMedia = nil) {

        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.image", "public.movie"]

        presetImagePicker(pickerVC: picker)

        pickerMediaCallBack = handler
    }
    
    func showPickerController(
        onlyImagePicker: Bool? = false,
        _ handler: PickerImage
    ) {

        isMediaPickerMode = false
        pickerCallBack = handler

        self.showActionSheet(
            withTitle: "Choose Option".localiz(),
            withAlertMessage: nil,
            withOptions: [
                "Take Picture".localiz(),
                "Open Gallery".localiz()
            ]
        ) { selectedIndex in

            switch selectedIndex {
            case OpenMediaType.camera.rawValue:
                self.showCamera(handler)

            case OpenMediaType.photoLibrary.rawValue:
                self.openGallery(
                    onlyImagePicker: onlyImagePicker ?? false,
                    handler: handler
                )

            default:
                break
            }
        }
    }

    private func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        case .restricted, .denied:
            completion(false)
        @unknown default:
            completion(false)
        }
    }

    private func showCameraPermissionAlert() {
        let alert = UIAlertController(title: "Camera Permission Denied".localiz(),
                                      message: "Please allow the camera permission from Phone Settings.".localiz(),
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localiz(), style: .default, handler: nil))
        if let topController = UIApplication.shared.keyWindow?.rootViewController {
            topController.present(alert, animated: true, completion: nil)
        }
    }

    
    
    // MARK:-  Camera
    func showCamera(_ handler:PickerImage = nil) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = true
            picker.delegate = self
            picker.sourceType = .camera
            presetImagePicker(pickerVC: picker)
        } else {
            UIApplication.shared.topViewController()?.showAlert(msg: "Camera not available.")
        }
        pickerCallBack = handler
        picker.delegate = self
    }
    
    
    // MARK:-  Gallery
    
    func openGallery(  onlyImagePicker: Bool,  handler:PickerImage = nil) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        presetImagePicker(pickerVC: picker)
        pickerCallBack = handler
        picker.delegate = self
    }
    
    // MARK:- Show ViewController
    
    private func presetImagePicker(pickerVC: UIViewController) -> Void {
       // let appDelegate = UIApplication.shared.delegate as! AppDelegate
         UIApplication.shared.windows.first?.rootViewController?.present(pickerVC, animated: true, completion: {
            self.picker.delegate = self
        })
    }
    
    fileprivate func dismissViewController() -> Void {
      //  let appDelegate = UIApplication.shared.delegate as! AppDelegate
         UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK;- func for imageView in swift
    func SaveImage (imageView :UIImage) {
        UIImageWriteToSavedPhotosAlbum(imageView, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            UIApplication.shared.topViewController()?.showAlert(msg: "Photos not Saved ".localiz())
        } else {
            UIApplication.shared.topViewController()?.showAlert(msg: "Your altered image has been saved to your photos. ".localiz())
        }
    }
}


// MARK: - Picker Delegate
extension ImagePickerHelper : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey  : Any]) {
//        
//        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
//        guard let url = info[UIImagePickerController.InfoKey.imageURL] as? URL else {
//            pickerCallBack?(image,"Camera_Image.jpg")
//            dismissViewController()
//            return
//        }
//        pickerCallBack?(image,url.lastPathComponent)
//        dismissViewController()
//    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {

        if isMediaPickerMode {

            if let videoURL = info[.mediaURL] as? URL {
                pickerMediaCallBack?(nil, videoURL, true)
                dismissViewController()
                return
            }

            if let image = info[.editedImage] as? UIImage ??
                           info[.originalImage] as? UIImage {

                pickerMediaCallBack?(image, nil, false)
                dismissViewController()
                return
            }

        } else {

            guard let image = info[.editedImage] as? UIImage ??
                              info[.originalImage] as? UIImage else {
                dismissViewController()
                return
            }

            let imageName = (info[.imageURL] as? URL)?.lastPathComponent
                            ?? "Camera_Image.jpg"

            pickerCallBack?(image, imageName)
            dismissViewController()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismissViewController()
    }
}



class TextFieldMargin: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
