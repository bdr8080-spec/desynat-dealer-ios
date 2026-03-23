//
//  MyNotificationsListViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 17/03/26.
//

import UIKit

class MyNotificationsListViewController: UIViewController {
    
    @IBOutlet weak var readAllButtonOutlet: UIButton!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var listTableView: UITableView!{
        didSet {
            listTableView.registerCellFromNib(cellID: "MyNotificationsTableViewCell")
        }
    }
    private lazy var viewModel = MyNotificationsListViewModel(hostVC: self)
    var selectedNotificationId = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.resetAndFetchStories()
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func readAllDidTapped(_ sender: Any) {
        viewModel.markAllReadNotificationsRequest()
    }
}

// MARK: - TABLE VIEW METHODS
extension MyNotificationsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.notificationSentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyNotificationsTableViewCell", for: indexPath) as! MyNotificationsTableViewCell
        let data = viewModel.notificationSentList[indexPath.row]
        cell.configData(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.notificationSentList[indexPath.row].isRead == 0 {
            selectedNotificationId = viewModel.notificationSentList[indexPath.row].id ?? 0
            viewModel.markReadNotificationsRequest()
        }
    }
}

extension MyNotificationsListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Don't paginate if content is not scrollable
        guard scrollView.contentSize.height > scrollView.frame.height else {
            return
        }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight - 100 {
            viewModel.getMyNotificationsListRequest()
        }
    }
    
}
