//
//  UploadStoryViewModel.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 01/04/26.
//

import Foundation
class UploadStoryViewModel: ObservableObject {
    private var hostVc : UploadPostViewController?
    
    init(hostVc: UploadPostViewController? = nil) {
        self.hostVc = hostVc
    }
    func addNewStory(){
        let param : [String:Any] = [:]
        WebService.sharedInstance.addNewStoryServices(param: param){ respons in
            
            
        }
    }
    
    func uploadMedia(fileData: Data, isImage: Bool) {
        let mimeType: MultipartUpload.Mime = isImage ? .image : .Video
        
        // fileName here is just a placeholder — it no longer affects the form field name
        // We use any string, e.g., "file" or "media" — it's safe now
        let uploadItem = MultipartUpload(
            fileName: "file",           // Can be anything — ignored for field name
            file: fileData,             // Pass Data directly (supported now)
            mimeType: mimeType
        )
        
        // Call the upload function
        WebService.sharedInstance.uploadVideoAndImage(withParams: uploadItem) { [weak self] url, msg, code in
          guard let self = self, !url.isEmpty else { return }
            // Success: Now upload the story with the returned URL
            self.uploadStories(imageUrl: url)
        }
    }
    
    func uploadMediaForGettingThumbnailImageUrl(fileData: Data, isImage: Bool) {
        let mimeType: MultipartUpload.Mime = isImage ? .image : .Video
        let uploadItem = MultipartUpload(
            fileName: "file",
            file: fileData,
            mimeType: mimeType)
        WebService.sharedInstance.uploadVideoAndImage(withParams: uploadItem) { [weak self] url, msg, code in
            guard let self = self, !url.isEmpty else { return }
            hostVc?.thumbnailImage = url
        }
    }

    
    func uploadStories(imageUrl: String) {
        let param: [String: Any] = ["file": imageUrl,
                                    "thumbnail" : self.hostVc?.thumbnailImage ?? "" ]
      WebService.sharedInstance.addNewStoryServices(param: param){ [weak self] response in
        guard let self = self else { return }
          CommonUtils.showToast(message: "Story Uploaded Succesfully".localiz())
          self.hostVc?.navigationController?.popToViewController(ofClass: DelearProfileViewController.self, animated: true)
      }
    }
    
}
