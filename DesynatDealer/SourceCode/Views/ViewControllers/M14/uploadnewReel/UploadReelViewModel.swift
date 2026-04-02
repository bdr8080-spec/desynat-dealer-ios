import Foundation

class UploadReelViewModel {
    
    var hostVc: UploadNewReelViewController?
    
    init(hostVc: UploadNewReelViewController? = nil) {
        self.hostVc = hostVc
    }
    
    // MARK: - Validation
    func isValid() -> Bool {
        
        guard let vc = hostVc else { return false }
        
        // Caption validation
        if vc.captiontxtArea.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            CommonUtils.showToast(message: "Please enter caption")
            return false
        }
        
        // Media validation
        if vc.selectedMediaData == nil {
            CommonUtils.showToast(message: "Please select image or video")
            return false
        }
        
        return true
    }
    
    // MARK: - Upload Media
    func uploadMedia(fileData: Data, isImage: Bool) {
        let mimeType: MultipartUpload.Mime = isImage ? .image : .Video
        let uploadItem = MultipartUpload(
            fileName: "file",
            file: fileData,
            mimeType: mimeType)
        WebService.sharedInstance.uploadVideoAndImage(withParams: uploadItem) { [weak self] url, msg, code in
            guard let self = self, !url.isEmpty else { return }
            if hostVc?.isComingForEdit == true {
                self.editReel(mediaUrl: url)
            } else {
                self.uploadReel(mediaUrl: url)
            }
        }
    }
    
    // MARK: - Final API
    func uploadReel(mediaUrl: String) {
        let param: [String: Any] = [
            "file": mediaUrl,
            "caption": hostVc?.captiontxtArea.text ?? ""
        ]
        WebService.sharedInstance.addNewReelsServices(param: param) { [weak self] response in
            guard let self = self else { return }
            
            CommonUtils.showToast(message: "Reel Uploaded Successfully")
            self.hostVc?.navigationController?.popViewController(animated: true)
        }
    }
    
    func editReel(mediaUrl: String) {
        let param: [String: Any] = [
            "reel_id": hostVc?.reelsData?.id ?? 1,
            "file": mediaUrl,
            "caption": hostVc?.captiontxtArea.text ?? ""
        ]
        WebService.sharedInstance.editMyReelsServices(param: param) { [weak self] response in
            guard let self = self else { return }
            
            CommonUtils.showToast(message: "Reel Updated Successfully")
            self.hostVc?.navigationController?.popViewController(animated: true)
        }
    }
}
