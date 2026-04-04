//
//  ShowsViewController.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit

class ShowsViewController: UIViewController {
    
    @IBOutlet weak var btnGoLive: CustomButton!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    private lazy var vieWModel = ShowsViewModel(hostVC: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vieWModel.getAllLiveStreamingRequest()
    }
    
    @IBAction func goLiveTapped(_ sender: Any) {
        vieWModel.navigateToNextScreen(response: vieWModel.stramingData)
    }
    
}
