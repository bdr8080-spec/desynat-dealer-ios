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
    var sellerHighlight: [HighlightList] = []
    
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
    
    func seeStoryService(storyId: Int) {
        let savedUser = kSharedUserDefaults.retrieveModelFor(key: .user, model: User.self)
        let param: [String:Any] = ["story_id": storyId,
                                   "type": 2, //1-user,2-seller,3-admin
                                   "user_id": savedUser?.id ?? 0]
        WebService.sharedInstance.seeStoryListService(param: param) { success in
            print("Stopry viewed")
        }
    }
}

enum ComingReasonAtStoryViewer {
    case forAdminStory
    case forSelfStory
    case forSelfHighlight
}
