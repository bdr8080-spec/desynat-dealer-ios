//
//  LiveStreamViewModel.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 02/04/26.
//

import Foundation
class LiveStreamViewModel: ObservableObject {
    private var hostVc : LiveStreamingViewController?
    init(hostVc: LiveStreamingViewController) {
        self.hostVc = hostVc
    }
    func liveStreamApi(){
//        WebService.sharedInstance.goToLiveStream(){ (response) in
//            self.hostVc?.token = response.token
//            self.hostVc?.uid = response.uid
//        }
        
    }
}
