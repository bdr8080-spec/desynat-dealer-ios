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
}

enum ComingReasonAtStoryViewer {
    case forAdminStory
    case forSelfStory
    case forSelfHighlight
}
