//
//  ViewRequestViewController.swift
//  DesynatDealer
//
//  Created by fluper on 06/01/26.
//

import UIKit

class ViewRequestViewController: UIViewController {

  @IBOutlet weak var productTableView: UITableView! {
    didSet {
      productTableView.registerCellFromNib(cellID: "OrderForChatTableViewCell")
    }
  }
  private lazy var viewModel = ViewRequestViewModel(hostVC: self)
  
    override func viewDidLoad() {
        super.viewDidLoad()
      setupBackgroundTap()
    }
    
  private func setupBackgroundTap() {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
      tapGesture.delegate = self
      tapGesture.cancelsTouchesInView = false
      view.addGestureRecognizer(tapGesture)
  }


}

extension ViewRequestViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
      return 1
   
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "OrderForChatTableViewCell", for: indexPath) as! OrderForChatTableViewCell
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
