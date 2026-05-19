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
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var serachTF: UITextField!
    @IBOutlet weak var supportEmailLabe: UILabel!
    @IBOutlet weak var supportPhoneLabel: UILabel!
    @IBOutlet weak var paginationBottomView: UIView!
    @IBOutlet weak var plusButtonview: UIView!
    
    private lazy var viewModel = SupportViewModel(hostVC: self)
    private var searchWorkItem: DispatchWorkItem?
    var hasActionPermission: Bool = false
    
    // MARK: - View's LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        serachTF.delegate = self
        ticketManagementTableView.isHidden = true
        contactView.isHidden = false
        paginationBottomView.isHidden = true
        noDataFoundLabel.isHidden = true
        plusButtonview.isHidden = !hasActionPermission
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        paginationBottomView.isHidden = true
        noDataFoundLabel.isHidden = true
    }
    
    @IBAction func raiseTicketBtn(_ sender: Any) {
        let vc = RaiseTicketViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        vc.isTicketRaised = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async { [self] in
                let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
                vc.comingReason = .ticketRaised
                vc.callBackDismiss = {
                    self.viewModel.currentPage = 1
                    self.viewModel.getAllTicketListRequest()
                }
                self.navigationController?.present(vc, animated: true)
            }
        }
        self.present(vc, animated: true)
    }
    
    @IBAction func ticketManagementBtn(_ sender: Any) {
        contactBtn.setImage(UIImage(named: ""), for: .normal)
        contactLbl.textColor = UIColor.black
        ticketmanagementbtn.setImage(UIImage(named: "btnGradient"), for: .normal)
        ticketmanagementLbl.textColor = UIColor.white
        ticketManagementTableView.isHidden = false
        contactView.isHidden = true
        paginationBottomView.isHidden = false
        viewModel.currentPage = 1
        viewModel.getAllTicketListRequest()
    }
    
    @IBAction func nextButtonDidTapped(_ sender: Any) {
        viewModel.goToNextPage()
    }
    
    @IBAction func previousButtonDidTapped(_ sender: Any) {
        viewModel.goToPreviousPage()
    }
    
    @IBAction func micDidTapped(_ sender: Any) {
        let nextVC = VoiceSearchViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        nextVC.onSearchedCompletionTxt = { [weak self] searchText in
            guard let self else { return }
            serachTF.text = searchText
            viewModel.searchText = searchText
            viewModel.currentPage = 1
            viewModel.getAllTicketListRequest()
        }
        self.navigationController?.present(nextVC, animated: true)
    }
    
    @IBAction func chatWithTeamDidTapped(_ sender: Any) {
        let nextVC = SupportChatViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //MARK: Function's declaration
    func updatePaginationButtonImages() {
        // Previous Button
        if viewModel.currentPage == 1 {
            previousButton.setImage(UIImage(named: "previousLeft"), for: .normal)
            previousButton.isUserInteractionEnabled = false
        } else {
            previousButton.setImage(UIImage(named: "darkpreviousimage"), for: .normal)
            previousButton.isUserInteractionEnabled = true
        }
        
        // Next Button
        if viewModel.currentPage >= viewModel.totalPages {
            nextButton.setImage(UIImage(named: "lightnextimage"), for: .normal)
            nextButton.isUserInteractionEnabled = false
        } else {
            nextButton.setImage(UIImage(named: "nextRight"), for: .normal)
            nextButton.isUserInteractionEnabled = true
        }
    }
}

extension SupportViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.ticketsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TicketManagementTableViewCell", for: indexPath) as! TicketManagementTableViewCell
        cell.configData(data: viewModel.ticketsList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TicketDetailViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        vc.ticketDetails = viewModel.ticketsList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK: UITextFieldDelegate Methods
extension SupportViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        
        // Cancel previous search work item
        searchWorkItem?.cancel()
        
        // Create new one
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            self.viewModel.currentPage = 1
            viewModel.getAllTicketListRequest()
        }
        
        // Store and execute after delay
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        
        return true
    }
}
