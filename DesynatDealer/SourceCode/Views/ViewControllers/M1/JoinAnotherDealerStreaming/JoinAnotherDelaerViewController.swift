//
//  JoinAnotherDelaerViewController.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 10/04/26.
//

import UIKit
import AgoraRtcKit

class JoinAnotherDelaerViewController: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var lblLive: UILabel!
    @IBOutlet weak var btnSwitch: UIButton!
    @IBOutlet weak var btnGoLive: UIButton!
    @IBOutlet weak var btnMute: UIButton!
    @IBOutlet weak var btnEnd: UIButton!
    @IBOutlet weak var lblWaiting: UILabel!
    @IBOutlet weak var muteView: UIView!
    @IBOutlet weak var lblUserCount: UILabel!
    @IBOutlet weak var vierwerCountView: CustomView!
    
    // MARK: - Agora
    var agoraKit: AgoraRtcEngineKit!
    var appID: String = "" //= "564c1a00b81c4d1c91d0a3a22db4a8bd"
    var channelName: String = ""// "live_stream"
    var token: String? = ""
    var uid: UInt = UInt.random(in: 1...9999)
    var isHost = false
    var isMuted = false
    private var userCountTimer: Timer?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAgora()
        if isHost {
            btnGoLive.isHidden = true
//            btnGoLive.isHidden = true
                    lblWaiting.isHidden = true
            vierwerCountView.isHidden = false
            muteView.isHidden = false
            
            // ... host setup
        } else {
            print("👀 Start as AUDIENCE")
            agoraKit.setClientRole(.audience)
            btnSwitch.isHidden = true
            btnGoLive.isHidden = true
            lblWaiting.isHidden = false
            vierwerCountView.isHidden = true
            muteView.isHidden = true
//                    lblWaiting.text = "Wait for the host to start the event"
        }
        joinChannel()
        startUserCountTimer()
    }
    
    deinit {
        cleanupAgora()
    }
    
    // MARK: - Agora Setup
    private func setupAgora() {
        print("🚀 Agora Init")
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: appID, delegate: self)
        agoraKit.setChannelProfile(.liveBroadcasting)
        agoraKit.enableVideo()
        agoraKit.enableAudio()
    }
    
    private func joinChannel() {
        print("🔗 Joining: \(channelName) | uid: \(uid)")
        agoraKit.joinChannel(byToken: token, channelId: channelName, info: nil, uid: uid) { channel, uid, elapsed in
            print("✅ Joined: \(channel) | uid: \(uid)")
        }
    }
    
    private func leaveChannel() {
        print("❌ Leaving channel")
        agoraKit.leaveChannel(nil)
    }
    
    // MARK: - VIDEO SETUP
    private func clearVideoView() {
        guard let view = videoView else {
            print("❌ videoView is nil")
            return
        }
        view.subviews.forEach { $0.removeFromSuperview() }
    }
    
    private func setupLocalVideo() {
        print("🎥 Local FULL SCREEN")
        clearVideoView()
        let canvas = AgoraRtcVideoCanvas()
        canvas.uid = uid
        canvas.view = videoView
        canvas.renderMode = .hidden
        agoraKit.setupLocalVideo(canvas)
        agoraKit.startPreview()
    }
    
    private func setupRemoteVideo(uid: UInt) {
        print("📺 Remote FULL SCREEN: \(uid)")
        clearVideoView()
        let canvas = AgoraRtcVideoCanvas()
        canvas.uid = uid
        canvas.view = videoView
        canvas.renderMode = .hidden
        agoraKit.setupRemoteVideo(canvas)
    }
    
    private func cleanupAgora() {
        print("🧹 Cleanup Agora")
        agoraKit.stopPreview()
        agoraKit.leaveChannel(nil)
        AgoraRtcEngineKit.destroy()
    }
    
    // MARK: - ACTIONS
    @IBAction func btnOptions(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            print("🔄 Switch Camera")
            agoraKit.switchCamera()
        case 2:
            print("🎬 Toggle Live")
            isHost.toggle()
            clearVideoView()
            if isHost {
                print("🎥 HOST MODE")
                agoraKit.setClientRole(.broadcaster)
                agoraKit.enableLocalVideo(true)
                setupLocalVideo()
                btnGoLive.setTitle("Stop", for: .normal)
            } else {
                print("👀 AUDIENCE MODE")
                agoraKit.setClientRole(.audience)
                agoraKit.stopPreview()
                btnGoLive.setTitle("Go Live", for: .normal)
                
            }
        case 3:
            isMuted.toggle()
            // Mute ALL remote audio streams (host's audio)
            agoraKit.muteAllRemoteAudioStreams(isMuted)
//            btnMute.setTitle(isMuted ? "Unmute Stream" : "Mute Stream", for: .normal)
            print("🔇 Stream \(isMuted ? "muted" : "unmuted")")
            lblLive.text = isMuted ? "Unmute" : "Mute"
        case 4:
            print("📴 End Stream")
            leaveChannel()
            dismiss(animated: false)
        default:
            break
        }
    }
    private func fetchTotalUsersFromAPI() {
            let urlString = "https://api.agora.io/dev/v1/channel/user/\(appID)/\(channelName)"
     
            guard let url = URL(string: urlString) else {
                print("❌ Invalid URL")
                return
            }
     
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Basic MGRkZjAzNTkzMDJjNGUzYjk5NTI4MmI0NDQ3MGUyNWU6YzI1OGMyZTBlNTc4NDIwZmJkYjBlNDNiYWY1YjFlZTM=", forHTTPHeaderField: "Authorization")
     
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                if let data = data {
                    print("🔍 RAW RESPONSE STRING:")
                    print(String(data: data, encoding: .utf8) ?? "Unable to decode")
                }
     
                if let error = error {
                    print("❌ Error:", error.localizedDescription)
                    return
                }
     
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("❌ JSON parse failed")
                    return
                }
     
                print("📌 Parsed JSON:", json)
     
                // FIX: Read values inside "data" dictionary
                guard let dataObj = json["data"] as? [String: Any] else {
                    print("❌ 'data' object missing")
                    return
                }
     
                let broadcasters = (dataObj["broadcasters"] as? [Any])?.count ?? 0
                let audience = (dataObj["audience"] as? [Any])?.count ?? 0
                let audienceTotal = dataObj["audience_total"] as? Int ?? audience
     
                let total = broadcasters + audienceTotal
     
                DispatchQueue.main.async {
                    self.lblUserCount.text = "Viewers: \(total)"
                    print("👥 TOTAL users: \(total) | Broadcasters: \(broadcasters) | Audience: \(audienceTotal)")
                }
     
            }.resume()
        }
     
        // Timer & API (same for host/audience)
        private func startUserCountTimer() {
            userCountTimer?.invalidate()
            userCountTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
                self.fetchTotalUsersFromAPI()
            }
            fetchTotalUsersFromAPI()  // Immediate fetch
        }
     
}

