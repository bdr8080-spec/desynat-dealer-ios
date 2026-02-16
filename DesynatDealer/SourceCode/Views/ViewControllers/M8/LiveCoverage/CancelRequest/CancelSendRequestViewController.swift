//
//  CancelSendRequestViewController.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 13/02/26.
//

import UIKit

class CancelSendRequestViewController: UIViewController {

    @IBOutlet weak var txtReason: UITextView!
    @IBOutlet weak var reasonView: UIView!
    @IBOutlet weak var cancelTableView: UITableView! {
        didSet {
            cancelTableView.registerCellFromNib(cellID: "FiltersOptionsTableViewCell")
        }
    }
    @IBOutlet weak var headerView: UIView!
    
    var rejectReasonData = ["Reason 1", "Reason 2", "Others"]
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
    }
    
    @IBAction func dismissDidTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func submitDidTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    private func handleUISetup() {
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
    }
}

extension CancelSendRequestViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rejectReasonData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FiltersOptionsTableViewCell", for: indexPath) as! FiltersOptionsTableViewCell
        
        cell.titleLabel.text = rejectReasonData[indexPath.row]
        
        if selectedIndex == indexPath.row {
            cell.mainImageView.image = UIImage(named: "radioSelected")
        } else {
            cell.mainImageView.image = UIImage(named: "radioUnselected")
        }
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        
        // Check if "Others" is selected (last index)
        let isOtherSelected = indexPath.row == rejectReasonData.count - 1
        
        reasonView.isHidden = !isOtherSelected
        
        if isOtherSelected {
            txtReason.text = ""
        } else {
            txtReason.text = ""
        }

        cancelTableView.reloadData()
    }

    
    
}

