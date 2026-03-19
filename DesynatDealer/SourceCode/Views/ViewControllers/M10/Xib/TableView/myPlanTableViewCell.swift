//
//  myPlanTableViewCell.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 18/03/26.
//

import UIKit

class myPlanTableViewCell: UITableViewCell {

    @IBOutlet weak var titleView: CustomView!
    
    @IBOutlet weak var lblPurchasedOn: UILabel!
    
    @IBOutlet weak var lblAmount: UILabel!
    
    @IBOutlet weak var lblPlanDateTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topSet()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        topSet()
    }
    func topSet(){
        titleView.layer.cornerRadius = 12
        titleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        titleView.clipsToBounds = true
    }
    
    @IBAction func renewPlanbtn(_ sender: Any) {
        
    }
    
}

