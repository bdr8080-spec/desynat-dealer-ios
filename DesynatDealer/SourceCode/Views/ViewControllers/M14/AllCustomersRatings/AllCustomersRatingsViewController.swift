//
//  AllCustomersRatingsViewController.swift
//  DesynatDealer
//
//  Created by fluper_mac2 on 21/05/26.
//

import UIKit

class AllCustomersRatingsViewController: UIViewController {
    
    @IBOutlet weak var ratingTableview: UITableView! {
        didSet {
            ratingTableview.registerCellFromNib(cellID: "ProductRatingTableViewCell")
        }
    }
    
    var ratingReview: [Review]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingTableview.reloadData()
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AllCustomersRatingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ratingReview?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductRatingTableViewCell", for: indexPath) as! ProductRatingTableViewCell
        let data = ratingReview?[indexPath.row]
        cell.configData(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
