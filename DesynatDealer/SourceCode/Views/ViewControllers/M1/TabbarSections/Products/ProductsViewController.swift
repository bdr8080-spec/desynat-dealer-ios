//
//  ProductsViewController.swift
//  DesynatDealer
//
//  Created by Rakhi Kumari on 24/10/25.
//

import UIKit

class ProductsViewController: UIViewController {

  
  @IBOutlet weak var allTitleLabel: UILabel!
  @IBOutlet weak var allBottomLabel: UILabel!
  @IBOutlet weak var activeTitleLabel: UILabel!
  @IBOutlet weak var activeBottomLabel: UILabel!
  @IBOutlet weak var inactiveLabel: UILabel!
  @IBOutlet weak var inactiveBottomLabel: UILabel!
  @IBOutlet weak var productTableView: UITableView! {
    didSet {
      productTableView.registerCellFromNib(cellID: "ProductManagementTableViewCell")
    }
  }
  
  override func viewDidLoad() {
        super.viewDidLoad()

    }
  
  @IBAction func allDidTapped(_ sender: Any) {
    allTitleLabel.textColor = UIColor.darkBrown
    allBottomLabel.backgroundColor = UIColor.darkBrown
    activeTitleLabel.textColor = UIColor(named: "#B3B3B3")
    activeBottomLabel.backgroundColor = UIColor(named: "#B3B3B3")
    inactiveLabel.textColor = UIColor(named: "#B3B3B3")
    inactiveBottomLabel.backgroundColor = UIColor(named: "#B3B3B3")
  }
  
  @IBAction func activeDidTapped(_ sender: Any) {
    allTitleLabel.textColor = UIColor(named: "#B3B3B3")
    allBottomLabel.backgroundColor = UIColor(named: "#B3B3B3")
    activeTitleLabel.textColor = UIColor.darkBrown
    activeBottomLabel.backgroundColor = UIColor.darkBrown
    inactiveLabel.textColor = UIColor(named: "#B3B3B3")
    inactiveBottomLabel.backgroundColor = UIColor(named: "#B3B3B3")
  }
  
  @IBAction func InactiveDidTapped(_ sender: Any) {
    allTitleLabel.textColor = UIColor(named: "#B3B3B3")
    allBottomLabel.backgroundColor = UIColor(named: "#B3B3B3")
    activeTitleLabel.textColor = UIColor(named: "#B3B3B3")
    activeBottomLabel.backgroundColor = UIColor(named: "#B3B3B3")
    inactiveLabel.textColor = UIColor.darkBrown
    inactiveBottomLabel.backgroundColor = UIColor.darkBrown
  }
  
  
  @IBAction func addDidTapped(_ sender: Any) {
    let nextVC = AddNewProductViewController.instantiate(fromAppStoryboard: .Product)
    nextVC.comingReason = .forAddingProduct
    self.navigationController?.pushViewController(nextVC, animated: true)
  }
  
  @IBAction func filterDidTapped(_ sender: Any) {
    let nextVC = ProductManagementFilterViewController.instantiate(fromAppStoryboard: .Product)
    self.navigationController?.present(nextVC, animated: true)
  }
  
}
extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ProductManagementTableViewCell", for: indexPath) as! ProductManagementTableViewCell
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let nextVC = ProductDetailViewController.instantiate(fromAppStoryboard: .Product)
    self.navigationController?.pushViewController(nextVC, animated: true)
  }
  
  
}
