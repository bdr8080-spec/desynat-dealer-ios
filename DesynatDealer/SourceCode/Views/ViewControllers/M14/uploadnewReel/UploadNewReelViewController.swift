//
//  UploadNewReelViewController.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 31/03/26.
//

import UIKit
import AVFoundation
import AVKit
import SDWebImage

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
    var existingMediaURL: String?
    var thumbnailImage: String?
    
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
        
        // ✅ New media selected
        if let data = selectedMediaData {
            viewModel.uploadMedia(fileData: data, isImage: isImageSelected)
        }
        
        // ✅ Edit without changing media
        else if let url = existingMediaURL {
            if isComingForEdit {
                viewModel.editReel(mediaUrl: url)
            } else {
                viewModel.uploadReel(mediaUrl: url)
            }
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
            thumbnailImage = data.thumbnail
            imageView.image = UIImage(named: "placeholder")
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            imageView.sd_imageIndicator?.startAnimatingIndicator()
            guard
                let thumbnailLink = data.thumbnail,
                let thumbnailURL = URL(string: thumbnailLink) else {
                
                return
            }
            imageView.sd_setImage(
                with: thumbnailURL,
                placeholderImage: UIImage(named: "placeholder")
            )
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
        
        existingMediaURL = data.file
        selectedMediaData = nil
        // selectedMediaData = stringToData(data.file ?? "")
    }
    func saveImageAndGetURLString(_ image: UIImage?) -> String? {
        //  Check image exists
        guard let image = image,
              let data = image.jpegData(compressionQuality: 0.7) else {
            return nil
        }
        
        let fileName = "thumb_\(UUID().uuidString).jpg"
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            return fileURL.absoluteString
        } catch {
            print("Error saving image:", error.localizedDescription)
            return nil
        }
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
                    CommonUtils.generateThumbnail(url: url) { thumbNailImage in
                        self.imageView.image = thumbNailImage ?? UIImage(named: "video_placeholder")
                        guard let data = thumbNailImage?.jpegData(compressionQuality: 0.25) else { return }
                        self.viewModel.uploadMediaForGettingThumbnailImageUrl(fileData: data, isImage: true)
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
