//
//  TicketDetailViewController.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 20/03/26.
//

import UIKit
import SDWebImage

class TicketDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ticketTypeLabel: UILabel!
    @IBOutlet weak var ticketIdLabel: UILabel!
    @IBOutlet weak var raisedOnDateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var resolvedOnDateLabel: UILabel!
    @IBOutlet weak var resolvedOnStackView: UIStackView!
    @IBOutlet weak var attachmentView: UIView!
    @IBOutlet weak var attachmentImageView: CustomImageView!
    @IBOutlet weak var attachmnetButton: UIButton!
    @IBOutlet weak var lblDetailsTitle: UILabel!
    
    var ticketDetails: SupportList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configData()
        lblDetailsTitle.text = "Details".localiz()
    }

    // MARK: - Navigation
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func attachmmentDidTapped(_ sender: Any) {
        guard let data = ticketDetails else { return }
        if let file = data.file?.lowercased(),
           file.hasSuffix(".pdf") {
            openPDF(urlString: data.file ?? "")
        } else {
            attachmentImageView.enableFullscreenZoom()
        }
    }
    
    func configData() {
        guard let data = ticketDetails else { return }
        ticketIdLabel.text = data.ticketID ?? ""
        ticketTypeLabel.text = data.ticketTypeDetails?.name ?? ""
        raisedOnDateLabel.text = convertServerDate(data.createdAt ?? "")
        let status = statusType(status: data.status ?? 0)
        statusLabel.text = status.text
        statusLabel.textColor = status.color
        descriptionLabel.text = data.description ?? ""
        if let imageUrlString = data.file,
           let url = URL(string: imageUrlString) {
            attachmentImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            attachmentImageView.sd_imageIndicator?.startAnimatingIndicator()
            attachmentImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "uploadTicket"))
        } else {
            attachmentImageView.image = UIImage(named: "uploadTicket")
        }
        resolvedOnStackView.isHidden = (data.status != 1)
        resolvedOnDateLabel.text = convertServerDate(data.updatedAt ?? "")
        attachmentView.isHidden = (data.file?.isEmpty ?? true)
        titleLabel.text = data.title ?? ""
        if let file = data.file?.lowercased(),
           file.hasSuffix(".pdf") {
            attachmnetButton.isUserInteractionEnabled = true
        } else {
            attachmnetButton.isUserInteractionEnabled = false
        }
        attachmentImageView.enableFullscreenZoom()
    }
    
    func statusType(status: Int) -> (text: String, color: UIColor) {
        let state = TicketStatus(rawValue: status)
        return (state?.text ?? "Unknown", state?.color ?? .gray)
    }
    
    func convertServerDate(_ isoString: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"

        guard let date = formatter.date(from: isoString) else {
            return isoString
        }

        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        outputFormatter.dateFormat = "dd MMM yy, h:mm a"   // <- Output format

        return outputFormatter.string(from: date)
    }
    
    func openPDF(urlString: String) {
        let pdfVC = PDFViewerViewController()
        pdfVC.pdfURLString = urlString
        self.navigationController?.present(pdfVC, animated: true)
    }

}
