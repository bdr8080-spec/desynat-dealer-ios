//
//  ProductManagementFilterViewController.swift
//  DesynatDealer
//
//  Created by fluper on 20/11/25.
//

import UIKit

class ProductManagementFilterViewController: UIViewController {
  
  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var filterTableView: UITableView!
  
  private var filtersOptions: [FilterSection] = [
    FilterSection(
      header: "Filter by Category",
      options: [
        FilterOption(title: "Male"),
        FilterOption(title: "Female"),
        FilterOption(title: "Kids")
      ]
    ),
    
    FilterSection(
      header: "Filter by Brand",
      options: [
        FilterOption(title: "Brand1"),
        FilterOption(title: "Brand2"),
        FilterOption(title: "Brand3")
      ]
    )
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    registerXib()
    headerView.layer.cornerRadius = 32
    headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    headerView.clipsToBounds = true
  }
  
  @IBAction func applyDidTapped(_ sender: Any) {
  }
  
  @IBAction func crossDidTapped(_ sender: Any) {
    self.dismiss(animated: true)
  }
  
  @IBAction func clearDidTapped(_ sender: Any) {
  }
  
  func registerXib() {
      filterTableView.delegate = self
      filterTableView.dataSource = self

      filterTableView.registerCellFromNib(cellID: "FilterOptionsTableViewCell")

      // Correct header registration
      filterTableView.register(
          UINib(nibName: "FilterHeaderTableViewCell", bundle: nil),
          forHeaderFooterViewReuseIdentifier: "FilterHeaderTableViewCell"
      )

      filterTableView.estimatedRowHeight = 0
      filterTableView.estimatedSectionHeaderHeight = 0
      filterTableView.estimatedSectionFooterHeight = 0
      filterTableView.showsVerticalScrollIndicator = false
  }

  
  
}

extension ProductManagementFilterViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return filtersOptions.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filtersOptions[section].options.count
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FilterHeaderTableViewCell") as! FilterHeaderTableViewCell
    header.titleLabel.text = filtersOptions[section].header
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    30
  }
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    0.01
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FilterOptionsTableViewCell",
                                             for: indexPath) as! FilterOptionsTableViewCell
    let option = filtersOptions[indexPath.section].options[indexPath.row]
    cell.titleLabel.text = option.title
    cell.selectedImageView.image = UIImage(named: option.isSelected ? option.selectedImage : option.unselectedImage)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    for i in 0..<filtersOptions[indexPath.section].options.count {
      filtersOptions[indexPath.section].options[i].isSelected = (i == indexPath.row)
    }
    tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
  }
  
}



