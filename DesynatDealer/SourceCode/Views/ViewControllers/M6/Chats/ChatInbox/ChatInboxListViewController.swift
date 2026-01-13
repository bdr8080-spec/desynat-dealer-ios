//
//  ChatInboxListViewController.swift
//  DesynatDealer
//
//  Created by fluper on 05/01/26.
//

import UIKit

class ChatInboxListViewController: UIViewController {
  
  @IBOutlet weak var searchTF: UITextField!
  @IBOutlet weak var noChatFoundLabel: UILabel!
  @IBOutlet weak var inboxTableView: UITableView! {
    didSet {
      inboxTableView.registerCellFromNib(cellID: "ChatInboxTableViewCell")
    }
  }
  
  private lazy var viewModel = ChatInboxListViewModel(hostVC: self)
  private var searchWorkItem: DispatchWorkItem?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchTF.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.getChatInboxRequest()
  }
  
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func filterDidTapped(_ sender: Any) {
    let vc = ChatFilterViewController.instantiate(fromAppStoryboard: .OrderAndChat)
    vc.selectedFilter = viewModel.appliedFilter
    vc.onApplyFilter = { [weak self] filter in
        guard let self = self else { return }
        self.viewModel.appliedFilter = filter
//        self.viewModel.currentPage = 1
        self.viewModel.getChatInboxRequest()
    }
    vc.onClearFilter = { [weak self] in
        guard let self = self else { return }
        self.viewModel.appliedFilter = ChatInboxListFilterModel()
//        self.viewModel.currentPage = 1
        self.viewModel.getChatInboxRequest()
    }
    self.navigationController?.present(vc, animated: false)
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

extension ChatInboxListViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            viewModel.getChatInboxRequest()
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}
