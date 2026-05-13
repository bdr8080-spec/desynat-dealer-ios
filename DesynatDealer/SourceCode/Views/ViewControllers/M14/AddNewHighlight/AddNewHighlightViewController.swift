//
//  AddNewHighlightViewController.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 31/03/26.
//
import UIKit
import Photos
import AVFoundation
import AVKit

class AddNewHighlightViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var videoPlayButton: UIButton!
    @IBOutlet weak var dropDownimageView: UIImageView!
    @IBOutlet weak var enternameTxtField: UITextField!
    @IBOutlet weak var uploadedImage: CustomImageView!
    @IBOutlet weak var highlightNameCollectionView: UICollectionView! {
        didSet {
            highlightNameCollectionView.registerCellFromNib(cellID: "RadioBtnCollectionViewCell")
        }
    }
    @IBOutlet weak var contentCollectionView: UICollectionView! {
        didSet {
            contentCollectionView.registerCellFromNib(cellID: "SelectVideoFromGalleryCollectionViewCell")
        }
    }
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var lblAddToHightlightTitle: UILabel!
    
    // MARK: - Properties
    var galleryAssets: [PHAsset] = []
    var highlightname = ["Select from previous", "Add new"]
    private var selectedRoleIndex: Int? = 0
    private lazy var viewModel = AddHighlightsViewModel(hostVc: self)
    var videoURL: URL?
    private var selectedImageData: Data?
    private var selectedVideoData: Data?
    private var isImageSelected: Bool = true
    var selectedContentFromGallery = -1
    let imageManager = PHCachingImageManager()
    var thumbnailImage: String?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchGalleryAssets()
        viewModel.getMyHighLights()
        enternameTxtField.delegate = self
        lblAddToHightlightTitle.text = "Add to Highlight".localiz()
    }
    
    // MARK: - Actions
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addToHighlightBtnTapped(_ sender: Any) {
        
        guard let name = enternameTxtField.text?.trimmed(), !name.isEmpty else {
            if selectedRoleIndex == 0 {
                CommonUtils.showToast(message: "Please select name".localiz())
            } else {
                CommonUtils.showToast(message: "Please enter name".localiz())
            }
            return
        }
        if isImageSelected {
            guard let imageData = selectedImageData else {
                CommonUtils.showToast(message: "Please select an image".localiz())
                return
            }
            viewModel.uploadMedia(fileData: imageData, isImage: true)
            
        } else {
            guard let videoData = selectedVideoData else {
                CommonUtils.showToast(message: "Please select a video".localiz())
                return
            }
            viewModel.uploadMedia(fileData: videoData, isImage: false)
        }
    }
    
    @IBAction func uploadImageDidtapped(_ sender: Any) {
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Camera not available")
            return
        }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.mediaTypes = ["public.image", "public.movie"]
        picker.videoQuality = .typeHigh
        
        present(picker, animated: true)
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
    
    // MARK: - Gallery Fetch

    func fetchGalleryAssets() {
        let status = PHPhotoLibrary.authorizationStatus()

        switch status {
        case .authorized:
            loadAssets()
            
        case .limited:
            updateUI(for: .limitedAccess)
            loadAssets()

        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                if newStatus == .authorized || newStatus == .limited {
                    self.fetchGalleryAssets()
                } else {
                    self.updateUI(for: .denied)
                }
            }
            
        case .restricted, .denied:
            updateUI(for: .denied)
            
        @unknown default:
            updateUI(for: .denied)
        }
    }
    
    func loadAssets() {
        galleryAssets.removeAll()

        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        let allAssets = PHAsset.fetchAssets(with: fetchOptions)
        allAssets.enumerateObjects { asset, _, _ in
            self.galleryAssets.append(asset)
        }

        if galleryAssets.isEmpty {
            updateUI(for: .noData)
        } else {
            updateUI(for: .hasData)
        }

        DispatchQueue.main.async {
            self.contentCollectionView.reloadData()
        }
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
}

