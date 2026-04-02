//
//  DelearProfileViewModel.swift
//  DesynatDealer
//
//  Created by fluper on 06/12/25.
//

import UIKit

class DelearProfileViewModel {
    
    private var hostVC: DelearProfileViewController
    
    // PROFILE
    var userProfile: SellerProfileDataModel?
    
    // HIGHLIGHTS PAGINATION
    var highlightList: [GetHighLightsList]?
    var highlightPage: Int = 1
    var highlightLoading = false
    var highlightHasMore = true
    
    // REELS PAGINATION
    var reelsList: [GetMyReelsList]?
    var reelsPage: Int = 1
    var reelsLoading = false
    var reelsHasMore = true
    
    init(hostVC: DelearProfileViewController) {
        self.hostVC = hostVC
    }
    
    // MARK: - Reset Pagination
    func resetPagination() {
        highlightPage = 1
        highlightList = []
        highlightHasMore = true
        highlightLoading = false
        
        reelsPage = 1
        reelsList = []
        reelsHasMore = true
        reelsLoading = false
    }
    
    // -----------------------------------------
    // MARK: GET USER PROFILE
    // -----------------------------------------
    func getUserProfile() {
        WebService.sharedInstance.getUserProfile { [weak self] response in
            guard let self else { return }
            userProfile = response
            hostVC.populateData()
        }
    }
    
    // -----------------------------------------
    // MARK: GET HIGHLIGHTS WITH PAGINATION
    // -----------------------------------------
    func getMyHighLights() {
        if highlightLoading || !highlightHasMore { return }
        
        highlightLoading = true
        
        let params: [String: Any] = [
            "page": highlightPage,
            "limit": 20
        ]
        
        WebService.sharedInstance.getMyHighLights(param: params) { [weak self] data in
            guard let self = self else { return }
            
            let newData = data.data ?? []
            
            if self.highlightPage == 1 {
                self.highlightList = newData
            } else {
                self.highlightList?.append(contentsOf: newData)
            }
            
            self.highlightHasMore = !newData.isEmpty
            if self.highlightHasMore {
                self.highlightPage += 1
            }
            
            self.highlightLoading = false
            
            DispatchQueue.main.async {
                self.hostVC.storiesCollectionView.reloadData()
            }
        }
    }
    
    // Same for reels...
    func getMyReelsRequest() {
        if reelsLoading || !reelsHasMore { return }
        
        reelsLoading = true
        
        let params: [String: Any] = [
            "page": reelsPage,
            "limit": 20
        ]
        
        WebService.sharedInstance.getMyReels(param: params) { [weak self] data in
            guard let self = self else { return }
            
            let newData = data.data ?? []
            
            if self.reelsPage == 1 {
                self.reelsList = newData
            } else {
                self.reelsList?.append(contentsOf: newData)
            }
            
            self.reelsHasMore = !newData.isEmpty
            if self.reelsHasMore {
                self.reelsPage += 1
            }
            
            self.reelsLoading = false
            
            DispatchQueue.main.async {
                self.hostVC.reelsCollectionView.reloadData()
                
                // Small delay to ensure layout is calculated after reloadData
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.hostVC.updateReelsHeight()
                }
            }
        }
    }
}
