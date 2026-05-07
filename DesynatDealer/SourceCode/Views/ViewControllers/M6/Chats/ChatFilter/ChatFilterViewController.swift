//
//  ChatFilterViewController.swift
//  DesynatDealer
//
//  Created by fluper on 13/01/26.
//

import UIKit

class ChatFilterViewController: UIViewController {
    
    @IBOutlet weak var filtersTableView: UITableView! {
        didSet{
            filtersTableView.registerCellFromNib(cellID: "FiltersOptionsTableViewCell")
        }
    }
    @IBOutlet weak var headerView: UIView!
    
    var selectedFilter = ChatInboxListFilterModel()
    var onApplyFilter: ((ChatInboxListFilterModel) -> Void)?
    var onClearFilter: (() -> Void)?
    
    private var filtersOptions = ["All", "New", "Quotation Sent", "Quotation Accepted"]
    private var selectedIndex: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleUISetup()
        applyPreselectedData()
    }
    
    @IBAction func dismissDidTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func clearDidTapped(_ sender: Any) {
        onClearFilter?()
        dismiss(animated: true)
    }
    
    @IBAction func applyDidTapped(_ sender: Any) {
        var filter = ChatInboxListFilterModel()
        filter.orderDeliveryStatus = selectedIndex
        onApplyFilter?(filter)
        dismiss(animated: true)
    }
    
    private func handleUISetup() {
        headerView.layer.cornerRadius = 24
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true
    }
    
    private func applyPreselectedData() {
        selectedIndex = selectedFilter.orderDeliveryStatus ?? -1
    }
    
}

extension ChatFilterViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtersOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FiltersOptionsTableViewCell", for: indexPath) as! FiltersOptionsTableViewCell
        cell.titleLabel.text = filtersOptions[indexPath.row].localiz()
        if selectedIndex == indexPath.row {
            cell.mainImageView.image = .filledCheckbox
        } else {
            cell.mainImageView.image = .checkBox
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        filtersTableView.reloadData()
    }
    
}

struct ChatInboxListFilterModel {
    var orderDeliveryStatus: Int?
    
    var isEmpty: Bool {
        return orderDeliveryStatus == nil
    }
}
