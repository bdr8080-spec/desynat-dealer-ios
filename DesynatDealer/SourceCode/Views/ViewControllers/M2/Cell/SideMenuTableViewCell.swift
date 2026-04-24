//
//  SideMenuTableViewCell.swift
//  DesynatAdmin
//
//  Created by Rakhi Kumari on 31/10/25.
//

import UIKit
import SDWebImage

class SideMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configData(data: SideMenuModel) {
        titleLabel.text = data.title
        mainImageView.image = UIImage(named: data.image)
    }
    
    func configSubDealerData(data: RoleAction?) {
        titleLabel.text = data?.sellermenu?.first?.title ?? ""
        let iconPath = data?.sellermenu?.first?.icon ?? ""
        guard !iconPath.isEmpty else {
            mainImageView.image = .staffMan.withRenderingMode(.alwaysTemplate)
            mainImageView.tintColor = UIColor.brown
            return
        }
        let imageUrlString = "\(BaseURL.release)/\(iconPath)"
        if let url = URL(string: imageUrlString) {
            mainImageView.sd_imageIndicator =
            SDWebImageActivityIndicator.gray
            mainImageView.sd_setImage(with: url,placeholderImage: .staffMan) { [weak self] image, _, _, _ in
                guard let self = self else { return }
                self.mainImageView.image =
                image?.withRenderingMode(.alwaysTemplate)
                self.mainImageView.tintColor = UIColor.brown
            }
        } else {
            mainImageView.image = .staffMan.withRenderingMode(.alwaysTemplate)
            mainImageView.tintColor = UIColor.brown
        }
    }
}


