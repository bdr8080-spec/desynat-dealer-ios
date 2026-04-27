//
//  DealListedViewController.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 22/01/26.
//

import UIKit
import AVFAudio
import Speech

class DealListedViewController: UIViewController {
    
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var listTableView: UITableView! {
        didSet {
            listTableView.registerCellFromNib(cellID: "ListedDealsTableViewCell")
        }
    }
    @IBOutlet weak var serachTF: UITextField!
    @IBOutlet weak var expiredButton: CustomButton!
    @IBOutlet weak var expiredLabel: UILabel!
    @IBOutlet weak var enrollLabel: UILabel!
    @IBOutlet weak var enrollButton: CustomButton!
    @IBOutlet weak var listedDealsLabel: UILabel!
    @IBOutlet weak var listedDealsButton: CustomButton!
    
    var tabType: DealsListedType = .listedDeals
    private lazy var viewModel = DealListedViewModel(hostVC: self)
    private var searchWorkItem: DispatchWorkItem?
    var hasActionPermission: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serachTF.delegate = self
        handleListedDealsAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.dealsListRequest(tab: tabType)
    }
    
    @IBAction func micDidTapped(_ sender: UIButton) {

        let vc = DealsListFilterViewController.instantiate(fromAppStoryboard: .OrderAndChat)

                // Load filter for current tab
                vc.selectedFilter = viewModel.currentFilter(for: tabType)

                vc.onApplyFilter = { [weak self] filter in
                    guard let self = self else { return }
                    self.viewModel.filtersByTab[self.tabType] = filter
                    self.viewModel.dealsListRequest(tab: self.tabType)
                }

                vc.onClearFilter = { [weak self] in
                    guard let self = self else { return }
                    self.viewModel.filtersByTab[self.tabType] = DealListFilterModel()
                    self.viewModel.dealsListRequest(tab: self.tabType)
                }

                navigationController?.present(vc, animated: false)
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func listedDidTapped(_ sender: Any) {
        handleListedDealsAction()
//        searchView.isHidden = true
        if tabType != .listedDeals {
                viewModel.filtersByTab[.listedDeals] = DealListFilterModel()
            }
        listTableView.reloadData()
        updateNoDataState()
    }
    
    @IBAction func enrolledDidTapped(_ sender: Any) {
        handleEnrolledAction()
//        searchView.isHidden = false
        if tabType != .enrolled {
                viewModel.filtersByTab[.listedDeals] = DealListFilterModel()
            }
        listTableView.reloadData()
        updateNoDataState()
    }
    
    @IBAction func expiredDidTapped(_ sender: Any) {
        handleExpiredAction()
//        searchView.isHidden = false
        if tabType != .expired {
                viewModel.filtersByTab[.listedDeals] = DealListFilterModel()
            }
        listTableView.reloadData()
        updateNoDataState()
    }
    
    func updateNoDataState() {
        let isEmpty: Bool
        switch tabType {
        case .listedDeals:
            isEmpty = viewModel.listedDeal?.isEmpty ?? true
        case .enrolled:
            isEmpty = viewModel.enrolledDeals?.isEmpty ?? true
        case .expired:
            isEmpty = viewModel.expiredDeal?.isEmpty ?? true
        }
        noDataFoundLabel.isHidden = !isEmpty
        listTableView.isHidden = isEmpty
    }
    
    private func handleListedDealsAction() {
        activateTab(
            button: listedDealsButton,
            label: listedDealsLabel,
            corners: [.layerMinXMinYCorner, .layerMinXMaxYCorner],
            viewType: .listedDeals
        )
    }
    
    private func handleEnrolledAction() {
        activateTab(
            button: enrollButton,
            label: enrollLabel,
            viewType: .enrolled
        )
    }
    
    private func handleExpiredAction() {
        activateTab(
            button: expiredButton,
            label: expiredLabel,
            corners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner],
            viewType: .expired
        )
    }
    
    private func resetTabs() {
        let buttons = [expiredButton, listedDealsButton, enrollButton]
        let labels = [expiredLabel, listedDealsLabel, enrollLabel]
        
        buttons.forEach {
            $0?.setImage(nil, for: .normal)
            $0?.layer.cornerRadius = 0
            $0?.clipsToBounds = false
        }
        
        labels.forEach {
            $0?.textColor = .black
        }
    }
    
    private func activateTab(
        button: UIButton,
        label: UILabel,
        corners: CACornerMask = [],
        viewType: DealsListedType
    ) {
        resetTabs()
        
        button.setImage(UIImage(named: "topTabbar"), for: .normal)
        button.layer.cornerRadius = corners.isEmpty ? 0 : 5
        button.layer.maskedCorners = corners
        button.clipsToBounds = !corners.isEmpty
        
        label.textColor = .white
        tabType = viewType
    }

}

extension DealListedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tabType {
        case .listedDeals:
            return viewModel.listedDeal?.count ?? 0
        case .enrolled:
            return viewModel.enrolledDeals?.count ?? 0
        case .expired:
            return viewModel.expiredDeal?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListedDealsTableViewCell", for: indexPath) as! ListedDealsTableViewCell
        switch tabType {
        case .listedDeals:
            cell.configData(type: tabType, data: viewModel.listedDeal?[indexPath.row])
        case .enrolled:
            cell.configData(type: tabType, data: viewModel.enrolledDeals?[indexPath.row])
        case .expired:
            cell.configData(type: tabType, data: viewModel.expiredDeal?[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = DealsDetailsViewController.instantiate(fromAppStoryboard: .OrderAndChat)
        nextVC.tabType = tabType
        nextVC.hasActionPermission = hasActionPermission
        switch tabType {
        case .listedDeals:
            nextVC.dealID = viewModel.listedDeal?[indexPath.row].id ?? 0
        case .enrolled:
            nextVC.dealID = viewModel.enrolledDeals?[indexPath.row].id ?? 0
        case .expired:
            nextVC.dealID = viewModel.expiredDeal?[indexPath.row].id ?? 0
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension DealListedViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            viewModel.dealsListRequest(tab: tabType)
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}


enum DealsListedType: Int {
    case listedDeals = 1
    case enrolled = 2
    case expired = 3
}
