//
//  ViewRequestViewController.swift
//  DesynatDealer
//
//  Created by fluper on 06/01/26.
//

import UIKit

class ViewRequestViewController: UIViewController {

  @IBOutlet weak var requestIDLabel: UILabel!
  @IBOutlet weak var customizationDetailsLabel: UILabel!
  @IBOutlet weak var adressLabel: UILabel!
  @IBOutlet weak var totalQuantityLabel: UILabel!
  @IBOutlet weak var productTableView: UITableView! {
    didSet {
      productTableView.registerCellFromNib(cellID: "OrderForChatTableViewCell")
    }
  }
  private lazy var viewModel = ViewRequestViewModel(hostVC: self)
  var quotationData: Record?
  
    override func viewDidLoad() {
        super.viewDidLoad()
      setupBackgroundTap()
      bindData()
    }
    
  private func setupBackgroundTap() {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
      tapGesture.delegate = self
      tapGesture.cancelsTouchesInView = false
      view.addGestureRecognizer(tapGesture)
  }
  
  func bindData() {
    requestIDLabel.text = "Request Id #\(quotationData?.id ?? 0)"
    totalQuantityLabel.text = quotationData?.quantity
    productTableView.reloadData()
    adressLabel.text = buildFullAddress(from: quotationData?.deliveryDetails)
    customizationDetailsLabel.text = quotationData?.customDetails
  }

  func buildFullAddress(from details: DeliveryDetails?) -> String {
      guard let details = details else { return "" }
      
      var addressParts: [String] = []
      
      // Base address (if API already provides)
      if let baseAddress = details.address?.trimmingCharacters(in: .whitespacesAndNewlines),
         !baseAddress.isEmpty {
          addressParts.append(baseAddress)
      }
      
      let additionalParts = [
          details.houseNo,
          details.streetNo,
          details.landmark,
          details.city,
          details.state,
          details.countryName,
          details.postalCode,
      ]
      
      for part in additionalParts {
          guard let value = part?.trimmingCharacters(in: .whitespacesAndNewlines),
                !value.isEmpty else { continue }
          
          if !addressParts.joined(separator: " ").localizedCaseInsensitiveContains(value) {
              addressParts.append(value)
          }
      }
      
      return addressParts.joined(separator: ", ")
  }
  
}

extension ViewRequestViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
      return 1
   
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "OrderForChatTableViewCell", for: indexPath) as! OrderForChatTableViewCell
    let data = quotationData?.productVariation
    cell.configData(data: data)
      return cell
  }
  
}

extension ViewRequestViewController: UIGestureRecognizerDelegate {

    @objc private func backgroundTapped() {
        dismiss(animated: true)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: productTableView) == true {
            return false
        }
        return true
    }
}
