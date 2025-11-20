//
//  AddSpecificationTableViewCell.swift
//  DesynatDealer
//
//  Created by fluper on 20/11/25.
//

import UIKit

class AddSpecificationTableViewCell: UITableViewCell {
  
  @IBOutlet weak var addNewView: UIView!
  @IBOutlet weak var removeButton: UIButton!
  @IBOutlet weak var addRemoveStackView: UIView!
  
  weak var delegate: AddSpecificationCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  @IBAction func addTapped(_ sender: Any) {
    delegate?.addSpecificationTapped(from: self)
  }
  
  @IBAction func removeTapped(_ sender: Any) {
    delegate?.removeSpecificationTapped(from: self)
  }
  
}

protocol AddSpecificationCellDelegate: AnyObject {
  func addSpecificationTapped(from cell: AddSpecificationTableViewCell)
  func removeSpecificationTapped(from cell: AddSpecificationTableViewCell)
}
