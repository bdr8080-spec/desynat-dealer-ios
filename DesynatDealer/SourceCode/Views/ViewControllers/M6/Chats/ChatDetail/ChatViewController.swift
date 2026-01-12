//
//  ChatViewController.swift
//  DesynatDealer
//
//  Created by fluper on 05/01/26.
//

import UIKit
import IQKeyboardManagerSwift

class ChatViewController: UIViewController {
  
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
  var viewModel = ChatEnquiryViewModel()
  var chatList:[Chat] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    handleQuotationUI()
    viewModel.delegate = self
    IQKeyboardManager.shared.disabledDistanceHandlingClasses = [ChatViewController.self]
    self.viewModel.callBackRefresh = {
                self.handleUIUpdate()
      self.baseScrollView.setNeedsDisplay()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    self.viewModel.singleChatDetailRequest()
    self.viewModel.checkForEnquiryChat()
    //    IQKeyboardManager.shared. = false
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    //    IQKeyboardManager.shared.enable = true
    NotificationCenter.default.removeObserver(self)
  }
  
  @IBAction func backDidTapped(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func sendQuotationDidTapped(_ sender: Any) {
    let nextVC = SendQuotationViewController.instantiate(fromAppStoryboard: .OrderAndChat)
    nextVC.comingReason = comingReason
    nextVC.viewModel.chatDetailsUniqueId = viewModel.chatDetailsUniqueId
    nextVC.viewModel.itemQuantity = viewModel.quotationData?.quantity ?? "1"
    nextVC.onQuotationSent = { [weak self] in
      self?.sendQuotationButtonLabel.text = "Modify Quotation"
      self?.priceDetailsView.isHidden = false
      self?.productDetailsView.isHidden = true
      self?.productTableView.reloadData()
      self?.comingReason = .doModificationAfterQuotationSent
    }
    present(nextVC, animated: true)
  }
  
  @IBAction func sendAttachmentDidTapped(_ sender: Any) {
    ImagePickerHelper.shared.showPickerController { image, _ in
      guard let image else { return }
      WebService.sharedInstance.uploadImage(withParams: image) { [weak self] imageURL in
        self?.handleSendMessage(msg: imageURL.url ?? "", type: "1")
      }
    }
  }
  
  @IBAction func sendMessageDidTapped(_ sender: Any) {
    guard let txt = self.sendMessageTF.text?.trimmingCharacters(in: .whitespacesAndNewlines), !txt.isEmpty else {
      self.showAlert(msg: "Please Enter Text to Send Message")
      return
    }
    self.sendMessageTF.text = nil
    handleSendMessage(msg: txt, type: "0")
  }
  
  func handleSendMessage(msg: String, type: String) {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    let isoDate = formatter.string(from: Date())
    let localChat = Chat(uniqueId: viewModel.chatDetailsUniqueId,senderId: self.selfID, type: type,message: msg,by: "seller", read: 0,times: isoDate)
    self.chatList.append(localChat)
    self.chatTableView.reloadData()
    self.scrollToBottom()
    // Send to Firebase
    self.viewModel.sendMsg(msg: msg, type: type)
  }
  
  private func handleQuotationUI() {
    switch comingReason {
    case comingReason:
      productTableView.isHidden = false
      mainHeaderView.backgroundColor = UIColor(hex: "#FFF7EA")
      productDetailsView.isHidden = false
      sendQuotationView.isHidden = false
      requestIdLabel.isHidden = false
      priceDetailsView.isHidden = true
    default:
      productTableView.isHidden = true
      mainHeaderView.backgroundColor = .white
      productDetailsView.isHidden = true
      sendQuotationView.isHidden = true
      requestIdLabel.isHidden = true
      priceDetailsView.isHidden = true
    }
  }
  
  func handleUIUpdate() {
    let quotationData = viewModel.quotationData
    let messageType = quotationData?.type ?? "1" // normal msg, customization send
    let productRequest = quotationData?.productRequest ?? "1"
    let actiontype = quotationData?.action ?? "1"
    userNameLabel.text = quotationData?.userDetails?.fullName ?? ""
    switch messageType {
    case "1":
      productTableView.isHidden = true
      mainHeaderView.backgroundColor = .white
      productDetailsView.isHidden = true
      sendQuotationView.isHidden = true
      requestIdLabel.isHidden = true
      priceDetailsView.isHidden = true
    default:
      productTableView.isHidden = false
      mainHeaderView.backgroundColor = UIColor(hex: "#FFF7EA")
      productDetailsView.isHidden = false
      sendQuotationView.isHidden = false
      requestIdLabel.isHidden = false
      priceDetailsView.isHidden = true
      totalQuantityLabel.text = quotationData?.quantity
      productTableView.reloadData()
      adressLabel.text = viewModel.buildFullAddress(from: quotationData?.deliveryDetails)
      customizationDetailsLabel.text = quotationData?.customDetails
      perItemPriceLabel.text = CommonUtils.formatPriceStringInput(quotationData?.price)
      shippingPriceLabel.text = CommonUtils.formatPriceStringInput(quotationData?.shipping)
      taxLabel.text = CommonUtils.formatPriceStringInput(quotationData?.tax)
      totalAmountLabel.text = CommonUtils.formatPriceStringInput(quotationData?.totalAmount)
      
      switch productRequest {
      case "1":
        print("new request")
        
        switch actiontype {
        case "0":
          print("new request actiontype")
//          messageTypeLabel.text = "New"
//          messageTypeLabel.textColor = UIColor(hex: "#EA9413") // orange
//          messageTypeStatusView.backgroundColor = UIColor(hex: "#EA9413")?.withAlphaComponent(0.5)
        case "1":
          print("Quotation Sent")
//          messageTypeLabel.text = "Quotation Sent"
//          messageTypeLabel.textColor = UIColor(hex: "#172B85") // dark blue
//          messageTypeStatusView.backgroundColor = UIColor(hex: "#172B85")?.withAlphaComponent(0.5)
        case "2":
          print("Quotation Accepted")
          sendQuotationButtonLabel.text = "Modify Quotation"
          priceDetailsView.isHidden = false
          productDetailsView.isHidden = true
        default:
          print("default")
//          messageTypeStatusView.isHidden = true
        }
      default:
        print("====")
      }
    }
  }
  
  
  
  @objc func keyboardWillShow(_ notification: Notification) {
    guard
      let userInfo = notification.userInfo,
      let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
      let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
      let curveRaw = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
    else { return }
    
    let keyboardHeight = keyboardFrame.height
    let safeAreaBottom = view.safeAreaInsets.bottom
    let finalHeight = keyboardHeight - safeAreaBottom
    let curve = UIView.AnimationOptions(rawValue: curveRaw << 16)
    
    UIView.animate(withDuration: duration, delay: 0, options: curve) {
      // Move input view above keyboard
      self.baseBottomConstraint.constant = finalHeight + 400
      
      // 👇 THIS IS THE IMPORTANT PART
      self.chatTableView.contentInset.bottom = finalHeight
      self.chatTableView.scrollIndicatorInsets.bottom = finalHeight
      
      self.view.layoutIfNeeded()
      self.scrollChatToBottom()
    }
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
      self.chatTableView.contentInset = .zero
      self.chatTableView.scrollIndicatorInsets = .zero
      self.view.layoutIfNeeded()
    }
  }
  
