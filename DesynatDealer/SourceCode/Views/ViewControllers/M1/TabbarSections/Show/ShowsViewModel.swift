//
//  ShowsViewModel.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 03/04/26.
//

import Foundation


class ShowsViewModel {
    
    
    private var hostVC: ShowsViewController
    var AllLiveStraming: LiveStramingDataModel?
    var stramingData: AgroaTokenDataModel?
    var liveEventListData: [ShowLiveEvenetsDataModel] = []
    var currentPage = 1
    var lastPage = 1
    var hasMorePages = true
    var isFetching = false
    
    init(hostVC: ShowsViewController) {
        self.hostVC = hostVC
    }
    
    func getAllLiveStreamingRequest() {
        WebService.sharedInstance.getAllLiveStramingService { [weak self] response in
            guard let self = self else { return }
            
            // Store the response
            self.AllLiveStraming = response
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let currentRequests = self.AllLiveStraming?.currentRequests ?? []
                let hasCurrentRequests = !currentRequests.isEmpty
                if hasCurrentRequests {
                    self.generateLiveStramingTokenRequest(id: currentRequests.first?.id ?? 0)
                    self.hostVC.btnGoLive.isHidden = false
                    
                    let firstRequest = currentRequests.first

                    let isLive = isEventLive(
                        dateString: firstRequest?.timeslotDetails?.date,
                        fromTime: firstRequest?.timeslotDetails?.from,
                        toTime: firstRequest?.timeslotDetails?.to
                    )
                    hostVC.btnGoLive.isUserInteractionEnabled = isLive
                    hostVC.btnGoLive.alpha = isLive ? 1.0 : 0.5   // dim when disabled
                } else{
                    self.hostVC.btnGoLive.isHidden = true
                }
            }
        }
    }
    
    func isEventLive(dateString: String?, fromTime: String?, toTime: String?) -> Bool {
        guard let dateString = dateString,
              let fromTime = fromTime,
              let toTime = toTime else { return false }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        // ✅ Server timezone (Kuwait)
        formatter.timeZone = TimeZone(identifier: "Asia/Kuwait")
        formatter.dateFormat = "yyyy-MM-dd hh:mm a"

        let startString = "\(dateString) \(fromTime)"
        let endString = "\(dateString) \(toTime)"

        guard let startDate = formatter.date(from: startString),
              let endDate = formatter.date(from: endString) else {
            print("Parsing failed:", startString, endString)
            return false
        }

        let now = Date() // local time but comparable correctly via absolute Date

        return now >= startDate && now <= endDate
    }
    
//    func isEventLive(dateString: String?, fromTime: String?, toTime: String?) -> Bool {
//            guard let dateString = dateString,
//                  let fromTime = fromTime,
//                  let toTime = toTime else { return false }
//     
//            let formatter = DateFormatter()
//            formatter.locale = Locale(identifier: "en_US_POSIX")
//            formatter.dateFormat = "yyyy-MM-dd hh:mm a"  // <-- IMPORTANT (12 hr + AM/PM)
//     
//            let startString = "\(dateString) \(fromTime)"
//            let endString = "\(dateString) \(toTime)"
//     
//            guard let startDate = formatter.date(from: startString),
//                  let endDate = formatter.date(from: endString) else {
//                print("Parsing failed for:", startString, endString)
//                return false
//            }
//     
//            let now = Date()
//            return now >= startDate && now <= endDate
//        }
    
    func generateLiveStramingTokenRequest(id: Int) {
        let param: [String:Any] = ["id": id,
                                   "role" : 2]
        WebService.sharedInstance.goToLiveStream(param: param) { [weak self] response in
            guard let self = self else { return }
            stramingData = response
        }
    }
    
    func generateLiveStramingTokenRequestForAsAudience(id: Int) {
        let param: [String:Any] = ["id": id, "role": 1]
        WebService.sharedInstance.goToLiveStream(param: param) { [weak self] response in
            guard let self = self else { return }
            let nextVC = JoinAnotherDelaerViewController.instantiate(fromAppStoryboard: .Home)
            nextVC.isHost = false
            nextVC.token = response.token
            nextVC.uid = response.uid ?? UInt.random(in: 1...9999)
            nextVC.appID = response.appID ?? ""
            nextVC.channelName = response.channel ?? ""
            nextVC.modalPresentationStyle = .fullScreen
            self.hostVC.navigationController?.present(nextVC, animated: false)
        }
    }
    
    func dealerAllLiveRequest() {
        WebService.sharedInstance.delaersLiveService(){ [weak self] response in
            guard let self = self else { return }
            liveEventListData = response
            hostVC.listTableView.reloadData()
            hostVC.noDataFoundLabel.isHidden = !response.isEmpty
        }
    }
    
    func navigateToNextScreen(response: AgroaTokenDataModel?) {
        let nextVC = LiveStreamingViewController.instantiate(fromAppStoryboard: .Home)
        nextVC.isHost = true
        nextVC.token = response?.token
        nextVC.uid = response?.uid ?? UInt.random(in: 1...9999)
        nextVC.appID = response?.appID ?? ""
        nextVC.channelName = response?.channel ?? ""
        nextVC.modalPresentationStyle = .fullScreen
        self.hostVC.navigationController?.present(nextVC, animated: false)
    }
}
