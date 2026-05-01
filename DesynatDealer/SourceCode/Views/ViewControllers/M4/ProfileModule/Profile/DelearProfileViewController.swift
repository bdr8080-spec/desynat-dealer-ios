//
//  DelearProfileViewController.swift
//  DesynatDealer
//
//  Created by fluper on 05/12/25.
//

import UIKit
import SDWebImage

class DelearProfileViewController: UIViewController {
    
    @IBOutlet weak var qrImageView: CustomImageView!
    @IBOutlet weak var viewStoriesBtn: UIButton!
    @IBOutlet weak var bandDetailsView: CustomView!
    @IBOutlet weak var storeDocumentView: UIView!
    @IBOutlet weak var owberDocumentView: UIView!
    @IBOutlet weak var reelsCollectionViewHeightConstratint: NSLayoutConstraint!
    @IBOutlet weak var reelsCollectionView: UICollectionView! {
        didSet {
            reelsCollectionView.registerCellFromNib(cellID: "ReelsCollectionViewCell")
            reelsCollectionView.registerCellFromNib(cellID: "UploadNewReelsCollectionViewCell")
        }
    }
    @IBOutlet weak var bankDetailsStackView: UIStackView!
    @IBOutlet weak var myReelsButtn: CustomButton!
    @IBOutlet weak var myReelsLabel: UILabel!
    @IBOutlet weak var bandDetailsButton: CustomButton!
    @IBOutlet weak var bankDetailsLabel: UILabel!
    @IBOutlet weak var storiesCollectionView: UICollectionView! {
        didSet {
            storiesCollectionView.registerCellFromNib(cellID: "StoresDetailsCollectionViewCell")
        }
    }
    
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var userProfileImageView: CustomImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userMobileLabel: UILabel!
    @IBOutlet weak var useremailLabel: UILabel!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storePhoneLabel: UILabel!
    @IBOutlet weak var storeEmailLabel: UILabel!
    @IBOutlet weak var storeAddressLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var fronOwnerImageView: CustomImageView!
    @IBOutlet weak var backOwnerImageView: CustomImageView!
    @IBOutlet weak var storeFrontImageView: CustomImageView!
    @IBOutlet weak var storebackImageView: CustomImageView!
    @IBOutlet weak var accountTypeLabel: UILabel!
    @IBOutlet weak var ibanLabel: UILabel!
    @IBOutlet weak var swiftLabel: UILabel!
    @IBOutlet weak var swiftView: UIView!
    @IBOutlet weak var banknameLabel: UILabel!
    @IBOutlet weak var accountHolderNameLabel: UILabel!
    @IBOutlet weak var proofDocumentImageView: CustomImageView!
    @IBOutlet weak var ibanView: UIView!
    
    private lazy var viewModel = DelearProfileViewModel(hostVC: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.resetPagination()           // ← Add this line
            
            viewModel.getUserProfile()
            viewModel.getMyHighLights()
            viewModel.getMyReelsRequest()
            viewModel.getSelfStory()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Ensure height is updated after everything is laid out
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.updateReelsHeight()
        }
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func myReelsDidTapped(_ sender: Any) {
        bandDetailsButton.setImage(UIImage(named: ""), for: .normal)
        bankDetailsLabel.textColor = UIColor.black
        myReelsButtn.setImage(UIImage(named: "btnGradient"), for: .normal)
        myReelsLabel.textColor = UIColor.white
        owberDocumentView.isHidden = true
        storeDocumentView.isHidden = true
        bandDetailsView.isHidden = true
        reelsCollectionView.isHidden = false
    }
    
    @IBAction func bankDetailsAction(_ sender: Any) {
        myReelsButtn.setImage(UIImage(named: ""), for: .normal)
        myReelsLabel.textColor = UIColor.black
        bandDetailsButton.setImage(UIImage(named: "btnGradient"), for: .normal)
        bankDetailsLabel.textColor = UIColor.white
        owberDocumentView.isHidden = false
        storeDocumentView.isHidden = false
        bandDetailsView.isHidden = false
        reelsCollectionView.isHidden = true
    }
    
