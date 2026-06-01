//
//  StoryViewerViewController.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 27/03/26.
//

import UIKit
import AVFoundation

class StoryViewerViewController: UIViewController {
    
    @IBOutlet weak var highlightTitleLabel: UILabel!
    @IBOutlet weak var highlightTitleView: CustomView!
    @IBOutlet weak var storiesCollectionView: UICollectionView!
    @IBOutlet weak var topSliderCollectionView: UICollectionView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var uploadedTimeLabel: UILabel!
    @IBOutlet weak var uploadedTimeView: CustomView!
    
    // MARK: - Variables
    var usersStory: [Story] = []
    var currentStoryIndex = 0
    
    //    let leftTapView = UIView()
    //    let rightTapView = UIView()
    private var videoTimeObserver: Any?
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    private var seenStories: Set<Int> = []
    private var progressTimer: Timer?
    private var currentProgress: CGFloat = 0.0
    
    var viewModel = StoryViewerViewModel()
    var sellerId = Int()
    var selectedIndex: Int = 0
    var selectedStory: SellerHighlightsModel?
    var comingFor: ComingReasonAtStoryViewer = .forAdminStory
    var onCompletion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupCollectionViews()
        switch comingFor {
        case .forAdminStory:
            fetchAdminStoriesFrom()
            highlightTitleView.isHidden = true
            deleteButton.isHidden = true
        case .forSelfStory:
            fetchSelfStories()
            highlightTitleView.isHidden = true
            deleteButton.isHidden = false
        case .forSelfHighlight:
            fetchSelfHighlight()
            highlightTitleView.isHidden = false
            deleteButton.isHidden = false
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture.cancelsTouchesInView = false
        storiesCollectionView.addGestureRecognizer(tapGesture)
        //        setupTapViews()
    }
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: storiesCollectionView)
        let width = storiesCollectionView.frame.width
        
        if location.x > width / 2 {
            goToNextStory()
        } else {
            goToPreviousStory()
        }
    }
    
    func goToNextStory() {
        
        invalidateProgressTimer()
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        
        guard currentStoryIndex < usersStory.count - 1 else {
            closeScreen()
            return
        }
        
        currentStoryIndex += 1
        scrollToCurrentStory(animated: false)
    }
    
    private func goToPreviousStory() {
        invalidateProgressTimer()
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        
        guard currentStoryIndex > 0 else { return }
        
        currentStoryIndex -= 1
        scrollToCurrentStory(animated: false)
    }
    
    private func scrollToCurrentStory(animated: Bool) {
        resetSliderForBackwardNavigation()
        
        let indexPath = IndexPath(item: currentStoryIndex, section: 0)
        storiesCollectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: animated
        )
        
        // ✅ Wait for scroll completion before configuring
        DispatchQueue.main.asyncAfter(deadline: .now() + (animated ? 0.3 : 0.1)) {
            self.configureAndStartCurrentStory()
        }
    }
    
    private func configureAndStartCurrentStory() {
        guard let story = usersStory[safe: currentStoryIndex] else { return }
        if comingFor == .forSelfHighlight {
            highlightTitleLabel.text = viewModel.sellerHighlight[safe: currentStoryIndex]?.title ?? ""
        }
        markCurrentStoryAsSeen()
        uploadedTimeView.isHidden = false
        uploadedTimeLabel.text = ContentUpladedTimeDuration(from: story.uploadedTime ?? "")
        // Get the NOW visible cell (after scroll completes)
        guard let cell = storiesCollectionView.visibleCells
            .compactMap({ $0 as? StorieDetailsCollectionViewCell })
            .first else { return }
        
        // Clean previous content
        cell.mainImageView.image = nil
        cell.mainImageView.layer.sublayers?.removeAll()
        CommonUtils.showHud(show: true)
        // Configure with completion callback
        configureCell(cell, with: story) { [weak self] in
            guard let self = self else { return }
            
            self.resetSliderForBackwardNavigation()
            self.updateTopSliderProgress()
            
            // Start progress tracking
            if story.isVideo {
                self.startVideoProgressObserver()
            } else {
                self.startImageProgressAnimation(duration: story.duration ?? 10.0)
            }
        }
    }
    
    // MARK: - Cell Configuration
    private func configureCell(_ cell: StorieDetailsCollectionViewCell, with story: Story, completion: @escaping (() -> Void)) {
        // Global cleanup
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        cell.mainImageView.image = nil
        cell.mainImageView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        if story.isVideo {
            let videoURLString = story.url ?? ""
            if !videoURLString.isEmpty {
                playVideo(in: cell, urlString: videoURLString, completion: completion)
            } else {
                completion()
            }
        } else {
            let imageURLString = story.url ?? ""
            if !imageURLString.isEmpty {
                loadImage(in: cell, urlString: imageURLString, completion: completion)
            } else {
                completion()
            }
        }
    }
    
    // MARK: - Progress Helpers
    private func startImageProgressAnimation(duration: TimeInterval) {
        invalidateProgressTimer()
        currentProgress = 0
        let interval: TimeInterval = 0.016
        let increment = CGFloat(interval / duration)
        progressTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            self.currentProgress += increment
            
            if self.currentProgress >= 1.0 {
                self.currentProgress = 1.0
                self.updateTopSliderProgress()
                self.invalidateProgressTimer()
                self.goToNextStory()
                self.sliderCheck = false
                return
            }
            
            self.updateTopSliderProgress()
        }
    }
    
    private func startVideoProgressObserver() {
        guard let player = player,
              player.currentItem?.status == .readyToPlay else {
            //            print("❌ Video not ready yet")
            return
        }
        
        // ✅ CRITICAL: Remove previous observer first
        removeVideoTimeObserver()
        
        let interval = CMTime(seconds: 0.03, preferredTimescale: 600)  // 30fps smooth
        
        videoTimeObserver = player.addPeriodicTimeObserver(
            forInterval: interval,
            queue: .main
        ) { [weak self] time in
            self?.updateVideoProgress(time: time)
        }
        
        //        print("✅ Video observer started")
    }
    
    private func removeVideoTimeObserver() {
        if let observer = videoTimeObserver {
            player?.removeTimeObserver(observer)
            videoTimeObserver = nil
        }
    }
    private func updateVideoProgress(time: CMTime) {
        guard let player = player,
              let currentItem = player.currentItem,
              currentItem.duration.seconds.isFinite && currentItem.duration.seconds > 0 else {
            return
        }
        
        let progress = min(1.0, max(0.0, time.seconds / currentItem.duration.seconds))
        currentProgress = CGFloat(progress)
        updateTopSliderProgress()
    }
    
    private func startCurrentStory() {
        guard !usersStory.isEmpty, currentStoryIndex < usersStory.count else { return }
        scrollToCurrentStory(animated: false)
    }
    
    private func updateTopSliderProgress() {
        let visibleIndexPaths = topSliderCollectionView.indexPathsForVisibleItems
        for indexPath in visibleIndexPaths {
            if let sliderCell = topSliderCollectionView.cellForItem(at: indexPath) as? StorieTopSliderCollectionViewCell {
                let isActive = (indexPath.item == currentStoryIndex)
                let isSeen = seenStories.contains(indexPath.item)
                let progress: CGFloat = isActive ? currentProgress : 0.0
                sliderCell.configure(isActive: isActive, isSeen: isSeen, progress: progress)
            }
        }
    }
    
    private func ContentUpladedTimeDuration(from isoString: String) -> String {
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = formatter.date(from: isoString) else { return "" }
        
        let secondsAgo = Int(Date().timeIntervalSince(date))
        
        if secondsAgo < 60 {
            let text = "sec ago".localiz()
            return secondsAgo == 1 ? "1 sec ago".localiz() : "\(secondsAgo) \(text)"
        }
        
        let minutes = secondsAgo / 60
        if minutes < 60 {
            let text = "min ago".localiz()
            return minutes == 1 ? "1 min ago".localiz() : "\(minutes) \(text)"
        }
        
        let hours = minutes / 60
        if hours < 24 {
            let text = "hr ago".localiz()
            return hours == 1 ? "1 hr ago".localiz() : "\(hours) \(text)"
        }
        
        let days = hours / 24
        if days == 1 { return "Yesterday".localiz() }
        let text = "days ago".localiz()
        return "\(days) \(text)"
    }
    
    private func invalidateProgressTimer() {
        progressTimer?.invalidate()
        progressTimer = nil
        removeVideoTimeObserver()  // ✅ Video cleanup
    }
    
    // MARK: - Image & Video
    private func loadImage(in cell: StorieDetailsCollectionViewCell, urlString: String, completion: @escaping (() -> Void)) {
        guard let url = URL(string: urlString) else {
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak cell] data, _, _ in
            guard let data = data,
                  let image = UIImage(data: data),
                  let cell = cell else {
                DispatchQueue.main.async { completion() }
                return
            }
            CommonUtils.showHud(show: false)
            DispatchQueue.main.async {
                cell.mainImageView.image = image
                completion()
            }
        }.resume()
    }
    
    // ✅ FIXED: Updated playVideo with completion handler
    private func playVideo(in cell: StorieDetailsCollectionViewCell, urlString: String, completion: @escaping (() -> Void)) {
        guard let url = URL(string: urlString) else {
            completion()
            return
        }
        
        // Clean up previous player
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = cell.mainImageView.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        
        cell.mainImageView.layer.insertSublayer(playerLayer!, at: 0)
        
        // Listen for ready state BEFORE play
        player?.addObserver(self, forKeyPath: "timeControlStatus", options: [.new], context: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(videoDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )
        CommonUtils.showHud(show: false)
        player?.play()
        
        // Call completion when video is ready (handled in observeValue)
    }
    
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        
        if keyPath == "timeControlStatus",
           let player = object as? AVPlayer {
            
            switch player.timeControlStatus {
            case .playing:
                //                print("✅ Video playing - starting progress")
                player.isMuted = false
                
                // ✅ CRITICAL: Start observer NOW (video ready)
                startVideoProgressObserver()
                
                // Call completion to start other logic
                onCompletion?()
                
            case .waitingToPlayAtSpecifiedRate:
                print("⏳ Video buffering...")
                
            case .paused:
                print("⏸ Video paused")
                
            @unknown default:
                break
            }
        }
    }
    deinit {
        removeVideoTimeObserver()
        player?.removeObserver(self, forKeyPath: "timeControlStatus")
        NotificationCenter.default.removeObserver(self)
    }
    @objc private func videoDidFinishPlaying() {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        goToNextStory()
    }
    
    
    
    func fetchSelfStories() {
        
        // 👉 sellerId pass karo (yaha dynamic bhi kar sakte ho)
        viewModel.getSelfStory() { [weak self] in
            guard let self = self else { return }
            
            self.usersStory = self.viewModel.sellerStories.compactMap { item in
                
                guard let url = item.file else { return nil }
                
                let lowerURL = url.lowercased()
                
                let isVideo = lowerURL.hasSuffix(".mp4") ||
                lowerURL.hasSuffix(".mov") ||
                lowerURL.contains(".m3u8")
                
                return Story(
                    url: url,
                    isVideo: isVideo,
                    duration: isVideo ? nil : 10.0,
                    uploadedTime: item.createdAt
                )
            }
            
//            DispatchQueue.main.async {
//                
//                if self.usersStory.isEmpty {
//                    self.dismiss(animated: true)
//                    return
//                }
//                
//                self.storiesCollectionView.reloadData()
//                self.topSliderCollectionView.reloadData()
//                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                    self.startCurrentStory()
//                }
//            }
            
            DispatchQueue.main.async {
                if self.usersStory.isEmpty {
                    self.dismiss(animated: true)
                    return
                }

                // Open first unseen story
                if let firstUnseenIndex = self.viewModel.sellerStories.firstIndex(where: {
                    $0.isSeen == 0
                }) {
                    self.currentStoryIndex = firstUnseenIndex
                } else {
                    // All stories already seen
                    self.currentStoryIndex = 0
                }

                // Mark previous stories as already seen in slider
                for i in 0..<self.currentStoryIndex {
                    self.seenStories.insert(i)
                }

                self.storiesCollectionView.reloadData()
                self.topSliderCollectionView.reloadData()

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.startCurrentStory()
                }
            }
        }
    }
    
    func fetchSelfHighlight() {
        
        viewModel.getSelfHighlight() { [weak self] in
            guard let self = self else { return }
            
            self.usersStory = self.viewModel.sellerHighlight.compactMap { item in
                
                guard let url = item.file else { return nil }
                
                let lowerURL = url.lowercased()
                
                let isVideo = lowerURL.hasSuffix(".mp4") ||
                lowerURL.hasSuffix(".mov") ||
                lowerURL.contains(".m3u8")
                
                return Story(
                    url: url,
                    isVideo: isVideo,
                    duration: isVideo ? nil : 10.0,
                    uploadedTime: item.createdAt
                )
            }
            
            DispatchQueue.main.async {
                
                if self.usersStory.isEmpty {
                    self.dismiss(animated: true)
                    return
                }
                
                self.storiesCollectionView.reloadData()
                self.topSliderCollectionView.reloadData()
                self.highlightTitleLabel.text = self.viewModel.sellerHighlight.first?.title ?? ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.startCurrentStory()
                }
            }
        }
    }
    
    func fetchAdminStoriesFrom() {
        
        viewModel.getAdminStory { [weak self] in
            guard let self = self else { return }
            
            self.usersStory = self.viewModel.adminStories.compactMap { item in
                
                guard let url = item.file else { return nil }
                
                let lowerURL = url.lowercased()
                
                let isVideo = lowerURL.hasSuffix(".mp4") ||
                lowerURL.hasSuffix(".mov") ||
                lowerURL.contains(".m3u8")
                
                return Story(
                    url: url,
                    isVideo: isVideo,
                    duration: isVideo ? nil : 10.0,
                    uploadedTime: item.createdAt
                )
            }
            
//            DispatchQueue.main.async {
//                if self.usersStory.isEmpty {
//                    self.dismiss(animated: true)
//                    return
//                }
//                
//                self.storiesCollectionView.reloadData()
//                self.topSliderCollectionView.reloadData()
//                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                    self.startCurrentStory()
//                }
//            }
            
            
            DispatchQueue.main.async {
                if self.usersStory.isEmpty {
                    self.dismiss(animated: true)
                    return
                }

                // Open first unseen story
                if let firstUnseenIndex = self.viewModel.adminStories.firstIndex(where: {
                    $0.isSeen == 0
                }) {
                    self.currentStoryIndex = firstUnseenIndex
                } else {
                    // All stories already seen
                    self.currentStoryIndex = 0
                }

                // Mark previous stories as already seen in slider
                for i in 0..<self.currentStoryIndex {
                    self.seenStories.insert(i)
                }

                self.storiesCollectionView.reloadData()
                self.topSliderCollectionView.reloadData()

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.startCurrentStory()
                }
            }
        }
    }
    
    private func markCurrentStoryAsSeen() {
        switch comingFor {
        case .forAdminStory:
            guard currentStoryIndex < viewModel.adminStories.count else {
                return
            }
            viewModel.seeStoryService(storyId: viewModel.adminStories[currentStoryIndex].id ?? 0)
        case .forSelfStory:
            guard currentStoryIndex < viewModel.sellerStories.count else {
                return
            }
            viewModel.seeStoryService(storyId: viewModel.sellerStories[currentStoryIndex].id ?? 0)
        default:
            print("")
        }
    }
    
    private func setupCollectionViews() {
        // Register Cells
        storiesCollectionView.register(UINib(nibName: "StorieDetailsCollectionViewCell", bundle: nil),forCellWithReuseIdentifier: "StorieDetailsCollectionViewCell")
        
        topSliderCollectionView.register(UINib(nibName: "StorieTopSliderCollectionViewCell", bundle: nil),
                                         forCellWithReuseIdentifier: "StorieTopSliderCollectionViewCell")
        
        storiesCollectionView.delegate = self
        storiesCollectionView.dataSource = self
        topSliderCollectionView.delegate = self
        topSliderCollectionView.dataSource = self
        
        // Stories Collection Setup
        if let layout = storiesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
        
        storiesCollectionView.isPagingEnabled = true
        storiesCollectionView.showsHorizontalScrollIndicator = false
        
        // Top Slider Setup - IMPORTANT CHANGES
        if let layout = topSliderCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 6
            layout.minimumInteritemSpacing = 6
        }
        
        // Disable scrolling on top slider
        topSliderCollectionView.isScrollEnabled = false
        topSliderCollectionView.showsHorizontalScrollIndicator = false
    }
    
    @IBAction func crossDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func deleteDidTapped(_ sender: Any) {
        handleDelete()
    }
    
    private func closeScreen() {
        if let nav = navigationController {
            nav.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    //    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
    //
    //        let location = gesture.location(in: storiesCollectionView)
    //        let width = storiesCollectionView.frame.width
    //
    //        if location.x > width / 2 {
    //            // 👉 RIGHT SIDE
    //            goToNextStory()
    //        } else {
    //            // 👉 LEFT SIDE
    //            goToPreviousStory()
    //        }
    //    }
    
    //    private func goToPreviousStory() {
    //
    //        invalidateProgressTimer()
    //        player?.pause()
    //
    //        if currentStoryIndex <= 0 {
    //            return
    //        }
    //
    //        currentStoryIndex -= 1
    //
    //        let indexPath = IndexPath(item: currentStoryIndex, section: 0)
    //
    //        storiesCollectionView.scrollToItem(
    //            at: indexPath,
    //            at: .centeredHorizontally,
    //            animated: false
    //        )
    //        storiesCollectionView.reloadData()
    //        self.topSliderCollectionView.reloadData()
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
    //            self.startCurrentStory()
    //        }
    //    }
    
    private func handleDelete() {
        
        guard !usersStory.isEmpty else { return }
        
        let index = currentStoryIndex
        
        switch comingFor {
            
        case .forSelfHighlight:
            let item = viewModel.sellerHighlight[index]
            deleteHighlight(id: item.id ?? 0, at: index)
            
        case .forSelfStory:
            let item = viewModel.sellerStories[index]
            deleteStory(id: item.id ?? 0, at: index)
            
        default:
            break
        }
    }
    
    private func deleteHighlight(id: Int, at index: Int) {
        
        viewModel.deleteSelfHighlight(id: id) { [weak self] success in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                
                if success {
                    self.removeStoryLocally(at: index)
                } else {
                    //                    self.showError("Failed to delete highlight")
                }
            }
        }
    }
    
    private func deleteStory(id: Int, at index: Int) {
        
        viewModel.deleteSelfStory(id: id) { [weak self] success in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                
                if success {
                    self.removeStoryLocally(at: index)
                } else {
                    //                    self.showError("Failed to delete story")
                }
            }
        }
    }
    
    private func removeStoryLocally(at index: Int) {
        
        guard index < usersStory.count else { return }
        
        // 🔥 STOP everything first
        invalidateProgressTimer()
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        
        // 🔥 LAST ITEM CASE → CLOSE SCREEN
        if usersStory.count == 1 {
            
            usersStory.removeAll()
            
            if comingFor == .forSelfHighlight {
                viewModel.sellerHighlight.removeAll()
            } else if comingFor == .forSelfStory {
                viewModel.sellerStories.removeAll()
            }
            
            // 👉 Handle both push & present
            if let nav = self.navigationController {
                nav.popViewController(animated: true)
            } else {
                self.dismiss(animated: true)
            }
            
            return
        }
        
        // 👉 NORMAL CASE (more than 1 story)
        usersStory.remove(at: index)
        
        if comingFor == .forSelfHighlight {
            viewModel.sellerHighlight.remove(at: index)
        } else if comingFor == .forSelfStory {
            viewModel.sellerStories.remove(at: index)
        }
        
        // Adjust index safely
        currentStoryIndex = min(index, usersStory.count - 1)
        
        // 🔥 Smooth reload animation
        UIView.transition(with: storiesCollectionView,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: {
            self.storiesCollectionView.reloadData()
            self.topSliderCollectionView.reloadData()
        }) { _ in
            
            let indexPath = IndexPath(item: self.currentStoryIndex, section: 0)
            
            self.storiesCollectionView.scrollToItem(
                at: indexPath,
                at: .centeredHorizontally,
                animated: false
            )
            
            // Update title if highlight
            if self.comingFor == .forSelfHighlight {
                let item = self.viewModel.sellerHighlight[self.currentStoryIndex]
                self.highlightTitleLabel.text = item.title
            }
            
            // Start next story
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.startCurrentStory()
            }
        }
    }
    
    //    func fetchSelfStories() {
    //
    //        // 👉 sellerId pass karo (yaha dynamic bhi kar sakte ho)
    //        viewModel.getSelfStory() { [weak self] in
    //            guard let self = self else { return }
    //
    //            self.usersStory = self.viewModel.sellerStories.compactMap { item in
    //
    //                guard let url = item.file else { return nil }
    //
    //                let lowerURL = url.lowercased()
    //
    //                let isVideo = lowerURL.hasSuffix(".mp4") ||
    //                              lowerURL.hasSuffix(".mov") ||
    //                              lowerURL.contains(".m3u8")
    //
    //                return Story(
    //                    url: url,
    //                    isVideo: isVideo,
    //                    duration: isVideo ? nil : 10.0
    //                )
    //            }
    //
    //            DispatchQueue.main.async {
    //
    //                if self.usersStory.isEmpty {
    //                    self.dismiss(animated: true)
    //                    return
    //                }
    //
    //                self.storiesCollectionView.reloadData()
    //                self.topSliderCollectionView.reloadData()
    //
    //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
    //                    self.startCurrentStory()
    //                }
    //            }
    //        }
    //    }
    
    //    func fetchSelfHighlight() {
    //
    //        viewModel.getSelfHighlight() { [weak self] in
    //            guard let self = self else { return }
    //
    //            self.usersStory = self.viewModel.sellerHighlight.compactMap { item in
    //
    //                guard let url = item.file else { return nil }
    //
    //                let lowerURL = url.lowercased()
    //
    //                let isVideo = lowerURL.hasSuffix(".mp4") ||
    //                              lowerURL.hasSuffix(".mov") ||
    //                              lowerURL.contains(".m3u8")
    //
    //                return Story(
    //                    url: url,
    //                    isVideo: isVideo,
    //                    duration: isVideo ? nil : 10.0
    //                )
    //            }
    //
    //            DispatchQueue.main.async {
    //
    //                if self.usersStory.isEmpty {
    //                    self.dismiss(animated: true)
    //                    return
    //                }
    //
    //                self.storiesCollectionView.reloadData()
    //                self.topSliderCollectionView.reloadData()
    //                self.highlightTitleLabel.text = self.viewModel.sellerHighlight.first?.title ?? ""
    //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
    //                    self.startCurrentStory()
    //                }
    //            }
    //        }
    //    }
    
    //    func fetchAdminStoriesFrom() {
    //
    //          viewModel.getAdminStory { [weak self] in
    //              guard let self = self else { return }
    //
    //              self.usersStory = self.viewModel.adminStories.compactMap { item in
    //
    //                  guard let url = item.file else { return nil }
    //
    //                  let lowerURL = url.lowercased()
    //
    //                  let isVideo = lowerURL.hasSuffix(".mp4") ||
    //                                lowerURL.hasSuffix(".mov") ||
    //                                lowerURL.contains(".m3u8")
    //
    //                  return Story(
    //                      url: url,
    //                      isVideo: isVideo,
    //                      duration: isVideo ? nil : 10.0
    //                  )
    //              }
    //
    //              DispatchQueue.main.async {
    //                  if self.usersStory.isEmpty {
    //                      self.dismiss(animated: true)
    //                      return
    //                  }
    //
    //                  self.storiesCollectionView.reloadData()
    //                  self.topSliderCollectionView.reloadData()
    //
    //                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
    //                      self.startCurrentStory()
    //                  }
    //              }
    //          }
    //      }
    
    //    private func goToNextStory() {
    //        // 👉 SINGLE STORY CASE
    //        if self.accessibilityHint == "SingleStory" {
    //            closeScreen()
    //            return
    //        }
    //
    //        // 👉 LAST STORY REACHED → CLOSE SCREEN
    //        if currentStoryIndex >= usersStory.count - 1 {
    //            closeScreen()
    //            return
    //        }
    //
    //        // 👉 NORMAL FLOW
    //        seenStories.insert(currentStoryIndex)
    //        currentStoryIndex += 1
    //
    //        let indexPath = IndexPath(item: currentStoryIndex, section: 0)
    //        storiesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    //
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
    //            self.startCurrentStory()
    //        }
    //    }
    
    //    private func goToNextStory() {
    //        invalidateProgressTimer()
    //        player?.pause()
    //        if currentStoryIndex >= usersStory.count - 1 {
    //            closeScreen()
    //            return
    //        }
    //        seenStories.insert(currentStoryIndex)
    //        currentStoryIndex += 1
    //        let indexPath = IndexPath(item: currentStoryIndex, section: 0)
    //        storiesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    //        storiesCollectionView.reloadData()
    //        self.topSliderCollectionView.reloadData()
    ////        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
    //            self.startCurrentStory()
    ////        }
    //    }
    
    // MARK: - Cell Configuration
    //    private func configureCell(_ cell: StorieDetailsCollectionViewCell, with story: Story,completion: @escaping (() -> Void)) {
    //        cell.mainImageView.image = nil
    //        cell.mainImageView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    //
    //        player?.pause()
    //        playerLayer?.removeFromSuperlayer()
    //
    //        if story.isVideo {
    //            let videoURLString = story.url ?? ""
    //            if !videoURLString.isEmpty {
    //                playVideo(in: cell, urlString: videoURLString)
    //            }
    //        } else {
    //            let imageURLString = story.url ?? ""
    //            if !imageURLString.isEmpty {
    //                loadImage(in: cell, urlString: imageURLString)
    //            }
    //        }
    //    }
    
    // MARK: - Progress Helpers
    //    private func startImageProgressAnimation(duration: TimeInterval) {
    //        invalidateProgressTimer()
    //            currentProgress = 0
    //            let interval: TimeInterval = 0.016
    //            let increment = CGFloat(interval / duration)
    //            progressTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] timer in
    //                guard let self = self else { return }
    //
    //                self.currentProgress += increment
    //
    //                if self.currentProgress >= 1.0 {
    //                    self.currentProgress = 1.0
    //                    self.updateTopSliderProgress()
    //                    self.invalidateProgressTimer()
    //                    self.goToNextStory()
    //                    self.sliderCheck = false
    //                    return
    //                }
    //
    //                self.updateTopSliderProgress()
    //            }
    //    }
    
    //    private func startVideoProgressObserver() {
    //        guard let player = player else { return }
    //        invalidateProgressTimer()
    //
    //        let interval = CMTime(seconds: 0.05, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    //
    //        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
    //            guard let self = self,
    //                  let currentItem = player.currentItem,
    //                  currentItem.duration.seconds > 0 else { return }
    //
    //            let progress = CGFloat(time.seconds / currentItem.duration.seconds)
    //            self.currentProgress = min(1.0, max(0.0, progress))
    //            self.updateTopSliderProgress()
    //        }
    //    }
    private var timeObserverToken: Any?
    //    private func startVideoProgressObserver() {
    //        guard let player = player else { return }
    //
    //        invalidateProgressTimer()
    //
    //        // ✅ Remove old observer
    //        if let token = timeObserverToken {
    //            player.removeTimeObserver(token)
    //            timeObserverToken = nil
    //        }
    //
    //        let interval = CMTime(seconds: 0.05, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    //
    //        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
    //            guard let self = self,
    //                  let currentItem = player.currentItem,
    //                  currentItem.duration.seconds > 0 else { return }
    //
    //            let progress = CGFloat(time.seconds / currentItem.duration.seconds)
    //            self.currentProgress = min(1.0, max(0.0, progress))
    //            self.updateTopSliderProgress()
    //
    //            // ✅ HANDLE completion here
    ////            if self.currentProgress >= 1.0 {
    ////                self.goToNextStory()
    ////            }
    //        }
    //    }
    
    //    private func startCurrentStory() {
    //        guard let story = usersStory[safe: currentStoryIndex] else { return }
    //
    //        invalidateProgressTimer()
    //
    //        // Reset UI for backward navigation
    //        resetSliderForBackwardNavigation()
    //
    //        // Configure image or video
    //        if let cell = storiesCollectionView.cellForItem(
    //            at: IndexPath(item: currentStoryIndex, section: 0)
    //        ) as? StorieDetailsCollectionViewCell {
    //            configureCell(cell, with: story) {
    //
    //            }
    //        }
    //        onCompletion = {
    //            self.sliderCheck = true
    //                self.topSliderCollectionView.reloadData()
    //                self.seenStories.insert(self.currentStoryIndex)
    //
    //                if story.isVideo {
    //                    self.startVideoProgressObserver()
    //                } else {
    //                    self.startImageProgressAnimation(duration: story.duration ?? 10.0)
    //                }
    ////            self.sliderCheck = true
    ////            self.seenStories.insert(self.currentStoryIndex)
    ////            if story.isVideo {
    ////                self.startVideoProgressObserver()
    ////            } else {
    ////                self.startImageProgressAnimation(duration: story.duration ?? 10.0)
    ////            }
    //        }
    //
    //    }
    
    //    private func updateTopSliderProgress() {
    //        let visibleIndexPaths = topSliderCollectionView.indexPathsForVisibleItems
    //        for indexPath in visibleIndexPaths {
    //            if let sliderCell = topSliderCollectionView.cellForItem(at: indexPath) as? StorieTopSliderCollectionViewCell {
    //                if sliderCheck {
    //                let isActive = (indexPath.item == currentStoryIndex)
    //                let isSeen = seenStories.contains(indexPath.item)
    //                let progress: CGFloat = isActive ? currentProgress : 0.0
    //                sliderCell.configure(isActive: isActive, isSeen: isSeen, progress: progress)
    //            }
    ////                sliderCell.configure(isActive: isActive, isSeen: isSeen, progress: progress)
    //            }
    //        }
    //    }
    
    //    private func invalidateProgressTimer() {
    //        progressTimer?.invalidate()
    //        progressTimer = nil
    //    }
    
    // MARK: - Image & Video
    private func loadImage(in cell: StorieDetailsCollectionViewCell, urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { [weak cell] data, _, _ in
            guard let data = data, let image = UIImage(data: data), let cell = cell else { return }
            DispatchQueue.main.async {
                cell.mainImageView.image = image
                self.onCompletion?()
            }
        }.resume()
    }
    
    private func playVideo(in cell: StorieDetailsCollectionViewCell, urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = cell.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        cell.layer.insertSublayer(playerLayer!, at: 0)
        
        cell.mainImageView.layer.addSublayer(playerLayer!)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(videoDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )
        player?.addObserver(self, forKeyPath: "timeControlStatus", options: [.new, .initial], context: nil)
        player?.play()
    }
    
    // MARK: - Lifecycle
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        invalidateProgressTimer()
        player?.pause()
        playerLayer?.removeFromSuperlayer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let visibleCell = storiesCollectionView.visibleCells.first as? StorieDetailsCollectionViewCell {
            playerLayer?.frame = visibleCell.bounds
        }
    }
    
    private func resetSliderForBackwardNavigation() {
        
        // 1. BEFORE current index → all should be seen (white)
        if currentStoryIndex > 0 {
            for i in 0..<currentStoryIndex {
                seenStories.insert(i)
            }
        }
        
        // 2. AFTER current index → all should be NOT SEEN (gray)
        if currentStoryIndex < usersStory.count - 1 {
            for i in (currentStoryIndex + 1)..<usersStory.count {
                seenStories.remove(i)
            }
        }
        
        // 3. Reset progress for active cell
        currentProgress = 0
        
        // 4. Update slider UI
        topSliderCollectionView.reloadData()
    }
    var sliderCheck = false
    
    //    private func configureAndStartCurrentStory() {
    //                guard let story = usersStory[safe: currentStoryIndex] else { return }
    //
    //                // Get the NOW visible cell (after scroll completes)
    //                guard let cell = storiesCollectionView.visibleCells
    //                    .compactMap({ $0 as? StorieDetailsCollectionViewCell })
    //                    .first else { return }
    //
    //                // Clean previous content
    //                cell.mainImageView.image = nil
    //                cell.mainImageView.layer.sublayers?.removeAll()
    //
    //                // Configure with completion callback
    //                configureCell(cell, with: story) { [weak self] in
    //                    guard let self = self else { return }
    //
    //                    self.resetSliderForBackwardNavigation()
    //                    self.updateTopSliderProgress()
    //
    //                    // Start progress tracking
    //                    if story.isVideo {
    //                        self.startVideoProgressObserver()
    //                    } else {
    //                        self.startImageProgressAnimation(duration: story.duration ?? 10.0)
    //                    }
    //                }
    //            }
}

