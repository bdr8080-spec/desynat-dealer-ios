//
//  UploadPostViewController.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 31/03/26.
//

import UIKit
import AVFoundation
import AVKit

class UploadPostViewController: UIViewController {
    
    @IBOutlet weak var imageView: CustomImageView!
    @IBOutlet weak var playButton: UIButton!
    
    var selectedImage: UIImage?
    var videoURL: URL?
    var thumbnailImage: String?
    lazy var viewModel = UploadStoryViewModel(hostVc: self)
    var comingReason: ComingReasonAtPromoteStory = .fromProfile
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let videoURL = videoURL {
            guard let data = selectedImage?.jpegData(compressionQuality: 0.25) else { return }
            self.viewModel.uploadMediaForGettingThumbnailImageUrl(fileData: data, isImage: true)
            self.imageView.image = selectedImage
            self.playButton.isHidden = false
        } else {
            imageView.image = selectedImage
            playButton.isHidden = true
        }
    }
    
    
    // MARK: - Navigation
    
    @IBAction func backBtnDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func postBtnDidTapped(_ sender: Any) {
        if let image = selectedImage, videoURL == nil {
            if let imageData = image.jpegData(compressionQuality: 0.7) {
                viewModel.uploadMedia(fileData: imageData, isImage: true)
            }
        } else if let videoURL = videoURL {
            compressAndUploadVideo(videoURL: videoURL)
        }
    }
    
    @IBAction func playBtnOfVideo(_ sender: Any) {
        playVideo()
    }
    
    
    @objc func playVideo() {
        guard let url = videoURL else { return }
        let player = AVPlayer(url: url)
        let vc = AVPlayerViewController()
        vc.player = player
        present(vc, animated: true) {
            player.play()
        }
    }
    
    func saveImageAndGetURLString(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.7) else {
            return nil
        }
        let fileName = "thumb_\(UUID().uuidString).jpg"
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        do {
            try data.write(to: fileURL)
            return fileURL.absoluteString
        } catch {
            return nil
        }
    }
    
    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(playVideo))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
    }
    
    func compressAndUploadVideo(videoURL: URL) {
        let avAsset = AVURLAsset(url: videoURL)
        guard let exportSession = AVAssetExportSession(asset: avAsset,
                                                       presetName: AVAssetExportPresetMediumQuality) else {
            return
        }
        let outputURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("compressed_\(UUID().uuidString).mov")
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { [weak self] in
            guard let self = self else { return }
            switch exportSession.status {
            case .completed:
                do {
                    let videoData = try Data(contentsOf: outputURL)
                    DispatchQueue.main.async {
                        self.viewModel.uploadMedia(fileData: videoData, isImage: false)
                    }
                } catch {
                    print("Video data error:", error)
                }
            case .failed:
                print("Compression failed:", exportSession.error ?? "")
            default:
                break
            }
        }
    }
    
}
