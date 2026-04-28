//
//  StaffManagementTableViewCell.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 23/03/26.
//

import UIKit
import SDWebImage

class StaffManagementTableViewCell: UITableViewCell {
    
    //MARK: IBOutlet
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var btnToggle: UIButton!
    @IBOutlet weak var designationLbl: UILabel!
    @IBOutlet weak var mobileNumberLbl: UILabel!
    @IBOutlet weak var addedOnLbl: UILabel!
    @IBOutlet weak var activeStatusLbl: UILabel!
    @IBOutlet weak var profileImageView: CustomImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var buttonActionstackView: UIStackView!
    @IBOutlet weak var deleteButton: UIButton!
    
    //MARK: Variable
    var isStatusToggled: (() -> Void)?
    var isDeleteTapped: (() -> Void)?
    var isEditTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func toggleBtnTapped(_ sender: Any) {
        isStatusToggled?()
    }
    
    @IBAction func deleteBtnTapped(_ sender: Any) {
        isDeleteTapped?()
    }
    
    @IBAction func editDidTapped(_ sender: Any) {
        isEditTapped?()
    }
    
    func cellSetup(_ data:StaffDetails, hasActionPermission: Bool) {
        editButton.isHidden = !hasActionPermission
        deleteButton.isHidden = !hasActionPermission
        btnToggle.isUserInteractionEnabled = hasActionPermission
        
        self.nameLbl.text = data.firstName ?? ""
        self.designationLbl.text = data.sellerCategory?.nameEn ?? ""
        self.mobileNumberLbl.text = "\(data.countryCode ?? "")-\(data.mobile ?? "")"
        if data.isBlock == 0 {
            btnToggle.setImage(UIImage(named: "toggle_on"), for: .normal)
            self.activeStatusLbl.text = "Active"
            self.activeStatusLbl.textColor = UIColor(hex: "1A900D")
        }else {
            btnToggle.setImage(UIImage(named: "toggle_off"), for: .normal)
            self.activeStatusLbl.text = "Inactive"
            self.activeStatusLbl.textColor = UIColor(hex: "E80B26")
        }
//        isActiveLbl.textColor = isBlocked ? UIColor(hex: "1A900D") : UIColor(hex: "E80B26")
        self.addedOnLbl.text = formatAddedOnDate(data.createdAt ?? "")
        if let imageUrlString = data.profilePic,
           let url = URL(string: imageUrlString) {
            profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            profileImageView.sd_imageIndicator?.startAnimatingIndicator()
            profileImageView.sd_setImage(with: url, placeholderImage: .userProfile)
        } else {
            profileImageView.image = .userProfile
        }
    }
    
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
}