// MARK: - Collection View DataSource & Delegate
//extension StoryViewerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return usersStory.count   // ← This ensures correct number of cells in both collection views
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        if collectionView == topSliderCollectionView {
//            let sliderCell = collectionView.dequeueReusableCell(
//                withReuseIdentifier: "StorieTopSliderCollectionViewCell",
//                for: indexPath
//            ) as! StorieTopSliderCollectionViewCell
//            if sliderCheck {
//            let isActive = (indexPath.item == currentStoryIndex)
//            let isSeen = seenStories.contains(indexPath.item)
//            let progress: CGFloat = isActive ? currentProgress : 0.0
//                sliderCell.configure(isActive: isActive, isSeen: isSeen, progress: progress)
//            }
////            sliderCell.configure(isActive: isActive, isSeen: isSeen, progress: progress)
//            return sliderCell
//        }
//
//        // Stories Collection View
//        let cell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: "StorieDetailsCollectionViewCell",
//            for: indexPath
//        ) as! StorieDetailsCollectionViewCell
//        storiesCollectionView.layoutIfNeeded()
//
//
////        if indexPath.item == currentStoryIndex {
////            if let story = usersStory[safe: indexPath.item] {
////                configureCell(cell, with: story) {
////
////                }
////                onCompletion = {
//////                    self.sliderCheck = true
//////                    self.topSliderCollectionView.reloadData()
////                }
////            }
////        }
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        if collectionView == topSliderCollectionView {
//            let totalItems = CGFloat(usersStory.count)
//            let spacing: CGFloat = 6.0
//            let totalSpacing = spacing * (totalItems - 1)
//
//            // Dynamic width: Equally divide available width
//            let availableWidth = view.bounds.width - totalSpacing
//            let itemWidth = availableWidth / totalItems
//
//            return CGSize(width: max(itemWidth, 20), height: 4)
//        }
//
//        // Full screen story
//        return CGSize(width: collectionView.bounds.width,
//                      height: collectionView.bounds.height)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return collectionView == topSliderCollectionView ? 6 : 0
//    }
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        guard scrollView == storiesCollectionView else { return }
//
//        let centerPoint = CGPoint(
//            x: scrollView.contentOffset.x + scrollView.bounds.width / 2,
//            y: scrollView.bounds.height / 2
//        )
//
//        if let indexPath = storiesCollectionView.indexPathForItem(at: centerPoint),
//           indexPath.item != currentStoryIndex {
//
//            currentStoryIndex = indexPath.item
//            startCurrentStory()     // ← backward/forward both handled
//        }
//
//        if comingFor == .forSelfHighlight {
//            let item = viewModel.sellerHighlight[currentStoryIndex]
//            highlightTitleLabel.text = item.title
//        }
//    }
//}

extension StoryViewerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return usersStory.count   // ← This ensures correct number of cells in both collection views
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topSliderCollectionView {
            let sliderCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "StorieTopSliderCollectionViewCell",
                for: indexPath
            ) as! StorieTopSliderCollectionViewCell
            
            let isActive = (indexPath.item == currentStoryIndex)
            let isSeen = seenStories.contains(indexPath.item)
            let progress: CGFloat = isActive ? currentProgress : 0.0
            sliderCell.configure(isActive: isActive, isSeen: isSeen, progress: progress)
            
            return sliderCell
        }
        
        // Stories cell - minimal setup only
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "StorieDetailsCollectionViewCell",
            for: indexPath
        ) as! StorieDetailsCollectionViewCell
        
        cell.mainImageView.image = nil
        return cell
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard scrollView == storiesCollectionView else { return }
        syncCurrentStoryIndex()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == storiesCollectionView else { return }
        syncCurrentStoryIndex()
    }
    
    // ✅ NEW: Sync index with actual scroll position
    private func syncCurrentStoryIndex() {
        let centerPoint = CGPoint(
            x: storiesCollectionView.contentOffset.x + storiesCollectionView.bounds.width / 2,
            y: storiesCollectionView.bounds.height / 2
        )
        
        if let indexPath = storiesCollectionView.indexPathForItem(at: centerPoint) {
            currentStoryIndex = indexPath.item
            if comingFor == .forSelfHighlight {
                highlightTitleLabel.text = viewModel.sellerHighlight[safe: currentStoryIndex]?.title ?? ""
            }
            resetSliderForBackwardNavigation()
            configureAndStartCurrentStory()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //        if collectionView == topSliderCollectionView {
        //            let totalItems = CGFloat(usersStory.count)
        //            let spacing: CGFloat = 6.0
        //            let totalSpacing = spacing * (totalItems - 1)
        //
        //            // Dynamic width: Equally divide available width
        //            let availableWidth = view.bounds.width - totalSpacing
        //            let itemWidth = availableWidth / totalItems
        //
        //            return CGSize(width: max(itemWidth, 20), height: 4)
        //        }
        
        if collectionView == topSliderCollectionView {
            
            let totalItems = CGFloat(usersStory.count)
            let spacing: CGFloat = 6.0
            let totalSpacing = spacing * (totalItems - 1)
            
            let totalWidth = collectionView.bounds.width
            let availableWidth = totalWidth - totalSpacing
            
            var itemWidth = availableWidth / totalItems
            itemWidth = floor(itemWidth * UIScreen.main.scale) / UIScreen.main.scale  // ← FIX
            
            return CGSize(width: itemWidth, height: 4)
        }
        
        // Full screen story
        return CGSize(width: collectionView.bounds.width,
                      height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView == topSliderCollectionView ? 6 : 0
    }
}

// Safe Subscript
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

