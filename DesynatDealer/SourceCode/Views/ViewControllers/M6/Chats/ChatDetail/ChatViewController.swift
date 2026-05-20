//
//  ChatViewController.swift
//  DesynatDealer
//
//  Created by fluper on 05/01/26.
//

import UIKit
import IQKeyboardManagerSwift

class ChatViewController: UIViewController {
    
    @IBOutlet weak var requetsStackView: UIStackView!
    @IBOutlet weak var viewRequestButonOutlet: UIButton!
    @IBOutlet weak var detailsStackView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var baseBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var shippingPriceLabel: UILabel!
    @IBOutlet weak var perItemPriceLabel: UILabel!
    @IBOutlet weak var customizationDetailsLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var totalQuantityLabel: UILabel!
    @IBOutlet weak var sendMessageTF: UITextField!
    @IBOutlet weak var sendQuotationButtonLabel: UILabel!
    @IBOutlet weak var priceDetailsView: CustomView!
    @IBOutlet weak var baseScrollView:UIScrollView!
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
            chatTableView.registerCellFromNib(cellID: "SenderChatForImageTableViewCell")
            chatTableView.registerCellFromNib(cellID: "ReciverChatForImageTableViewCell")
        }
    }
    
    var comingReason: ComingReasonAtChatScreen = .quotationSentForFirstTime
    lazy var selfID:String = {
        return String.getString(Global.shared.user?.id)
    }()
    lazy var viewModel = ChatEnquiryViewModel(hostVC: self)
    var chatList:[Chat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewRequestButonOutlet.setTitle("View Request".localiz(), for: .normal)
        viewModel.delegate = self
        IQKeyboardManager.shared.disabledDistanceHandlingClasses = [ChatViewController.self]
        viewModel.readChatMessagesRequest()
//        self.viewModel.callBackRefresh = {
//            self.handleUIUpdate()
//            self.baseScrollView.setNeedsDisplay()
//        }
        self.viewModel.callBackRefresh = { [weak self] in
            guard let self = self else { return }
            self.handleUIUpdate()
            self.baseScrollView.layoutIfNeeded()
            self.chatTableView.layoutIfNeeded()
            self.scrollToBottom(animated: false)  // initial load without animation
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        scrollToBottom(animated: false)
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        viewModel.singleChatDetailRequest()
        viewModel.checkForEnquiryChat()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendQuotationDidTapped(_ sender: Any) {
        let actiontype = viewModel.quotationData?.action ?? "1"
        if actiontype == "2" {
            let nextVC = SendQuotationViewController.instantiate(fromAppStoryboard: .OrderAndChat)
            nextVC.comingReason = .doModificationAfterQuotationSent
            nextVC.viewModel.chatDetailsUniqueId = viewModel.chatDetailsUniqueId
            nextVC.viewModel.itemQuantity = viewModel.quotationData?.quantity ?? "1"
            nextVC.quotationData = viewModel.quotationData
            nextVC.onQuotationSent = { [weak self] in
                self?.viewModel.singleChatDetailRequest()
            }
            present(nextVC, animated: true)
        } else {
            let nextVC = SendQuotationViewController.instantiate(fromAppStoryboard: .OrderAndChat)
            nextVC.comingReason = comingReason
            nextVC.viewModel.chatDetailsUniqueId = viewModel.chatDetailsUniqueId
            nextVC.viewModel.itemQuantity = viewModel.quotationData?.quantity ?? "1"
            nextVC.onQuotationSent = { [weak self] in
                self?.viewModel.singleChatDetailRequest()
            }
            present(nextVC, animated: true)
        }
        
    }
    
    @IBAction func sendAttachmentDidTapped(_ sender: Any) {
        ImagePickerHelper.shared.showPickerController { image, _ in
            guard let image else { return }
            WebService.sharedInstance.uploadImage(withParams: image) { [weak self] imageURL in
                self?.handleSendMessage(msg: imageURL.url ?? "", type: "1")
                self?.viewModel.sendNotificationDetails(message: "New Attachment".localiz())
            }
        }
    }
    
    @IBAction func sendMessageDidTapped(_ sender: Any) {
        guard let txt = self.sendMessageTF.text?.trimmingCharacters(in: .whitespacesAndNewlines), !txt.isEmpty else {
            self.showAlert(msg: "Please Enter Text to Send Message".localiz())
            return
        }
        self.sendMessageTF.text = nil
        handleSendMessage(msg: txt, type: "0")
        viewModel.sendNotificationDetails(message: txt)
    }
    
    private func updateNoChatUI() {
        let hasChats = !chatList.isEmpty
        chatTableView.isHidden = !hasChats
    }
    
    
    func handleSendMessage(msg: String, type: String) {
        self.viewModel.sendMsg(msg: msg, type: type)
    }
    
    func handleUIUpdate() {
        let quotationData = viewModel.quotationData
        let messageType = quotationData?.type ?? "1"
        let actiontype = quotationData?.action ?? "1"
        userNameLabel.text = quotationData?.userDetails?.fullName ?? ""
        if messageType == "1" {
            productTableView.isHidden = true
            mainHeaderView.backgroundColor = .white
            productDetailsView.isHidden = true
            sendQuotationView.isHidden = true
            requestIdLabel.isHidden = true
            priceDetailsView.isHidden = true
            detailsStackView.backgroundColor = .white
            detailsStackView.isHidden = true
            requetsStackView.isHidden = true
        } else {
            productTableView.isHidden = false
            requetsStackView.isHidden = false
            mainHeaderView.backgroundColor = UIColor(hex: "#FFF7EA")
            detailsStackView.backgroundColor = UIColor(hex: "#FFF7EA")
            detailsStackView.isHidden = false
            productDetailsView.isHidden = false
            sendQuotationView.isHidden = false
            requestIdLabel.isHidden = false
            priceDetailsView.isHidden = true
            viewRequestButonOutlet.isHidden = true
            let text = "Request Id".localiz()
            requestIdLabel.text = "\(text) #\(quotationData?.id ?? 0)"
            totalQuantityLabel.text = quotationData?.quantity
            productTableView.reloadData()
            adressLabel.text = viewModel.buildFullAddress(from: quotationData?.deliveryDetails)
            customizationDetailsLabel.text = quotationData?.customDetails
            perItemPriceLabel.text = CommonUtils.formatPriceStringInput(quotationData?.price)
            shippingPriceLabel.text = CommonUtils.formatPriceStringInput(quotationData?.shipping)
            taxLabel.text = CommonUtils.formatPriceStringInput(quotationData?.tax)
            totalAmountLabel.text = CommonUtils.formatPriceStringInput(quotationData?.totalAmount)
            switch actiontype {
            case "0":
                if let customDetails = quotationData?.customDetails,
                   !customDetails.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                   customDetails.lowercased() != "null" {
                    productTableView.isHidden = false
                    productDetailsView.isHidden = false
                    sendQuotationView.isHidden = false
                } else {
                    productTableView.isHidden = false
                    productDetailsView.isHidden = true
                    sendQuotationView.isHidden = true
                }
                
            case "1": //"Quotation Sent"
                productDetailsView.isHidden = true
                viewRequestButonOutlet.isHidden = false
                priceDetailsView.isHidden = false
            case "2":
                productDetailsView.isHidden = true
                viewRequestButonOutlet.isHidden = false
                priceDetailsView.isHidden = false
                sendQuotationButtonLabel.text = "Modify Quotation".localiz()
            case "4": //Reject quotation by user
                productDetailsView.isHidden = true
                viewRequestButonOutlet.isHidden = false
                priceDetailsView.isHidden = false
                sendQuotationView.isHidden = true
            case "5":
                productTableView.isHidden = false
                requetsStackView.isHidden = false
                priceDetailsView.isHidden = false
                sendQuotationView.isHidden = true
                productDetailsView.isHidden = true
                viewRequestButonOutlet.isHidden = false
                productTableView.reloadData()
                let orderPlace = viewModel.quotationData?.orderCreateStatus?.id
                if orderPlace != nil {
                    priceDetailsView.isHidden = false
                }
            default:
                viewRequestButonOutlet.isHidden = true
                mainHeaderView.backgroundColor = .white
                productDetailsView.isHidden = false
                sendQuotationView.isHidden = true
                requestIdLabel.isHidden = true
                priceDetailsView.isHidden = false
                detailsStackView.backgroundColor = .white
                detailsStackView.isHidden = true
                productTableView.reloadData()
            }
        }
    }
    
    @IBAction func viewRequestDidTapped(_ sender: Any) {
        let nextVC = ViewRequestViewController.instantiate(fromAppStoryboard: .OrderAndChat)
        nextVC.quotationData = viewModel.quotationData
        self.present(nextVC, animated: true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curveRaw = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }
        let keyboardHeight = keyboardFrame.height - view.safeAreaInsets.bottom
        let inputViewHeight = sendMessageTF.superview?.bounds.height ?? 0
        let curve = UIView.AnimationOptions(rawValue: curveRaw << 16)
        UIView.animate(withDuration: duration, delay: 0, options: curve) {
            // Move input view above keyboard (inverted constraint)
            self.baseBottomConstraint.constant = -keyboardHeight - 15
            // ScrollView inset = input view height ONLY
            self.baseScrollView.contentInset.bottom = inputViewHeight
            self.baseScrollView.verticalScrollIndicatorInsets.bottom = inputViewHeight
            self.view.layoutIfNeeded()
        }
        scrollToBottom()
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curveRaw = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }
        let curve = UIView.AnimationOptions(rawValue: curveRaw << 16)
        UIView.animate(withDuration: duration, delay: 0, options: curve) {
            self.baseBottomConstraint.constant = 0
            self.baseScrollView.contentInset = .zero
            self.baseScrollView.verticalScrollIndicatorInsets = .zero
            self.view.layoutIfNeeded()
        }
    }
    
//    func getNewMsgHanlder(msg: Chat) {
//        self.chatList.append(msg)
//        DispatchQueue.main.async {
//            self.chatTableView.reloadData()
//            self.updateNoChatUI()
//            self.scrollToBottom()
//        }
//    }
    
    func getNewMsgHanlder(msg: Chat) {
        self.chatList.append(msg)
        DispatchQueue.main.async {
            self.chatTableView.reloadData()
            self.updateNoChatUI()
            self.scrollToBottom()
        }
    }
    
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == productTableView {
            return 1
        } else {
            return chatList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == productTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderForChatTableViewCell", for: indexPath) as! OrderForChatTableViewCell
            let data = viewModel.quotationData?.productVariation
            let actionType = viewModel.quotationData?.action
            let orderPlace = viewModel.quotationData?.orderCreateStatus?.id
            cell.lblStatus.isHidden = true
            if actionType == "2" {
                cell.lblStatus.isHidden = false
                cell.lblStatus.text = "Pending".localiz()
                cell.lblStatus.textColor = UIColor(hexString: "#FF5F1B")
            } else if actionType == "4" {
                cell.lblStatus.isHidden = false
                cell.lblStatus.text = "Rejected".localiz()
                cell.lblStatus.textColor = UIColor(hex: "E80B26")
            }else if actionType == "5" {
                cell.lblStatus.isHidden = false
                cell.lblStatus.text = "Accepted".localiz()
                cell.lblStatus.textColor = UIColor(hexString: "#68CA44")
                priceDetailsView.isHidden = false
                if orderPlace != nil {
                    cell.lblStatus.isHidden = false
                    cell.lblStatus.text = "Placed".localiz()
                    cell.lblStatus.textColor = UIColor(hexString: "#68CA44")
                }
            }
            cell.configData(data: data)
            return cell
        }
        let chat = chatList[indexPath.row]
        let isSentByMe = chat.by == "seller"
        if chat.type == "1" {
            if isSentByMe {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReciverChatForImageTableViewCell", for: indexPath) as! ReciverChatForImageTableViewCell
                cell.configData(data: chat)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderChatForImageTableViewCell", for: indexPath) as! SenderChatForImageTableViewCell
                cell.configData(data: chat)
                return cell
            }
        } else {
            if isSentByMe {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverChatTableViewCell", for: indexPath) as! ReceiverChatTableViewCell
                cell.configData(data: chat)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderChatTableViewCell", for: indexPath) as! SenderChatTableViewCell
                cell.configData(data: chat)
                return cell
            }
        }
    }
    
