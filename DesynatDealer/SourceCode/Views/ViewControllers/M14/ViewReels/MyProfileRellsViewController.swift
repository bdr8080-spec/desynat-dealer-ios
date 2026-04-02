//
//  MyProfileRellsViewController.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 01/04/26.
//

import UIKit
import AVFoundation
import AVKit

class MyProfileRellsViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var imageView: CustomImageView!
    @IBOutlet weak var captiontxtArea: UILabel!
    @IBOutlet weak var captionView: UIView!
    @IBOutlet weak var playVideoButton: UIButton!
    @IBOutlet weak var toggleButtonOutlet: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var addedDateLabel: UILabel!
    
    // MARK: - Properties
    private lazy var viewModel = MyProfileRellsViewModel(hostVC: self)
    var reelsData: GetMyReelsList?
    private var videoURL: URL?
    
    // Loader
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configData()
    }
    
    private func setupUI() {
        captionView.layer.cornerRadius = 8
        captionView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        captionView.clipsToBounds = true
        
        // Setup Loader
        activityIndicator.color = .gray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    // MARK: - Config Data (For Existing Reel)
    func configData() {
        guard let data = reelsData else { return }
        
        captiontxtArea.text = data.caption ?? ""
        addedDateLabel.text = formatAddedOnDate(data.createdAt ?? "")
        
        // Status
        if data.status == 1 {
            toggleButtonOutlet.setImage(.toggleOn, for: .normal)
            statusLabel.text = "Active"
        } else {
            toggleButtonOutlet.setImage(.toggleOff, for: .normal)
            statusLabel.text = "Inactive"
        }
        
        // Handle Media
        guard let fileURLString = data.file,
              let url = URL(string: fileURLString) else {
            imageView.image = UIImage(named: "placeholder")
            playVideoButton.isHidden = true
            return
        }
        
        let isVideo = fileURLString.lowercased().hasSuffix(".mp4") ||
                      fileURLString.lowercased().contains(".mp4")
        
        if isVideo {
            videoURL = url
            playVideoButton.isHidden = false
            
            // Show placeholder + Start Loader
            imageView.image = UIImage(named: "placeholder")
            activityIndicator.startAnimating()
            
            // Generate thumbnail with loader
            generateVideoThumbnail(from: url) { [weak self] thumbnail in
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.imageView.image = thumbnail ?? UIImage(named: "placeholder")
                }
            }
        } else {
            // It's an Image
            playVideoButton.isHidden = true
            activityIndicator.stopAnimating() // just in case
            imageView.sd_setImage(with: url,
                                  placeholderImage: UIImage(named: "placeholder"),
                                  options: [.retryFailed, .scaleDownLargeImages])
        }
    }
    
    // MARK: - Reliable Async Thumbnail Generator
    private func generateVideoThumbnail(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let asset = AVURLAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.maximumSize = CGSize(width: 800, height: 800)
        
        let times = [
            CMTime.zero,
            CMTime(seconds: 1, preferredTimescale: 600),
            CMTime(seconds: 2, preferredTimescale: 600),
            CMTime(seconds: 3, preferredTimescale: 600)
        ]
        
        imageGenerator.generateCGImagesAsynchronously(forTimes: times.map { NSValue(time: $0) }) {
            requestedTime, cgImage, actualTime, result, error in
            
            if let cgImage = cgImage, result == .succeeded {
                let thumbnail = UIImage(cgImage: cgImage)
                completion(thumbnail)
                return
            }
            
            if let error = error {
                print("Thumbnail attempt at \(requestedTime.seconds)s failed: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Date Formatter (unchanged)
    func formatAddedOnDate(_ input: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        
        guard let date = formatter.date(from: input) else {
            return "Added On -"
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        outputFormatter.dateFormat = "dd/MM/yyyy"
        
        let formatted = outputFormatter.string(from: date)
        return "Added On \(formatted)"
    }
    
    // MARK: - Actions (unchanged)
    @IBAction func backbtnTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func playBtnOfVideo(_ sender: Any) {
        guard let url = videoURL else { return }
        let player = AVPlayer(url: url)
        let vc = AVPlayerViewController()
        vc.player = player
        present(vc, animated: true) {
            player.play()
        }
    }
    
    @IBAction func toggleDidTapped(_ sender: Any) {
        viewModel.updateMyReelsStatusRequest()
    }
    
    @IBAction func editDidTapped(_ sender: Any) {
        let nextVC = UploadNewReelViewController.instantiate(fromAppStoryboard: .Profile)
        nextVC.isComingForEdit = true
        nextVC.reelsData = self.reelsData
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func deleteDidTapped(_ sender: Any) {
        self.showConfirmationAlert(msg: "Are you sure you want to delete this reel?") { [weak self] in
            guard let self = self else { return }
            self.viewModel.deleteReel()
        }
    }
}



