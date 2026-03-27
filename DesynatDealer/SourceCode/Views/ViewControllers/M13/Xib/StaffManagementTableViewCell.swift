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
    var isOn: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func toggleBtnTapped(_ sender: Any) {
        isOn.toggle() // switch true/false
            let imageName = isOn ? "toggle_on" : "toggle_off"
            btnToggle.setImage(UIImage(named: imageName), for: .normal)
    }
    
    @IBAction func deleteBtnTapped(_ sender: Any) {
        
    }
    
    
}
