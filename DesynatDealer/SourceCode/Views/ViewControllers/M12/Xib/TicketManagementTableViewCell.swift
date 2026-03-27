//
//  TicketManagementTableViewCell.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 19/03/26.
//

import UIKit

class TicketManagementTableViewCell: UITableViewCell {

    @IBOutlet weak var ticketTypeLbl: UILabel!
    @IBOutlet weak var ticketId: UILabel!
    @IBOutlet weak var ticketRaisedOnLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var resolvedOnLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
