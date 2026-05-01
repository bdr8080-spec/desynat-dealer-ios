//
//  RaiseTicketViewModel.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 08/04/26.
//


import Foundation

class RaiseTicketViewModel {
    
    private var hostVC: RaiseTicketViewController
    var ticketsTypeList: [TicketTypesList] = []
    
    init(hostVC: RaiseTicketViewController) {
        self.hostVC = hostVC
    }
    
    func validFields() -> Bool {
        var errorMessage: AlertConstant = .none
        
        if hostVC.selectedTicketTypeIndex == -1 {
            errorMessage = .SelectTicketType
        }
        
        let titleName = String.getString(hostVC.titleTF.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if titleName.isEmpty {
                errorMessage = .entertitle
            }
        }
        
        let description = String.getString(hostVC.descriptionTextView.text).trimmingCharacters(in: .whitespacesAndNewlines)
        if errorMessage == .none {
            if description.isEmpty {
                errorMessage = .enterdescription
            }
        }
        
        //        if hostVC.selectedImageUrl.isEmpty {
        //            errorMessage = .Selectattachment
        //        }
        
        if errorMessage != .none {
            hostVC.showAlert(msg: errorMessage.rawValue.localiz())
        }
        
        hostVC.view.endEditing(true)
        return errorMessage == .none
    }
    
    func ticketTypeListApi(){
        WebService.sharedInstance.getAllTicketTypeListService { list in
            self.ticketsTypeList = list
        }
    }
    
    func uploadDocument(file: Any, isImage: Bool, completion: @escaping(String) -> Void) {
        let param:MultipartUpload = MultipartUpload(fileName: "image", file: file, mimeType: isImage ? .image : .pdf)
        WebService.sharedInstance.uploadFileForPdfImageVideoGif(withParams: param) { url, msg, code in
            completion(url)
        }
    }
    
    func raiseTicket() {
        var param: [String: Any] = ["ticket_type_id": hostVC.selectedTicketTypeIndex,
                                    "title": hostVC.titleTF.text ?? "",
                                    //                                    "file": hostVC.selectedImageUrl
                                    "description": hostVC.descriptionTextView.text ?? ""]
        
        if let fileURL = hostVC.selectedImageUrl {
            param["file"] = fileURL
        }
        
        WebService.sharedInstance.raiseTicketForNormalUserService(param: param) { list in
            self.hostVC.isTicketRaised?()
            self.hostVC.dismiss(animated: true)
        }
    }
    
}
