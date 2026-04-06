//
//  MyProfileRellsViewController.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 01/04/26.
//

import UIKit
import AVFoundation
import AVKit
import SDWebImage

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
    var thumbnailImage: String?
    
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
        
        let fileString = data.file ?? ""
        let thumbnailString = data.thumbnail ?? ""
 
        // Detect video
        let isVideo = fileString.lowercased().contains(".mp4")
 
        // Decide which URL to load
        let finalURLString = isVideo ? thumbnailString : fileString
        let url = URL(string: finalURLString)
        if isVideo {
            videoURL = URL(string: data.file ?? "")
        }
        playVideoButton.isHidden = !isVideo
        // Loader
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageView.sd_imageIndicator?.startAnimatingIndicator()
 
        // Set image
        imageView.sd_setImage(
            with: url,
            placeholderImage: UIImage(named: "editUploaddReel")
        )
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



