//
//  MyNotificationsListViewController.swift
//  DesynatAdmin
//
//  Created by fluper_mac3 on 17/03/26.
//

import UIKit

class MyNotificationsListViewController: UIViewController {

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
        viewModel.getMyNotificationsListRequest()
    }

    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - TABLE VIEW METHODS
extension MyNotificationsListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
        //return viewModel.notificationSentList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyNotificationsTableViewCell", for: indexPath) as! MyNotificationsTableViewCell
        //let data = viewModel.notificationSentList[indexPath.row]
      //  cell.configData(data: data)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedNotificationId = viewModel.notificationSentList[indexPath.row].id ?? 0
//        viewModel.markReadNotificationsRequest()
    }
}
