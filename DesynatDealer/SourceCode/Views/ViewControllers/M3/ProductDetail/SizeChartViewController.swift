//
//  SizeChartViewController.swift
//  DesynatDealer
//
//  Created by fluper on 25/11/25.
//

import UIKit
import SDWebImage

class SizeChartViewController: UIViewController {

  @IBOutlet weak var titleView: UIView!
  @IBOutlet weak var mainImageView: CustomImageView!
  
  var sizeChartUrl: String? = ""
  
  override func viewDidLoad() {
        super.viewDidLoad()
    configData()
    titleView.layer.cornerRadius = 32
    titleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    titleView.clipsToBounds = true
    }
    

  @IBAction func dismissDidTapped(_ sender: Any) {
    self.dismiss(animated: true)
  }
  
  func configData() {
      if let imageUrlString = sizeChartUrl,
        let url = URL(string: imageUrlString) {
          mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
          mainImageView.sd_imageIndicator?.startAnimatingIndicator()
          mainImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "userProfile"))
      } else {
          mainImageView.image = UIImage(named: "userProfile")
      }
  }
  
}
