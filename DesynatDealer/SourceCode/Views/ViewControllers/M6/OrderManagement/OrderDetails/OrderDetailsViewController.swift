//
//  OrderDetailsViewController.swift
//  DesynatDealer
//
//  Created by fluper on 05/01/26.
//

import UIKit

class OrderDetailsViewController: UIViewController {
  
  @IBOutlet weak var productTableView: UITableView! {
    didSet {
      productTableView.registerCellFromNib(cellID: "ProductListTableViewCell")
    }
  }
  
  private lazy var viewModel = OrderDetailsViewModel(hostVC: self)
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
  }
  
  
}

extension OrderDetailsViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListTableViewCell", for: indexPath) as! ProductListTableViewCell
    return cell
  }
  
}
