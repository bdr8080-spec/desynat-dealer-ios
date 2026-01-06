//
//  ChatViewController.swift
//  DesynatDealer
//
//  Created by fluper on 05/01/26.
//

import UIKit

class ChatViewController: UIViewController {
  
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
      handleQuotationUI()
  }
  
  
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func sendQuotationDidTapped(_ sender: Any) {
    let nextVC = SendQuotationViewController.instantiate(fromAppStoryboard: .OrderAndChat)
    nextVC.comingReason = comingReason
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
  
  func handleQuotationUI() {
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
  
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView == productTableView {
      return 1
    } else {
      return 5
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if tableView == productTableView {
      let cell = tableView.dequeueReusableCell(withIdentifier: "OrderForChatTableViewCell", for: indexPath) as! OrderForChatTableViewCell
      return cell
    } else {
      if indexPath.row % 2 == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverChatTableViewCell", for: indexPath) as! ReceiverChatTableViewCell
        return cell
      } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SenderChatTableViewCell", for: indexPath) as! SenderChatTableViewCell
        return cell
      }
    }
  }
  
}

enum ComingReasonAtChatScreen {
  case quotationSentForFirstTime
  case doModificationAfterQuotationSent
}
