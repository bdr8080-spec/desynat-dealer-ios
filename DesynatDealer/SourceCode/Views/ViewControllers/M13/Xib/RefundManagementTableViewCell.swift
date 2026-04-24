//
//  RefundManagementTableViewCell.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 20/03/26.
//

import UIKit

class RefundManagementTableViewCell: UITableViewCell {

    //MARK: IBOutlet
    
    @IBOutlet weak var orderDateTimeLbl: UILabel!
    @IBOutlet weak var customerNameLbl: UILabel!
    @IBOutlet weak var refundIdLbl: UILabel!
    @IBOutlet weak var totalAmountLbl: UILabel!
    @IBOutlet weak var totalCommisionLbl: UILabel!
    @IBOutlet weak var paymentModeLbl: UILabel!
    @IBOutlet weak var requestesOnLbl: UILabel!
    @IBOutlet weak var returnReasonLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configData(data: RefundManagementList?) {
        orderDateTimeLbl.text = formatDateString(data?.createdAt ?? "", returnFormat: "dd/MM/yyyy 'at' hh:mm a")
        customerNameLbl.text = data?.order?.deliveryDetails?.name
        refundIdLbl.text = "#\(data?.id ?? 0)"
        totalAmountLbl.text = CommonUtils.formatPriceStringInput(data?.order?.totalAmount)
        let affiliateCommission = Double(data?.affiliateCommission ?? "0") ?? 0
        let adminCommission = Double(data?.adminCommission ?? "0") ?? 0

        let totalCommission = affiliateCommission + adminCommission
        totalCommisionLbl.text = CommonUtils.formatPrice(totalCommission)
        let paymentMethod = data?.order?.paymentMethod ?? "1"
        switch paymentMethod {
        case "1":
            paymentModeLbl.text = "Online"
        case "2":
            paymentModeLbl.text = "Wallet"
        default:
            paymentModeLbl.text = "Via COD"
        }
        requestesOnLbl.text = formatDateString(data?.order?.updatedAt ?? "", returnFormat: "dd/MM/yyyy")
        returnReasonLbl.text = data?.returnReason ?? data?.cancelReason ?? data?.cancelReason ?? ""
    }
    
    func formatDateString(_ dateString: String, returnFormat: String) -> String {
        let inputFormatter = ISO8601DateFormatter()
        inputFormatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        guard let date = inputFormatter.date(from: dateString) else {
            return ""
        }
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = returnFormat
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        return outputFormatter.string(from: date)
    }
    
}
