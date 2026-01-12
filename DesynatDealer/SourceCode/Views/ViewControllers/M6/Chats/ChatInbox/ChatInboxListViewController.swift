//
//  ChatInboxListViewController.swift
//  DesynatDealer
//
//  Created by fluper on 05/01/26.
//

import UIKit

class ChatInboxListViewController: UIViewController {
  
  @IBOutlet weak var inboxTableView: UITableView! {
    didSet {
      inboxTableView.registerCellFromNib(cellID: "ChatInboxTableViewCell")
    }
  }
  
  private lazy var viewModel = ChatInboxListViewModel(hostVC: self)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.getChatInboxRequest()
  }
  
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  func bindData() {
    inboxTableView.reloadData()
  }
  
}


extension ChatInboxListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.chatList?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChatInboxTableViewCell", for: indexPath) as! ChatInboxTableViewCell
    let data = viewModel.chatList?[indexPath.row]
    cell.configData(data: data)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let nextVC = ChatViewController.instantiate(fromAppStoryboard: .OrderAndChat)
    nextVC.comingReason = .quotationSentForFirstTime
    nextVC.viewModel.chatDetailsUniqueId = viewModel.chatList?[indexPath.row].uniqueID ?? ""
    self.navigationController?.pushViewController(nextVC, animated: true)
  }
  
  
}