// MARK: - Agora Delegate
extension JoinAnotherDelaerViewController: AgoraRtcEngineDelegate {
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        print("👤 Remote Joined: \(uid)")
        if !isHost {
            DispatchQueue.main.async {
                self.lblWaiting.isHidden = true
                self.vierwerCountView.isHidden = false
                self.muteView.isHidden = false
                self.setupRemoteVideo(uid: uid)
            }
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        print("🚪 Remote Left: \(uid)")
        DispatchQueue.main.async {
            self.lblWaiting.isHidden = false
            self.vierwerCountView.isHidden = true
            self.lblWaiting.text = "Host has ended the streaming"
            self.muteView.isHidden = true
            self.clearVideoView()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1 ) {
                self.dismiss(animated: true)
            }
        }
    }
    
//    func rtcEngine(_ engine: AgoraRtcEngineKit, reportRtcStats stats: AgoraChannelStats) {
//            let totalUsers = Int(stats.userCount)
//            DispatchQueue.main.async {
//                self.lblUserCount.text = "Total Users: \(totalUsers)"
//                print("👥 Total users in channel: \(totalUsers)")  // Optional log
//            }
//        }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        print("❌ Agora Error: \(errorCode.rawValue)")
        self.lblWaiting.isHidden = false
        self.vierwerCountView.isHidden = true
        self.muteView.isHidden = true
    }
}
