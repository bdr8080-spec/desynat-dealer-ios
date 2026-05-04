//
//  ShowsViewController.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit

class ShowsViewController: UIViewController {
    
    @IBOutlet weak var backButton: RTLButton!
    @IBOutlet weak var listTableView: UITableView! {
        didSet {
            listTableView.registerCellFromNib(cellID: "EventsTableViewCell")
        }
    }
    @IBOutlet weak var btnGoLive: CustomButton!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    
    private lazy var vieWModel = ShowsViewModel(hostVC: self)
    var hasActionPermission: Bool = true
    var comingFromTabbar: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.isHidden = comingFromTabbar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vieWModel.getAllLiveStreamingRequest()
        vieWModel.dealerAllLiveRequest()
    }
    
    @IBAction func goLiveTapped(_ sender: Any) {
        vieWModel.navigateToNextScreen(response: vieWModel.stramingData)
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