// MARK: - UICollectionView

extension AddNewHighlightViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == highlightNameCollectionView ? highlightname.count : galleryAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == highlightNameCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RadioBtnCollectionViewCell", for: indexPath) as! RadioBtnCollectionViewCell
            
            cell.titleLbl.text = highlightname[indexPath.row].localiz()
            cell.updateSelectionState(isSelected: selectedRoleIndex == indexPath.row)
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectVideoFromGalleryCollectionViewCell", for: indexPath) as! SelectVideoFromGalleryCollectionViewCell
        
        let asset = galleryAssets[indexPath.item]
        let cellSize = CGSize(width: cell.frame.width * UIScreen.main.scale,
                              height: cell.frame.height * UIScreen.main.scale)

        let options = PHImageRequestOptions()
        options.deliveryMode = .fastFormat
        options.resizeMode = .fast
        options.isSynchronous = false

        imageManager.requestImage(
            for: asset,
            targetSize: cellSize,
            contentMode: .aspectFill,
            options: options
        ) { image, _ in
            DispatchQueue.main.async {
                cell.mainImageView.image = image
            }
        }
        if asset.mediaType == .video {
            cell.playPauseImageView.isHidden = false // add a play icon in your cell
        } else {
            cell.playPauseImageView.isHidden = true
        }
        cell.selectedImageView.image =
            (selectedContentFromGallery == indexPath.row)
            ? .selectedCheckBox
            : .unslectedCheckbox
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == highlightNameCollectionView {
            return CGSize(width: 200, height: 24)
        }
        
        let width = (collectionView.frame.width - 20) / 2
        return CGSize(width: width, height: 220)
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        // Highlight Name collection
        // Highlight Name collection
        if collectionView == highlightNameCollectionView {

            // 🔥 Dismiss keyboard first
            view.endEditing(true)

            selectedRoleIndex = indexPath.row

            // Show dropdown only when selecting from previous
            dropDownimageView.isHidden = (selectedRoleIndex != 0)

            // Placeholder logic
            enternameTxtField.placeholder =
                selectedRoleIndex == 0 ? "Select Name".localiz() : "Enter Name".localiz()

            collectionView.reloadData()
            return
        }

        // Gallery Collection
        guard collectionView == contentCollectionView else { return }

        let previousIndex = selectedContentFromGallery
        selectedContentFromGallery = indexPath.item

        // Reload only these 2 cells → smooth & fast
        var reloadIndex = [indexPath]
        if previousIndex != -1 {
            reloadIndex.append(IndexPath(item: previousIndex, section: 0))
        }
        contentCollectionView.reloadItems(at: reloadIndex)

        let asset = galleryAssets[indexPath.item]

        if asset.mediaType == .image {
            handleSelectedImageAsset(asset)
        } else {
            handleSelectedVideoAsset(asset)
        }
    }
    
    // MARK: - Handle Selected Gallery Items

    private func handleSelectedImageAsset(_ asset: PHAsset) {
        
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        
        PHImageManager.default().requestImage(
            for: asset,
            targetSize: CGSize(width: 1080, height: 1080),
            contentMode: .aspectFill,
            options: options
        ) { [weak self] image, info in
            
            guard let self = self,
                  let image = image else { return }
            
            DispatchQueue.main.async {
                
                // Prepare data for upload
                if let jpegData = image.jpegData(compressionQuality: 0.7) {
                    self.selectedImageData = jpegData
                    self.selectedVideoData = nil
                    self.isImageSelected = true
                    
                    // Hide video play button
                    self.videoPlayButton.isHidden = true
                }
            }
        }
    }

