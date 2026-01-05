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
  
  override func viewDidLoad() {
        super.viewDidLoad()

    }

  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
}


extension ChatInboxListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChatInboxTableViewCell", for: indexPath) as! ChatInboxTableViewCell
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let nextVC = ChatViewController.instantiate(fromAppStoryboard: .OrderAndChat)
    nextVC.comingFroQuotation = indexPath.row % 2 == 0
    self.navigationController?.pushViewController(nextVC, animated: true)
  }
  
  
}
