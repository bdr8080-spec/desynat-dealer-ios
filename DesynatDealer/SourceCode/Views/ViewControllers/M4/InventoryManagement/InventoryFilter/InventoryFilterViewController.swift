//
//  InventoryFilterViewController.swift
//  DesynatDealer
//
//  Created by fluper on 06/12/25.
//

import UIKit

class InventoryFilterViewController: UIViewController {
  
  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var filterTableView: UITableView!
  
  var selectedBrandIDs: [String] = []
  var onFilterApplied: ((_ brandIDs: [String]) -> Void)?
  var filtersOptions: [FilterSection] = []
  var brandsList: [BrandsListDataModel] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    registerXib()
    setupUI()
    prepareFilters()
  }
  
  @IBAction func applyDidTapped(_ sender: Any) {
    
    let brandIDs = filtersOptions[0].options
      .filter { $0.isSelected }
      .map { $0.id }
    
    onFilterApplied?(brandIDs)
    dismiss(animated: true)
  }
  
  @IBAction func crossDidTapped(_ sender: Any) {
    self.dismiss(animated: true)
  }
  
  @IBAction func clearDidTapped(_ sender: Any) {
    selectedBrandIDs.removeAll()
    prepareFilters()
    onFilterApplied?([])
    dismiss(animated: true)
  }
  
  func setupUI() {
    headerView.layer.cornerRadius = 32
    headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    headerView.clipsToBounds = true
  }
  
  // MARK: - Prepare Filter List
  func prepareFilters() {
    
    // BRAND - Multiple selection
    let brandOptions = brandsList.map {
      FilterOption(
        id: "\($0.id ?? 0)",
        title: $0.nameEnglish ?? "",
        isSelected: selectedBrandIDs.contains("\($0.id ?? 0)")
      )
    }
    
    filtersOptions = [
      FilterSection(header: "Filter by Brand", options: brandOptions)
    ]
    
    filterTableView.reloadData()
  }
  
  
  func registerXib() {
    filterTableView.delegate = self
    filterTableView.dataSource = self
    filterTableView.registerCellFromNib(cellID: "FilterOptionsTableViewCell")
    filterTableView.register(
      UINib(nibName: "FilterHeaderTableViewCell", bundle: nil),
      forHeaderFooterViewReuseIdentifier: "FilterHeaderTableViewCell"
    )
    filterTableView.estimatedRowHeight = 0
    filterTableView.estimatedSectionHeaderHeight = 0
    filterTableView.estimatedSectionFooterHeight = 0
    filterTableView.showsVerticalScrollIndicator = false
    
    headerView.layer.cornerRadius = 32
    headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    headerView.clipsToBounds = true
  }

}

extension InventoryFilterViewController: UITableViewDelegate, UITableViewDataSource {
  
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
    let cell = tableView.dequeueReusableCell(
      withIdentifier: "FilterOptionsTableViewCell",
      for: indexPath
    ) as! FilterOptionsTableViewCell
    
    let option = filtersOptions[indexPath.section].options[indexPath.row]
    cell.titleLabel.text = option.title
    cell.selectedImageView.image = UIImage(
      named: option.isSelected ? option.selectedImage : option.unselectedImage
    )
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    filtersOptions[0].options[indexPath.row].isSelected.toggle()
    tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
  }
  
}



