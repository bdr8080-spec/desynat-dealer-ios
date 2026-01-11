//
//  ChatViewController.swift
//  DesynatDealer
//
//  Created by fluper on 05/01/26.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var sendMessageTF: UITextField!
    @IBOutlet weak var sendQuotationButtonLabel: UILabel!
    @IBOutlet weak var priceDetailsView: CustomView!
    @IBOutlet weak var extraBottomSpaceLabelForOrderDetails: UILabel!
    @IBOutlet weak var requestIdLabel: UILabel!
    @IBOutlet weak var sendQuotationView: UIView!
    @IBOutlet weak var productDetailsView: CustomView!
    @IBOutlet weak var mainHeaderView: UIView!
    @IBOutlet weak var productTableView: UITableView! {
        didSet {
            productTableView.registerCellFromNib(cellID: "OrderForChatTableViewCell")
        }
    }
    @IBOutlet weak var chatTableView: UITableView! {
        didSet {
            chatTableView.registerCellFromNib(cellID: "ReceiverChatTableViewCell")
            chatTableView.registerCellFromNib(cellID: "SenderChatTableViewCell")
        }
    }
    var comingReason: ComingReasonAtChatScreen = .quotationSentForFirstTime
    var sendAttachmentImageUrl: String? = ""
    lazy var viewModel = ChatViewModel(hostVC: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleQuotationUI()
        viewModel.singleChatDetailRequest()
        viewModel.startListeningForMessages()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopListening()
    }
    
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendQuotationDidTapped(_ sender: Any) {
        let nextVC = SendQuotationViewController.instantiate(fromAppStoryboard: .OrderAndChat)
        nextVC.comingReason = comingReason
        nextVC.viewModel.chatDetailsUniqueId = viewModel.chatDetailsUniqueId
        //        nextVC.viewModel.itemQuantity = viewModel.chatDetails?.first?.quantity ?? 0
        nextVC.onQuotationSent = { [weak self] in
            print("update the ui after quotation sent")
            self?.sendQuotationButtonLabel.text  = "Modify Quotation"
            self?.priceDetailsView.isHidden = false
            self?.productDetailsView.isHidden = true
            self?.productTableView.reloadData()
            self?.comingReason = .doModificationAfterQuotationSent
        }
        self.navigationController?.present(nextVC, animated: true)
    }
    
    @IBAction func sendAttachmentDidTapped(_ sender: Any) {
        ImagePickerHelper.shared.showPickerController {  image , imageName in
            if let image = image {
                WebService.sharedInstance.uploadImage(withParams: image) { imageURL in
                    self.sendAttachmentImageUrl = imageURL.url ?? ""
                    self.viewModel.sendMessageRequest(messageType: 1)
                }
            }
        }
    }
    
    
    @IBAction func sendMessageDidTapped(_ sender: Any) {
        self.viewModel.sendMessageRequest(messageType: 0)
    }
    
    private func handleQuotationUI() {
        switch comingReason {
        case comingReason:
            productTableView.isHidden = false
            mainHeaderView.backgroundColor = UIColor(hex: "#FFF7EA")
            productDetailsView.isHidden = false
            sendQuotationView.isHidden = false
            requestIdLabel.isHidden = false
            extraBottomSpaceLabelForOrderDetails.isHidden = false
            priceDetailsView.isHidden = true // show when quotation is sent
        default:
            productTableView.isHidden = true
            mainHeaderView.backgroundColor = .white
            productDetailsView.isHidden = true
            sendQuotationView.isHidden = true
            requestIdLabel.isHidden = true
            extraBottomSpaceLabelForOrderDetails.isHidden = true
            priceDetailsView.isHidden = true // show when quotation is sent
        }
    }
    
    func bindData() {
        chatTableView.reloadData()
        // Scroll to bottom
        if !viewModel.messages.isEmpty {
            let indexPath = IndexPath(row: viewModel.messages.count - 1, section: 0)
            chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == productTableView {
            return 1
        } else {
            return viewModel.messages.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == productTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderForChatTableViewCell", for: indexPath) as! OrderForChatTableViewCell
            return cell
        } else {
            let message = viewModel.messages[indexPath.row]
            if message.by == "seller" {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderChatTableViewCell", for: indexPath) as! SenderChatTableViewCell
                cell.configData(data: message)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverChatTableViewCell", for: indexPath) as! ReceiverChatTableViewCell
                cell.configData(data: message)
                return cell
            }
        }
    }
    
}


