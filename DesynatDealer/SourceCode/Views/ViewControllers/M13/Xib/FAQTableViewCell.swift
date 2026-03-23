//
//  FAQTableViewCell.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 16/03/26.
//

import UIKit

class FAQTableViewCell: UITableViewCell {

    @IBOutlet weak var titleView: CustomView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var vectorImageView: UIImageView!
    @IBOutlet weak var descriptionView: CustomView!
    @IBOutlet weak var decsriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configData(data: FAQListDataModel?, index: Int) {
        titleLabel.text = "Q\(index + 1).\(data?.questionEnglish ?? "")"
        decsriptionLabel.text = data?.answerEnglish
    }
    
}
