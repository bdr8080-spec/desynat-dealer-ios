//
//  StaffManagementTableViewCell.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 23/03/26.
//

import UIKit

class StaffManagementTableViewCell: UITableViewCell {
    
    //MARK: IBOutlet
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var btnToggle: UIButton!
    @IBOutlet weak var designationLbl: UILabel!
    @IBOutlet weak var mobileNumberLbl: UILabel!
    @IBOutlet weak var addedOnLbl: UILabel!
    @IBOutlet weak var activeStatusLbl: UILabel!
    @IBOutlet weak var profileImageView: CustomImageView!
    
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
}
