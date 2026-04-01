//
//  AddNewStoryViewController.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 31/03/26.
//

import UIKit
import Photos

class AddNewStoryViewController: UIViewController {
    
    // MARK: - IBOutlet's
    @IBOutlet weak var contentCollectionView: UICollectionView! {
        didSet {
            contentCollectionView.registerCellFromNib(cellID: "SelectVideoFromGalleryCollectionViewCell")
        }
    }
    
    // MARK: - Property Decalaration
    var galleryAssets: [PHAsset] = []
    let imagePicker = ImagePickerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchGalleryAssets()
    }
    // MARK: - Navigation
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
    
    //MARK: Function's declaration
    func fetchGalleryAssets() {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized || status == .limited {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let allAssets = PHAsset.fetchAssets(with: fetchOptions)
            allAssets.enumerateObjects { asset, _, _ in
                self.galleryAssets.append(asset)
            }
            DispatchQueue.main.async {
                self.contentCollectionView.reloadData()
            }
        } else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { newStatus in
                if newStatus == .authorized || newStatus == .limited {
                    self.fetchGalleryAssets()
                }
            }
        } else {
            // Handle denied or restricted
            print("Access to photo library denied.")
        }
    }
    
}
// MARK: - COLLECTION VIEW METHODS
extension AddNewStoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectVideoFromGalleryCollectionViewCell", for: indexPath) as! SelectVideoFromGalleryCollectionViewCell
        
        let asset = galleryAssets[indexPath.item]
        let cellSize = CGSize(width: cell.frame.width, height: cell.frame.height)
        cell.selectedImageView.isHidden = true
        CommonUtils.getThumbnail(asset: asset, size: cellSize) { image in
            DispatchQueue.main.async {
                cell.mainImageView.image = image
            }
        }
        
        // Optional: indicate if asset is video
        if asset.mediaType == .video {
            cell.playPauseImageView.isHidden = false // add a play icon in your cell
        } else {
            cell.playPauseImageView.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 20) / 2
        return CGSize(width: width, height: 220) // optional dynamic height
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let asset = galleryAssets[indexPath.item]

        if asset.mediaType == .image {
            handleImageAsset(asset)
        } else if asset.mediaType == .video {
            handleVideoAsset(asset)
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
    private func handleVideoAsset(_ asset: PHAsset) {
        
        let options = PHVideoRequestOptions()
        options.deliveryMode = .highQualityFormat
        
        PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { [weak self] avAsset, _, _ in
            
            guard let self = self,
                  let urlAsset = avAsset as? AVURLAsset else { return }
            
            let videoURL = urlAsset.url
            
            // ✅ Generate thumbnail
            CommonUtils.generateThumbnail(url: videoURL) { thumbnail in
                
                DispatchQueue.main.async {
                    let vc = UploadPostViewController.instantiate(fromAppStoryboard: .Profile)
                    vc.selectedImage = thumbnail
                    
                    vc.videoURL = videoURL   // 🔥🔥 MOST IMPORTANT LINE
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}

extension AddNewStoryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        picker.dismiss(animated: true)

        // ✅ IMAGE CASE
        if let image = info[.originalImage] as? UIImage {

            let vc = UploadPostViewController.instantiate(fromAppStoryboard: .Profile)
            vc.selectedImage = image
            self.navigationController?.pushViewController(vc, animated: true)
        }

        // ✅ VIDEO CASE (🔥 FIX HERE)
        else if let videoURL = info[.mediaURL] as? URL {

            CommonUtils.generateThumbnail(url: videoURL) { thumbnail in

                DispatchQueue.main.async {
                    let vc = UploadPostViewController.instantiate(fromAppStoryboard: .Profile)
                    vc.selectedImage = thumbnail
                    vc.videoURL = videoURL   // ✅ IMPORTANT

                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
}
