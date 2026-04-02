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
    
    // MARK: - Variables
    var usersStory: [Story] = []
    var currentStoryIndex = 0
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupCollectionViews()
        switch comingFor {
        case .forAdminStory:
            fetchAdminStoriesFrom()
            highlightTitleView.isHidden = true
        case .forSelfStory:
            fetchSelfStories()
            highlightTitleView.isHidden = true
        case .forSelfHighlight:
            fetchSelfHighlight()
            highlightTitleView.isHidden = false
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
                    duration: isVideo ? nil : 10.0
                )
            }
            
            DispatchQueue.main.async {
                
                if self.usersStory.isEmpty {
                    self.dismiss(animated: true)
                    return
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
                    duration: isVideo ? nil : 10.0
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
                      duration: isVideo ? nil : 10.0
                  )
              }
              
              DispatchQueue.main.async {
                  if self.usersStory.isEmpty {
                      self.dismiss(animated: true)
                      return
                  }
                  
                  self.storiesCollectionView.reloadData()
                  self.topSliderCollectionView.reloadData()
                  
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                      self.startCurrentStory()
                  }
              }
          }
      }
    
    private func goToNextStory() {
        
        // 👉 SINGLE STORY CASE
        if self.accessibilityHint == "SingleStory" {
            dismiss(animated: false)
            return
        }
        
        // 👉 NORMAL FLOW (multiple stories)
        guard currentStoryIndex < usersStory.count - 1 else {
            dismiss(animated: false)
            return
        }
        
        seenStories.insert(currentStoryIndex)
        currentStoryIndex += 1
        
        let indexPath = IndexPath(item: currentStoryIndex, section: 0)
        storiesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.startCurrentStory()
        }
    }
    
    // MARK: - Cell Configuration
    private func configureCell(_ cell: StorieDetailsCollectionViewCell, with story: Story) {
        cell.mainImageView.image = nil
        cell.mainImageView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        
        if story.isVideo {
            let videoURLString = story.url ?? ""
            if !videoURLString.isEmpty {
                playVideo(in: cell, urlString: videoURLString)
            }
        } else {
            let imageURLString = story.url ?? ""
            if !imageURLString.isEmpty {
                loadImage(in: cell, urlString: imageURLString)
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
                return
            }

            self.updateTopSliderProgress()
        }
    }
    
    private func startVideoProgressObserver() {
        guard let player = player else { return }
        invalidateProgressTimer()
        
        let interval = CMTime(seconds: 0.05, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self,
                  let currentItem = player.currentItem,
                  currentItem.duration.seconds > 0 else { return }
            
            let progress = CGFloat(time.seconds / currentItem.duration.seconds)
            self.currentProgress = min(1.0, max(0.0, progress))
            self.updateTopSliderProgress()
        }
    }
    
    private func startCurrentStory() {
        guard let story = usersStory[safe: currentStoryIndex] else { return }

        invalidateProgressTimer()

        // Reset UI for backward navigation
        resetSliderForBackwardNavigation()

        // Configure image or video
        if let cell = storiesCollectionView.cellForItem(
            at: IndexPath(item: currentStoryIndex, section: 0)
        ) as? StorieDetailsCollectionViewCell {
            configureCell(cell, with: story)
        }

        // Mark current as seen
        seenStories.insert(currentStoryIndex)

        // 🔥 START PROGRESS HERE (THIS IS WHAT YOU NEED TO FIX)
        if story.isVideo {
            startVideoProgressObserver()
        } else {
            // ⬅ THIS part must call your fixed animation (10 sec)
            startImageProgressAnimation(duration: story.duration ?? 10.0)
        }
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
    
    private func invalidateProgressTimer() {
        progressTimer?.invalidate()
        progressTimer = nil
    }
    
    // MARK: - Image & Video
    private func loadImage(in cell: StorieDetailsCollectionViewCell, urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { [weak cell] data, _, _ in
            guard let data = data, let image = UIImage(data: data), let cell = cell else { return }
            DispatchQueue.main.async {
                cell.mainImageView.image = image
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
        
        player?.play()
    }
    
    @objc private func videoDidFinishPlaying() {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        goToNextStory()
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
}

// MARK: - Collection View DataSource & Delegate
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
        
        // Stories Collection View
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "StorieDetailsCollectionViewCell",
            for: indexPath
        ) as! StorieDetailsCollectionViewCell
        
        if indexPath.item == currentStoryIndex {
            if let story = usersStory[safe: indexPath.item] {
                configureCell(cell, with: story)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == topSliderCollectionView {
            let totalItems = CGFloat(usersStory.count)
            let spacing: CGFloat = 6.0
            let totalSpacing = spacing * (totalItems - 1)
            
            // Dynamic width: Equally divide available width
            let availableWidth = view.bounds.width - totalSpacing
            let itemWidth = availableWidth / totalItems
            
            return CGSize(width: max(itemWidth, 20), height: 4)
        }
        
        // Full screen story
        return CGSize(width: collectionView.bounds.width,
                      height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView == topSliderCollectionView ? 6 : 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == storiesCollectionView else { return }

        let centerPoint = CGPoint(
            x: scrollView.contentOffset.x + scrollView.bounds.width / 2,
            y: scrollView.bounds.height / 2
        )

        if let indexPath = storiesCollectionView.indexPathForItem(at: centerPoint),
           indexPath.item != currentStoryIndex {

            currentStoryIndex = indexPath.item
            startCurrentStory()     // ← backward/forward both handled
        }
        
        if comingFor == .forSelfHighlight {
            let item = viewModel.sellerHighlight[currentStoryIndex]
            highlightTitleLabel.text = item.title
        }
    }
}

// Safe Subscript
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

