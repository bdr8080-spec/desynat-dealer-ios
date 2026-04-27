//
//  BannerManagemntVC.swift
//  DesynatDealer
//
//  Created by fluper on 18/12/25.
//

protocol BannerFilterDelegate: AnyObject {
    func didApplyFilter(_ filter: BannerFilterModel)
    func didClearFilter()
}

import UIKit

class BannerManagemntVC: UIViewController {

    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var bannerTableView: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    
    lazy private var viewModel = BannerManagementVM(hostVC: self)
    private var searchWorkItem: DispatchWorkItem?
    var bannerData: [BannerModel] = []
    var hasActionPermission: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        txtSearch.delegate = self
        plusButton.isHidden  = !hasActionPermission
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.getAllBanners()
  }
    
    func registerXib() {
        bannerTableView.delegate = self
        bannerTableView.dataSource = self
        bannerTableView.register(UINib(nibName: "BannerMgmtTableCell", bundle: nil), forCellReuseIdentifier: "BannerMgmtTableCell")
        bannerTableView.showsVerticalScrollIndicator = false
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnFilter(_ sender: Any) {
        let vc = BannerFilterVC.instantiate(fromAppStoryboard: .BannerManagement)
        vc.delegate = self
        vc.appliedFilter = viewModel.appliedFilter
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func btnAddBanner(_ sender: Any) {
        let vc = AddNewBannerVC.instantiate(fromAppStoryboard: .BannerManagement)
        vc.onBannerAdded = {
            self.viewModel.getAllBanners()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension BannerManagemntVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bannerData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BannerMgmtTableCell", for: indexPath) as! BannerMgmtTableCell
        let banner = bannerData[indexPath.row]
        cell.configure(with: banner, hasActionPermission: hasActionPermission)
        cell.onPayTap = {
            let vc = PaymentMethodVC.instantiate(fromAppStoryboard: .Main)
            //vc.transactionIds = banner.orderID ?? ""
            vc.paymentFrom = .banner
            vc.transactionIds = banner.orderID ?? ""
            vc.payAmount = Double(banner.price ?? "") ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BannerDetailVC.instantiate(fromAppStoryboard: .BannerManagement)
        vc.banners = bannerData[indexPath.row]
        vc.hasActionPermission  = hasActionPermission
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension BannerManagemntVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        searchWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchText = currentText
            viewModel.getAllBanners()
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        return true
    }
}

extension BannerManagemntVC: BannerFilterDelegate {
    func didApplyFilter(_ filter: BannerFilterModel) {
        viewModel.appliedFilter = filter
        viewModel.getAllBanners()
    }

    func didClearFilter() {
        viewModel.appliedFilter = nil
        viewModel.getAllBanners()
    }
}
