//
//  UploadNewReelViewController.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 31/03/26.
//

import UIKit
import AVFoundation
import AVKit

class UploadNewReelViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var imageView: CustomImageView!
    @IBOutlet weak var captiontxtArea: UITextView!
    @IBOutlet weak var captionView: UIView!
    @IBOutlet weak var playVideoButton: UIButton!
    @IBOutlet weak var buttonTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties
    let imagePicker = ImagePickerManager()
    private lazy var viewModel = UploadReelViewModel(hostVc: self)
    var selectedMediaData: Data?
    var isImageSelected: Bool = true
    var videoURL: URL?
    var isComingForEdit: Bool = false
    var reelsData: GetMyReelsList?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        captionView.layer.cornerRadius = 8
        captionView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        captionView.clipsToBounds = true
        if isComingForEdit {
            configData()
            buttonTitleLabel.text = "Edit Reel"
            titleLabel.text = "Edit reel"
        } else {
            buttonTitleLabel.text = "Upload Reel"
            titleLabel.text = "Upload new reel"
        }
    }
    
    // MARK: - Actions
    
    @IBAction func backbtnTapped(_ sender: Any) {
        self.navigationController?.popToViewController(ofClass: DelearProfileViewController.self, animated: true)
    }
    
    // Select Image / Video
    @IBAction func uploadBtnTapped(_ sender: UIButton) {
        showImagePickerOptions()
    }
    
    // Final Upload
    @IBAction func uploadReelBtnTapped(_ sender: Any) {
        guard viewModel.isValid() else { return }
        guard let data = selectedMediaData else { return }
        viewModel.uploadMedia(fileData: data, isImage: false)
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
    
    func configData() {
        
        guard let data = reelsData,
              let fileURLString = data.file,
              let url = URL(string: fileURLString) else {
            imageView.image = UIImage(named: "placeholder")
            playVideoButton.isHidden = true
            return
        }
        
        let isVideo = fileURLString.lowercased().contains(".mp4")
        
        if isVideo {
            // VIDEO
            videoURL = url
            playVideoButton.isHidden = false
            
            imageView.image = UIImage(named: "placeholder")
            CommonUtils.generateThumbnail(url: url) { [weak self] thumbnail in
                DispatchQueue.main.async {
                    self?.imageView.image = thumbnail ?? UIImage(named: "placeholder")
                }
            }
            
        } else {
            // IMAGE
            videoURL = nil
            playVideoButton.isHidden = true
            imageView.sd_setImage(
                with: url,
                placeholderImage: UIImage(named: "placeholder"),
                options: [.retryFailed, .scaleDownLargeImages]
            )
        }
        captiontxtArea.text = data.caption
        captiontxtArea.placeholderTextView = ""
        selectedMediaData = stringToData(data.file ?? "")
    }
    
    func stringToData(_ string: String) -> Data {
        guard let data = string.data(using: .utf8) else {
            fatalError("Failed to convert String to Data")
        }
        return data
    }
}

// MARK: - Image Picker

extension UploadNewReelViewController {
    
    func showImagePickerOptions() {
        
        imagePicker.pickMedia(self) { [weak self] image, fileName, url in  // Changed from pickImage to pickMedia
            guard let self = self else { return }
            
            // VIDEO
            if let url = url {
                do {
                    let data = try Data(contentsOf: url)
                    
                    self.selectedMediaData = data
                    self.isImageSelected = false
                    videoURL = url
                    playVideoButton.isHidden = false
                    // Generate thumbnail
                    CommonUtils.generateThumbnail(url: url) { image in
                        self.imageView.image = image ?? UIImage(named: "video_placeholder")
                    }
                    
                } catch {
                    print("Video error:", error)
                }
            }
            
            // IMAGE
            else {
                guard let data = image.jpegData(compressionQuality: 0.25) else { return }
                
                self.selectedMediaData = data
                self.isImageSelected = true
                self.imageView.image = image
                videoURL = nil
                playVideoButton.isHidden = true
            }
        }
        
    }
}
