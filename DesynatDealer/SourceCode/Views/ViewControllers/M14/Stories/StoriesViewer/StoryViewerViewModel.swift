//
//  StoryViewerViewModel.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 27/03/26.
//

import Foundation
import AVFoundation

class StoryViewerViewModel {
    
    var adminStories: [SellerHighlightsModel] = []
    var sellerStories: [SellerHighlightsModel] = []
    var sellerHighlight: [GetHighLightsList] = []
    
    func getAdminStory(completion: @escaping () -> Void) {
        WebService.sharedInstance.getAdminStoryService() { list in
            self.adminStories = list
            completion()
        }
    }
    
    func getSelfStory(completion: @escaping () -> Void) {
        WebService.sharedInstance.getSellerStoryService() { list in
            self.sellerStories = list
            completion()
        }
    }
    
    func getSelfHighlight(completion: @escaping () -> Void) {
        WebService.sharedInstance.getMyAllHighLights() { list in
            self.sellerHighlight = list
            completion()
        }
    }
    
    func deleteSelfHighlight(id: Int, completion: @escaping (Bool) -> Void) {
        let param: [String:Any] = ["highlight_id": id]
        WebService.sharedInstance.deleteMyHighLights(param: param) { success in
            completion(true)
        }
    }

    func deleteSelfStory(id: Int, completion: @escaping (Bool) -> Void) {
        let param: [String:Any] = ["story_id": id]
        WebService.sharedInstance.deleteMyStory(param: param) { success in
            completion(true)
        }
    }
}

enum ComingReasonAtStoryViewer {
    case forAdminStory
    case forSelfStory
    case forSelfHighlight
}
