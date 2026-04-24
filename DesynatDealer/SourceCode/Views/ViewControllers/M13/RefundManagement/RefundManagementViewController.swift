//
//  RefundManagementViewController.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 20/03/26.
//

import UIKit

class RefundManagementViewController: UIViewController {
    @IBOutlet weak var ticketTableView: UITableView!
    {
        didSet {
            ticketTableView.delegate = self
            ticketTableView.dataSource = self
            ticketTableView.registerCellFromNib(cellID: "RefundManagementTableViewCell")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    // MARK: - Navigation
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func filterBtn(_ sender: Any) {
        let vc = RefundManagementFilterViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        self.navigationController?.present(vc, animated: false)
    }
    
}

extension RefundManagementViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RefundManagementTableViewCell", for: indexPath) as! RefundManagementTableViewCell
        return cell
    }
}