//    private func handleSelectedVideoAsset(_ asset: PHAsset) {
//        
//        let options = PHVideoRequestOptions()
//        options.deliveryMode = .highQualityFormat
//        
//        PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { [weak self] avAsset, _, _ in
//            
//            guard let self = self,
//                  let urlAsset = avAsset as? AVURLAsset else { return }
//            
//            let videoURL = urlAsset.url
//            
//            // Generate thumbnail for display
//            CommonUtils.generateThumbnail(url: videoURL) { [weak self] thumbNailImage in
//                guard let self = self else { return }
//                
//                DispatchQueue.main.async {
//                    // Store video URL for later compression/upload
//                    self.videoURL = videoURL
//                    guard let data = thumbNailImage?.jpegData(compressionQuality: 0.25) else { return }
//                    self.viewModel.uploadMediaForGettingThumbnailImageUrl(fileData: data, isImage: true)
//                    self.isImageSelected = false
//                }
//            }
//        }
//    }
    
    private func handleSelectedVideoAsset(_ asset: PHAsset) {
        
        let options = PHVideoRequestOptions()
        options.deliveryMode = .highQualityFormat
        
        PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { [weak self] avAsset, _, _ in
            
            guard let self = self,
                  let urlAsset = avAsset as? AVURLAsset else { return }
            
            let videoURL = urlAsset.url
            
            // ✅ Load video data (FIX)
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let data = try Data(contentsOf: videoURL)
                    
                    DispatchQueue.main.async {
                        self.selectedVideoData = data   // ✅ IMPORTANT FIX
                        self.selectedImageData = nil
                        self.isImageSelected = false
                        self.videoURL = videoURL
                    }
                    
                } catch {
                    print("Error loading video data:", error)
                }
            }
            
            // Thumbnail
            CommonUtils.generateThumbnail(url: videoURL) { [weak self] thumbNailImage in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    guard let data = thumbNailImage?.jpegData(compressionQuality: 0.25) else { return }
                    self.viewModel.uploadMediaForGettingThumbnailImageUrl(fileData: data, isImage: true)
                }
            }
        }
    }
    
    private func handleImageAsset(_ asset: PHAsset) {
        
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        
        PHImageManager.default().requestImage(
            for: asset,
            targetSize: CGSize(width: 1080, height: 1080),
            contentMode: .aspectFill,
            options: options
        ) { [weak self] image, _ in
            
            guard let self = self,
                  let image = image else { return }
            
            DispatchQueue.main.async {
                let vc = UploadPostViewController.instantiate(fromAppStoryboard: .Profile)
                vc.selectedImage = image   // ✅ pass image
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
//    private func handleVideoAsset(_ asset: PHAsset) {
//        
//        let options = PHVideoRequestOptions()
//        options.deliveryMode = .highQualityFormat
//        
//        PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { [weak self] avAsset, _, _ in
//            
//            guard let self = self,
//                  let urlAsset = avAsset as? AVURLAsset else { return }
//            
//            let videoURL = urlAsset.url
//            let data = try Data(contentsOf: videoURL)
//            self.isImageSelected = false
//            self.selectedVideoData = data
//            self.selectedImageData = nil
//            self.videoURL = videoURL
//            // ✅ Generate thumbnail
//            CommonUtils.generateThumbnail(url: videoURL) { thumbnail in
//                DispatchQueue.main.async {
//                    let vc = UploadPostViewController.instantiate(fromAppStoryboard: .Profile)
//                    vc.selectedImage = thumbnail
//                    vc.videoURL = videoURL
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//            }
//        }
//    }
    
    
    private func handleVideoAsset(_ asset: PHAsset) {
        
        let options = PHVideoRequestOptions()
        options.deliveryMode = .highQualityFormat
        
        PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { [weak self] avAsset, _, _ in
            
            guard let self = self,
                  let urlAsset = avAsset as? AVURLAsset else { return }
            
            let videoURL = urlAsset.url
            
            // ⚠️ Do heavy work in background
            DispatchQueue.global(qos: .userInitiated).async {
                
                do {
                    // ❌ Avoid loading full data if not required
                    let data = try Data(contentsOf: videoURL)
                    
                    DispatchQueue.main.async {
                        self.isImageSelected = false
                        self.selectedVideoData = data
                        self.selectedImageData = nil
                        self.videoURL = videoURL
                    }
                    
                } catch {
                    print("Error loading video data:", error)
                    return
                }
            }
            
            // ✅ Generate thumbnail (already async)
            CommonUtils.generateThumbnail(url: videoURL) { thumbnail in
                DispatchQueue.main.async {
                    let vc = UploadPostViewController.instantiate(fromAppStoryboard: .Profile)
                    vc.selectedImage = thumbnail
                    vc.videoURL = videoURL
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func compressVideo(videoURL: URL, isCallingFromGallery: Bool) {
        
        let avAsset = AVURLAsset(url: videoURL)
        
        guard let exportSession = AVAssetExportSession(asset: avAsset,
                                                       presetName: AVAssetExportPresetMediumQuality) else {
            return
        }
        
        let outputURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("compressed_\(UUID().uuidString).mov")
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mov
        
        exportSession.exportAsynchronously {
            if exportSession.status == .completed {
                
                do {
                    let data = try Data(contentsOf: outputURL)
                    
                    DispatchQueue.main.async {
                        self.isImageSelected = false
                        self.selectedVideoData = data
                        self.selectedImageData = nil
                        self.videoURL = outputURL
                        
                        CommonUtils.generateThumbnail(url: outputURL) { thumbNailImage in
                            if !isCallingFromGallery {
                                self.videoPlayButton.isHidden = false
                                self.uploadedImage.image = thumbNailImage ?? UIImage(named: "video_placeholder")
                                guard let data = thumbNailImage?.jpegData(compressionQuality: 0.25) else { return }
                                self.viewModel.uploadMediaForGettingThumbnailImageUrl(fileData: data, isImage: true)
                            }
                        }
                    }
                    
                } catch {
                    print("Video error:", error)
                }
            }
        }
    }
    

}

// MARK: - UIImagePicker

extension AddNewHighlightViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
            
            guard let data = image.jpegData(compressionQuality: 0.25) else { return }
            
            self.isImageSelected = true
            self.selectedImageData = data
            self.selectedVideoData = nil
            
            self.uploadedImage.image = image
        }
        
        else if let videoURL = info[.mediaURL] as? URL {
            compressVideo(videoURL: videoURL, isCallingFromGallery: false)
        }
    }
    
    func updateUI(for state: GalleryState) {
        DispatchQueue.main.async {
            switch state {
            case .loading:
                self.noDataFoundLabel.isHidden = true
                self.contentCollectionView.isHidden = true
                
            case .hasData:
                self.noDataFoundLabel.isHidden = true
                self.contentCollectionView.isHidden = false
                
            case .noData:
                self.noDataFoundLabel.text = "No photos or videos found.".localiz()
                self.noDataFoundLabel.isHidden = false
                self.contentCollectionView.isHidden = true
                
            case .limitedAccess:
                self.noDataFoundLabel.text = "You have allowed limited access to your gallery.\nPlease select more photos.".localiz()
                self.noDataFoundLabel.isHidden = false
                self.contentCollectionView.isHidden = false
                
            case .denied:
                self.noDataFoundLabel.text = "Gallery permission denied.\nPlease allow access in Settings.".localiz()
                self.noDataFoundLabel.isHidden = false
                self.contentCollectionView.isHidden = true
            }
        }
    }
}

extension AddNewHighlightViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        // Only show dropdown when "Select from previous" is chosen
        if selectedRoleIndex == 0 {

            view.endEditing(true)

            let categoryNames = viewModel.highlightList?.map { $0.title ?? "" } ?? []

            kSharedAppDelegate.dropDown(
                dataSource: categoryNames,
                anchorView: textField
            ) { [weak self] index, item in
                self?.enternameTxtField.text = item
            }

            return false // don't open keyboard
        }

        return true // allow typing manually
    }
}
