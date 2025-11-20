//
//  AddNewProductViewController.swift
//  DesynatDealer
//
//  Created by fluper on 20/11/25.
//

import UIKit

class AddNewProductViewController: UIViewController {
  
  @IBOutlet weak var varaintTableViewHeightConstriant: NSLayoutConstraint!
  @IBOutlet weak var addSpecificationButtonOutlet: UIButton!
  @IBOutlet weak var specificationTableViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var specificationTableView: UITableView! {
    didSet {
      specificationTableView.registerCellFromNib(cellID: "AddSpecificationTableViewCell")
    }
  }
  
  @IBOutlet weak var variantTableView: UITableView! {
    didSet {
      variantTableView.registerCellFromNib(cellID: "AddVariantTableViewCell")
    }
  }
  
  var comingReason: ComingReasonAtAddToProduct = .forAddingProduct
  var specifications: [String] = [""]
  var variantArray: [String] = [""]
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    updateSpecificationTableHeight()
    updateVariantTableHeight()
  }
  
  @IBAction func backDidTapped(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func addSpecificationsDidTapped(_ sender: Any) {
    specifications.append("")
    specificationTableView.reloadData()
    specificationTableView.layoutIfNeeded()
    specificationTableViewHeightConstraint.constant = self.specificationTableView.contentSize.height + 40
    updateUIVisibility()
  }
  
  @IBAction func addVariantDidTapped(_ sender: Any) {
    variantArray.append("")
    variantTableView.reloadData()
    updateVariantTableHeight()
  }
  
  func updateSpecificationTableHeight() {
    specificationTableView.layoutIfNeeded()
    self.specificationTableViewHeightConstraint.constant = self.specificationTableView.contentSize.height + 20
  }
    func updateVariantTableHeight() {
    variantTableView.layoutIfNeeded()
    self.varaintTableViewHeightConstriant.constant = self.variantTableView.contentSize.height
  }
  
  
  // MARK: - Helper: Add New Specification
  func updateUIVisibility() {
    if specifications.count == 1 {
      addSpecificationButtonOutlet.isHidden = false
    } else {
      addSpecificationButtonOutlet.isHidden = true
    }
  }
  
}

extension AddNewProductViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch tableView {
    case specificationTableView:
      return specifications.count
    case variantTableView:
      return variantArray.count
    default:
       return 0
    }
    
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch tableView {
    case specificationTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "AddSpecificationTableViewCell", for: indexPath) as! AddSpecificationTableViewCell
      cell.delegate = self
      if specifications.count == 1 {
        cell.addRemoveStackView.isHidden = true
      } else {
        cell.addRemoveStackView.isHidden = false
      }
      let isLastCell = indexPath.row == specifications.count - 1
      cell.addNewView.isHidden = !isLastCell
      return cell
    case variantTableView:
      let cell = tableView.dequeueReusableCell(withIdentifier: "AddVariantTableViewCell", for: indexPath) as! AddVariantTableViewCell
      cell.delegate = self
      
      if indexPath.row == 0 {
        cell.priceView.backgroundColor = UIColor(named: "#FFF7EA")
        cell.headerView.isHidden = true
      } else {
        cell.headerView.isHidden = false
        cell.titleLabel.text = "Variant \(indexPath.row)"
        cell.priceView.backgroundColor = UIColor.white
      }
      return cell
    default:
       return UITableViewCell()
    }
    
  }
  
}

extension AddNewProductViewController: AddSpecificationCellDelegate, AddVariantCellDelegate {
  
  func addImageTapped(from cell: AddVariantTableViewCell, at index: Int) {
          ImagePickerHelper.shared.showPickerController { [weak self] image, imageName in
              guard let self = self, let image = image else { return }
              
              // Upload the image
              WebService.sharedInstance.uploadImage(withParams: image) { imageURL in
                  // Find indexPath for the cell
                  guard let indexPath = self.variantTableView.indexPath(for: cell) else { return }
                  
                  // Update cell's images array
                  cell.images[index] = image
                  
                  // If tapped the last cell (placeholder), add a new placeholder
                  if index == cell.images.count - 1 {
                      cell.images.append(nil)
                  }
                  
                  // Reload collection view
                  cell.imagesCollectionView.reloadData()
                  
                  // Scroll to show the newly added image
                  cell.scrollToLastItem()
                  
                  // Optional: store uploaded URL somewhere
                  // e.g., self.variantArray[indexPath.row] = imageURL.url ?? ""
              }
          }
      }
  
  func removeVariantTapped(from cell: AddVariantTableViewCell) {
    guard let indexPath = variantTableView.indexPath(for: cell) else { return }
    variantArray.remove(at: indexPath.row)
    variantTableView.reloadData()
    updateVariantTableHeight()
  }
  
  func addSpecificationTapped(from cell: AddSpecificationTableViewCell) {
    specifications.append("")
    specificationTableView.reloadData()
    updateSpecificationTableHeight()
  }
  
  func removeSpecificationTapped(from cell: AddSpecificationTableViewCell) {
    guard let indexPath = specificationTableView.indexPath(for: cell) else { return }
    specifications.remove(at: indexPath.row)
    specificationTableView.reloadData()
    updateSpecificationTableHeight()
    if specifications.count == 1 {
      addSpecificationButtonOutlet.isHidden = false
    }
  }
}