//    func scrollToBottom(animated: Bool = true) {
//        DispatchQueue.main.async {
//            let contentHeight = self.baseScrollView.contentSize.height
//            let scrollViewHeight = self.baseScrollView.bounds.height
//            let bottomInset = self.baseScrollView.contentInset.bottom
//            let yOffset = max(0, contentHeight - scrollViewHeight + bottomInset)
//            self.baseScrollView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: animated)
//        }
//    }
    
    func scrollToBottom(animated: Bool = true) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            
            // Force layout pass so contentSize is updated
            self.baseScrollView.layoutIfNeeded()
            self.chatTableView.layoutIfNeeded()
            
            let contentHeight = self.baseScrollView.contentSize.height
            let scrollViewHeight = self.baseScrollView.bounds.height
            let bottomInset = self.baseScrollView.contentInset.bottom
            
            let targetOffsetY = max(0, contentHeight - scrollViewHeight + bottomInset)
            
            self.baseScrollView.setContentOffset(
                CGPoint(x: 0, y: targetOffsetY),
                animated: animated
            )
        }
    }
}

extension ChatViewController : ChatViewModelDelegate {
    
//    func getAllMsg(list: [Chat]) {
//        chatList = list
//        chatTableView.reloadData()
//        updateNoChatUI()
//        scrollToBottom()
//    }
    
    func getAllMsg(list: [Chat]) {
        chatList = list
        chatTableView.reloadData()
        updateNoChatUI()
        
        // Small delay + layoutIfNeeded
        scrollToBottom()
    }
}

extension ChatViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let rect = textField.convert(textField.bounds, to: baseScrollView)
        baseScrollView.scrollRectToVisible(rect, animated: true)
    }
}