    @IBAction func editPencilDidTapped(_ sender: Any) {
        let nextVC = EditProfileViewController.instantiate(fromAppStoryboard: .Profile)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func addNewHighlightTapped(_ sender: Any) {
        let  vc = AddNewHighlightViewController.instantiate(fromAppStoryboard: .Profile)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addNewStoryDidTapped(_ sender: Any) {
        let vc = AddNewStoryViewController.instantiate(fromAppStoryboard: .Profile)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func profileImageDidTapped(_ sender: Any) {
        let nextVC = StoryViewerViewController.instantiate(fromAppStoryboard: .Profile)
        nextVC.comingFor = .forSelfStory
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    func populateData() {
        let data = viewModel.userProfile
        if let imageUrlString = data?.profilePic,
           let url = URL(string: imageUrlString) {
            userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            userProfileImageView.sd_imageIndicator?.startAnimatingIndicator()
            userProfileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "userProfile"))
        } else {
            userProfileImageView.image = UIImage(named: "userProfile")
        }
        
        if let imageUrlString = data?.profileQR,
           let url = URL(string: imageUrlString) {
            qrImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            qrImageView.sd_imageIndicator?.startAnimatingIndicator()
            qrImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "qrCode"))
        } else {
            qrImageView.image = UIImage(named: "qrCode")
        }
        
        if let storeImageUrl = data?.storeInfo?.storeImage,
           let url = URL(string: storeImageUrl) {
            storeImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            storeImageView.sd_imageIndicator?.startAnimatingIndicator()
            storeImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        }
        
        userNameLabel.text = "\(data?.firstName ?? "") \(data?.lastName ?? "")"
        userMobileLabel.text = "\(data?.countryCode ?? "+965") \(data?.mobile ?? "")"
        useremailLabel.text = data?.email
        
        storeNameLabel.text = data?.storeInfo?.storeName
        storePhoneLabel.text = "\(data?.storeInfo?.countryCode ?? "+965") \(data?.storeInfo?.storePhone ?? "")"
        storeEmailLabel.text = data?.storeInfo?.storeMailID
        storeAddressLabel.text = "\(data?.storeInfo?.storeAddress ?? "") \(data?.storeInfo?.addressLine1 ?? "") \(data?.storeInfo?.addressLine2 ?? "")"
        bioLabel.text = data?.storeInfo?.bio
        
        if let storeImageUrl = data?.ownerDocument?.first?.documentPath,
           let url = URL(string: storeImageUrl) {
            fronOwnerImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            fronOwnerImageView.sd_imageIndicator?.startAnimatingIndicator()
            fronOwnerImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        }
        
        if let storeImageUrl = data?.ownerDocument?.last?.documentPath,
           let url = URL(string: storeImageUrl) {
            backOwnerImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            backOwnerImageView.sd_imageIndicator?.startAnimatingIndicator()
            backOwnerImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        }
        
        if let storeImageUrl = data?.storeDocument?.first?.documentPath,
           let url = URL(string: storeImageUrl) {
            storeFrontImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            storeFrontImageView.sd_imageIndicator?.startAnimatingIndicator()
            storeFrontImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        }
        
        if let storeImageUrl = data?.storeDocument?.last?.documentPath,
           let url = URL(string: storeImageUrl) {
            storebackImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            storebackImageView.sd_imageIndicator?.startAnimatingIndicator()
            storebackImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        }
        
        let type = data?.sellerBankDetails?.accountType ?? "0"
        if type == "0" {
            accountTypeLabel.text = "Personal".localiz()
        } else {
            accountTypeLabel.text = "Business".localiz()
        }
        
        if let iban = data?.sellerBankDetails?.iban, !iban.isEmpty {
            ibanView.isHidden = false
            ibanLabel.text = iban
        } else {
            ibanView.isHidden = true
        }
        
        if let swift = data?.sellerBankDetails?.swift, !swift.isEmpty {
            swiftView.isHidden = false
            swiftLabel.text = swift
        } else {
            swiftView.isHidden = true
        }
        banknameLabel.text = data?.sellerBankDetails?.bankName
        accountHolderNameLabel.text = data?.sellerBankDetails?.accountHolderName
        
        if let storeImageUrl = data?.sellerBankDetails?.uploadProof,
           let url = URL(string: storeImageUrl) {
            proofDocumentImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            proofDocumentImageView.sd_imageIndicator?.startAnimatingIndicator()
            proofDocumentImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        }
    }
    
