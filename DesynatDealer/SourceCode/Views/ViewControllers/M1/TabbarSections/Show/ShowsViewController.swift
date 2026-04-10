//
//  ShowsViewController.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit

class ShowsViewController: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView! {
        didSet {
            listTableView.registerCellFromNib(cellID: "EventsTableViewCell")
        }
    }
    @IBOutlet weak var btnGoLive: CustomButton!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    private lazy var vieWModel = ShowsViewModel(hostVC: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vieWModel.getAllLiveStreamingRequest()
        vieWModel.dealerAllLiveRequest()
    }
    
    @IBAction func goLiveTapped(_ sender: Any) {
        vieWModel.navigateToNextScreen(response: vieWModel.stramingData)
    }
    
}

extension ShowsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vieWModel.liveEventListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventsTableViewCell", for: indexPath) as! EventsTableViewCell
        cell.configData(data: vieWModel.liveEventListData[indexPath.row])
        cell.onWatchLiveSelect = { [weak self] in
            self?.vieWModel.generateLiveStramingTokenRequestForAsAudience(id: self?.vieWModel.liveEventListData[indexPath.row].id ?? 0)
        }
        return cell
    }

}
