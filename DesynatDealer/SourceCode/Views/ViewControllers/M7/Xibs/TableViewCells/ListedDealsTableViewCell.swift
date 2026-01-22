//
//  ListedDealsTableViewCell.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 22/01/26.
//

import UIKit

class ListedDealsTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var statusLabel: CustomLabelFont!
    @IBOutlet weak var addedOnLabel: CustomLabelFont!
    @IBOutlet weak var fromLabel: CustomLabelFont!
    @IBOutlet weak var startsOnLabel: CustomLabelFont!
    @IBOutlet weak var starstFromLabel: CustomLabelFont!
    @IBOutlet weak var listedDealsView: UIView!
    @IBOutlet weak var detailsStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configData(type: DealsListedType) {
        listedDealsView.isHidden = true
        detailsStackView.isHidden = true
        switch type {
        case .listedDeals:
            listedDealsView.isHidden = false
        case .enrolled:
            detailsStackView.isHidden = false
        case .expired:
            detailsStackView.isHidden = false
        }
    }
}