    func updateReelsHeight() {
        // Use async to let layout happen first
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.reelsCollectionView.layoutIfNeeded()
            
            // Calculate proper height based on content
            let contentHeight = self.reelsCollectionView.collectionViewLayout.collectionViewContentSize.height
            
            // Add some extra padding if needed (optional)
            let finalHeight = max(contentHeight, 100) // minimum height fallback
            
            // Update constraint with animation for smooth look (optional)
            UIView.animate(withDuration: 0.2) {
                self.reelsCollectionViewHeightConstratint.constant = finalHeight
                self.view.layoutIfNeeded()
            }
        }
    }
    
}

extension DelearProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case storiesCollectionView:
            return viewModel.highlightList?.count ?? 0
        case reelsCollectionView:
            return (viewModel.reelsList?.count ?? 0) + 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case storiesCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoresDetailsCollectionViewCell", for: indexPath) as! StoresDetailsCollectionViewCell
            let dict = self.viewModel.highlightList?[indexPath.row]
            cell.configData(data: dict)
            return cell
        case reelsCollectionView:
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "UploadNewReelsCollectionViewCell",
                    for: indexPath
                ) as! UploadNewReelsCollectionViewCell
                return cell
            }
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ReelsCollectionViewCell",
                for: indexPath
            ) as! ReelsCollectionViewCell
            
            let reel = viewModel.reelsList?[indexPath.row - 1]
            cell.configData(data: reel)
            // configure your reel here
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case storiesCollectionView:
            let width = storiesCollectionView.frame.width / 5
            let height: CGFloat = 90
            return CGSize(width: width, height: height)
        case reelsCollectionView:
            let width = (reelsCollectionView.frame.width - 20) / 2
            let height: CGFloat = 220
            return CGSize(width: width, height: height)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case reelsCollectionView:
            if indexPath.row == 0 {
                let vc =  UploadNewReelViewController.instantiate(fromAppStoryboard: .Profile)
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
            let nextVC = MyProfileRellsViewController.instantiate(fromAppStoryboard: .Profile)
            nextVC.reelsData = viewModel.reelsList?[indexPath.row - 1]
            self.navigationController?.pushViewController(nextVC, animated: true)
        case storiesCollectionView:
            let nextVC = StoryViewerViewController.instantiate(fromAppStoryboard: .Profile)
            nextVC.comingFor = .forSelfHighlight
            self.navigationController?.pushViewController(nextVC, animated: true)
        default:
            print("Uplaod new reels")
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == storiesCollectionView {
            let offsetX = scrollView.contentOffset.x
            let maxOffset = scrollView.contentSize.width - scrollView.frame.width
            
            if offsetX > maxOffset - 120 {
                viewModel.getMyHighLights()
            }
        }
        
        if scrollView == reelsCollectionView {
            let offsetY = scrollView.contentOffset.y
            let maxOffset = scrollView.contentSize.height - scrollView.frame.height
            
            if offsetY > maxOffset - 120 {
                viewModel.getMyReelsRequest()
            }
        }
    }
    
}
//
//channel_id60
//38971227
