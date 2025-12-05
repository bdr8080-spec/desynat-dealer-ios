//
//  DelearProfileViewController.swift
//  DesynatDealer
//
//  Created by fluper on 05/12/25.
//

import UIKit

class DelearProfileViewController: UIViewController {
  
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    DispatchQueue.main.async {
      self.reelsCollectionViewHeightConstratint.constant = self.reelsCollectionView.contentSize.height
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
  

  
}

extension DelearProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch collectionView {
    case storiesCollectionView:
      return 2
    case reelsCollectionView:
      return 5
    default:
      return 0
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch collectionView {
    case storiesCollectionView:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoresDetailsCollectionViewCell", for: indexPath) as! StoresDetailsCollectionViewCell
      return cell
    case reelsCollectionView:
      if indexPath.row == 0 {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadNewReelsCollectionViewCell", for: indexPath) as! UploadNewReelsCollectionViewCell
        return cell
      } else {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReelsCollectionViewCell", for: indexPath) as! ReelsCollectionViewCell
        return cell
      }
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
  
}
