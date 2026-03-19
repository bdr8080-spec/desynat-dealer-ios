//
//  MyPlanDetailsViewController.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 18/03/26.
//

import UIKit

class MyPlanDetailsViewController: UIViewController {

    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblPlan: UILabel!
    @IBOutlet weak var lblPurchasedOn: UILabel!
    @IBOutlet weak var lblExpiredOn: UILabel!
    @IBOutlet weak var lblTotalAmout: UILabel!
    @IBOutlet weak var lblTransactionId: UILabel!
    
    @IBOutlet weak var titleView: CustomView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topSet()
        // Do any additional setup after loading the view.
    }
    

    
   
    // MARK: - Navigation

     @IBAction func Backbtn(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
     }
    
    func topSet(){
        titleView.layer.cornerRadius = 12
        titleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        titleView.clipsToBounds = true
    }

}