  func scrollChatToBottom(animated: Bool = true) {
    DispatchQueue.main.async {
      let rows = self.chatTableView.numberOfRows(inSection: 0)
      guard rows > 0 else { return }
      
      let indexPath = IndexPath(row: rows - 1, section: 0)
      self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
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
      cell.configData(data: data)
      return cell
    }
    
    let chat = chatList[indexPath.row]
    let isSentByMe = chat.by == "seller"
    
    if chat.type == "1" {   // image
      if isSentByMe {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReciverChatForImageTableViewCell", for: indexPath) as! ReciverChatForImageTableViewCell
        cell.configData(data: chat)
        return cell
      } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SenderChatForImageTableViewCell", for: indexPath) as! SenderChatForImageTableViewCell
        cell.configData(data: chat)
        return cell
      }
    } else {                // text
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

  func scrollToBottom(animated: Bool = true) {
    DispatchQueue.main.async {
      let contentHeight = self.baseScrollView.contentSize.height
      let scrollViewHeight = self.baseScrollView.bounds.height
      let bottomInset = self.baseScrollView.contentInset.bottom
      
      let yOffset = max(0, contentHeight - scrollViewHeight + bottomInset)
      self.baseScrollView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: animated)
    }
  }
  
  
}

extension ChatViewController : ChatViewModelDelegate {
  
  func getAllMsg(list: [Chat]) {
    self.chatList = list
    self.chatTableView.reloadData()
    self.scrollToBottom()
  }
  
  func getNewMsg(msg: Chat) {
    guard !self.chatList.contains(where: { $0.uniqueId == msg.uniqueId }) else { return }
    
    self.chatList.append(msg)
    
    DispatchQueue.main.async {
      self.chatTableView.reloadData()
      self.scrollToBottom()
    }
  }
  
}

extension ChatViewController : UITextFieldDelegate {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    let rect = textField.convert(textField.bounds, to: baseScrollView)
    baseScrollView.scrollRectToVisible(rect, animated: true)
  }
}
