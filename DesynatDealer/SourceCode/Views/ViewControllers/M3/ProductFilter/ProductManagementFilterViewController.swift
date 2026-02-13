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
  
  
  lazy var viewModel = FilterManagementViewModel(hostVC: self)
  var selectedCategoryIDs: [String] = []
  var selectedBrandIDs: [String] = []
  var onFilterApplied: ((_ categoryIDs: [String], _ brandIDs: [String]) -> Void)?
  var filtersOptions: [FilterSection] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    registerXib()
    setupUI()
    prepareFilters()
  }
  
  @IBAction func applyDidTapped(_ sender: Any) {
    let categoryIDs = filtersOptions[0].options
      .filter { $0.isSelected }
      .map { $0.id }
    
    let brandIDs = filtersOptions[1].options
      .filter { $0.isSelected }
      .map { $0.id }
    
    onFilterApplied?(categoryIDs, brandIDs)
    dismiss(animated: true)
  }
  
  @IBAction func crossDidTapped(_ sender: Any) {
    self.dismiss(animated: true)
  }
  
  @IBAction func clearDidTapped(_ sender: Any) {
    selectedCategoryIDs.removeAll()
        selectedBrandIDs.removeAll()
        prepareFilters()
        onFilterApplied?([], [])
        dismiss(animated: true)
  }
  
  func setupUI() {
    headerView.layer.cornerRadius = 32
    headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    headerView.clipsToBounds = true
  }
  
  // MARK: - Load API Data
//  func loadFilterData() {
//    let group = DispatchGroup()
//    
//    group.enter()
//    viewModel.getCategoriesListApi {
//      group.leave()
//    }
//    
//    group.enter()
//    viewModel.getBrandListApi {
//      group.leave()
//    }
//    
//    group.notify(queue: .main) {
//      self.prepareFilters()
//    }
//  }
  
  // MARK: - Prepare Filter List
  func prepareFilters() {
    
    // CATEGORY - Single selection
    let categoryOptions = viewModel.categoriesList.map {
      FilterOption(
        id: "\($0.id ?? 0)",
        title: $0.name ?? "",
        isSelected: selectedCategoryIDs.contains("\($0.id ?? 0)")
      )
    }
    
    // BRAND - Multiple selection
    let brandOptions = viewModel.brandsList.map {
      FilterOption(
        id: "\($0.id ?? 0)",
        title: $0.nameEnglish ?? "",
        isSelected: selectedBrandIDs.contains("\($0.id ?? 0)")
      )
    }
    
    filtersOptions = [
      FilterSection(header: "Filter by Category", options: categoryOptions),
      FilterSection(header: "Filter by Brand", options: brandOptions)
    ]
    
    filterTableView.reloadData()
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
    
    headerView.layer.cornerRadius = 32
    headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    headerView.clipsToBounds = true
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
    
    // CATEGORY SECTION (single selection)
    if indexPath.section == 0 {
      
      for i in 0..<filtersOptions[0].options.count {
        filtersOptions[0].options[i].isSelected = (i == indexPath.row)
      }
    }
    
    // BRAND SECTION (multi selection)
    else if indexPath.section == 1 {
      
      filtersOptions[1].options[indexPath.row].isSelected.toggle()
    }
    
    tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
  }
  
  
}



