//
//  AddHighlights.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 01/04/26.
//

import Foundation
class AddHighlightsViewModel{
    private var hostVc : AddNewHighlightViewController?
    init(hostVc: AddNewHighlightViewController? = nil) {
        self.hostVc = hostVc
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
            self.uploadHighlight(imageUrl: url)
        }
    }

    
    func uploadHighlight(imageUrl: String) {
      let param: [String: Any] = ["file": imageUrl]
      WebService.sharedInstance.addNewHeightlightServices(param: param){ [weak self] response in
        guard let self = self else { return }
        CommonUtils.showToast(message: "Highlight added successfully")
          self.hostVc?.navigationController?.popViewController(animated: true)
      }
    }
    
}
