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
    @IBOutlet weak var uploadContentButtonOutlet: UIButton!
    @IBOutlet weak var editButtonOutlet: UIButton!
    
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
        captionView.layer.cornerRadius = 12
        captionView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        captionView.clipsToBounds = true
        captiontxtArea.placeholderTextView = "Write caption here...".localiz()
        if isComingForEdit {
            configData()
            buttonTitleLabel.text = "Edit Reel".localiz()
            titleLabel.text = "Edit reel".localiz()
            uploadContentButtonOutlet.isHidden = true
            editButtonOutlet.isHidden = false
        } else {
            buttonTitleLabel.text = "Upload Reel".localiz()
            titleLabel.text = "Upload new reel".localiz()
            uploadContentButtonOutlet.isHidden = false
            editButtonOutlet.isHidden = true
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
            
//            let data = try Data(contentsOf: url)

            // 🔥 Print video size in MB/KB/Bytes
            let bytes = data.count
            let kb = Double(bytes) / 1024.0
            let mb = kb / 1024.0

            print("Video Size:")
            print("➡ Bytes: \(bytes)")
            print("➡ KB: \(String(format: "%.2f", kb)) KB")
            print("➡ MB: \(String(format: "%.2f", mb)) MB")
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
    
    @IBAction func uplaodContentButtonDidTapped(_ sender: Any) {
        showImagePickerOptions()
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
//                    let data = try Data(contentsOf: url)
                    let data = try Data(contentsOf: url)

                    // 🔥 Print video size in MB/KB/Bytes
                    let bytes = data.count
                    let kb = Double(bytes) / 1024.0
                    let mb = kb / 1024.0

                    print("Video Size:")
                    print("➡ Bytes: \(bytes)")
                    print("➡ KB: \(String(format: "%.2f", kb)) KB")
                    print("➡ MB: \(String(format: "%.2f", mb)) MB")
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
//            if let url = url {
//                // COMPRESS BEFORE LOADING DATA
//                self.compressVideo(inputURL: url) { compressedURL in
//                    guard let compressedURL = compressedURL else { return }
//
//                    do {
//                        let data = try Data(contentsOf: compressedURL)
//
//                        // Print size
//                        let bytes = data.count
//                        let kb = Double(bytes) / 1024.0
//                        let mb = kb / 1024.0
//                        print("Compressed Video Size:")
//                        print("➡ Bytes: \(bytes)")
//                        print("➡ KB: \(String(format: "%.2f", kb)) KB")
//                        print("➡ MB: \(String(format: "%.2f", mb)) MB")
//
//                        self.selectedMediaData = data
//                        self.isImageSelected = false
//                        self.videoURL = compressedURL
//                        self.playVideoButton.isHidden = false
//                        
//                        // Thumbnail
//                        CommonUtils.generateThumbnail(url: compressedURL) { thumbNailImage in
//                            self.imageView.image = thumbNailImage ?? UIImage(named: "video_placeholder")
//
//                            guard let data = thumbNailImage?.jpegData(compressionQuality: 0.25) else { return }
//                            self.viewModel.uploadMediaForGettingThumbnailImageUrl(fileData: data, isImage: true)
//                        }
//
//                    } catch {
//                        print("Video error:", error)
//                    }
//                }
//
//                return // avoid running IMAGE code
//            }
            
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
