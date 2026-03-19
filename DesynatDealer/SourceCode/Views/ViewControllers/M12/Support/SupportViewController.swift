//
//  SupportViewController.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 19/03/26.
//

import UIKit

class SupportViewController: UIViewController {
    
    // MARK: - IBOultet
    @IBOutlet weak var contactBtn: CustomButton!
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var ticketmanagementbtn: CustomButton!
    @IBOutlet weak var ticketmanagementLbl: UILabel!
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var ticketManagementTableView: UITableView!{
        didSet{
            ticketManagementTableView.delegate = self
            ticketManagementTableView.dataSource = self
            ticketManagementTableView.registerCellFromNib(cellID: "TicketManagementTableViewCell")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ticketManagementTableView.isHidden = true
        contactView.isHidden = false
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    
    @IBAction func backbtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func contactBtn(_ sender: Any) {
        ticketmanagementbtn.setImage(UIImage(named: ""), for: .normal)
        ticketmanagementLbl.textColor = UIColor.black
        contactBtn.setImage(UIImage(named: "btnGradient"), for: .normal)
        contactLbl.textColor = UIColor.white
        ticketManagementTableView.isHidden = true
        contactView.isHidden = false
        
    }
    
    @IBAction func raiseTicketBtn(_ sender: Any) {
        let vc = RaiseTicketViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        self.present(vc, animated: true)
    }
    
    @IBAction func ticketManagementBtn(_ sender: Any) {
        contactBtn.setImage(UIImage(named: ""), for: .normal)
        contactLbl.textColor = UIColor.black
        
        ticketmanagementbtn.setImage(UIImage(named: "btnGradient"), for: .normal)
        ticketmanagementLbl.textColor = UIColor.white
        ticketManagementTableView.isHidden = false
        contactView.isHidden = true
    }
}
extension SupportViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TicketManagementTableViewCell", for: indexPath) as! TicketManagementTableViewCell
        return cell
    }
    
    
}
