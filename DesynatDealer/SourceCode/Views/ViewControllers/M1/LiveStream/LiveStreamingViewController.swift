import UIKit
import AgoraRtcKit

class LiveStreamingViewController: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var lblLive: UILabel!
    @IBOutlet weak var btnSwitch: UIButton!
    @IBOutlet weak var btnGoLive: UIButton!
    @IBOutlet weak var btnMute: UIButton!
    @IBOutlet weak var muteLabel: UILabel!
    @IBOutlet weak var btnEnd: UIButton!
    
    // MARK: - Agora
    var agoraKit: AgoraRtcEngineKit!
    var appID: String = ""
    var channelName: String = ""
    var token: String?
    var uid: UInt = UInt.random(in: 1...9999)
    var isHost = false
    var isMuted = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAgora()
        if isHost {
            btnGoLive.isHidden = true
            print("🎥 Start as HOST")
            agoraKit.setClientRole(.broadcaster)
            setupLocalVideo()
        } else {
            print("👀 Start as AUDIENCE")
            agoraKit.setClientRole(.audience)
//            lblLive.isHidden = true
            btnSwitch.isHidden = true
            btnGoLive.isHidden = true
        }
        joinChannel()
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
      //  print("🔗 Joining: \(channelName) | uid: \(uid)")
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
            agoraKit.muteLocalAudioStream(isMuted)
//            btnMute.setTitle(isMuted ? "Unmute" : "Mute", for: .normal)
            print("🎙️ Muted: \(isMuted)")
            muteLabel.text = isMuted ? "Unmute" : "Mute"
        case 4:
            print("📴 End Stream")
            leaveChannel()
            dismiss(animated: false)
        default:
            break
        }
    }
}

// MARK: - Agora Delegate
extension LiveStreamingViewController: AgoraRtcEngineDelegate {
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        print("👤 Remote Joined: \(uid)")
        if !isHost {
            DispatchQueue.main.async {
                self.setupRemoteVideo(uid: uid)
            }
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        print("🚪 Remote Left: \(uid)")
        DispatchQueue.main.async {
            self.clearVideoView()
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        print("❌ Agora Error: \(errorCode.rawValue)")
    }
}
