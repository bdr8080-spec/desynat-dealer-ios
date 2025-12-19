//
//  BannerManagemntVC.swift
//  DesynatDealer
//
//  Created by fluper on 18/12/25.
//

import UIKit

class BannerManagemntVC: UIViewController {

    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var bannerTableView: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    
    lazy private var viewModel = BannerManagementVM(hostVC: self)
    private var searchWorkItem: DispatchWorkItem?
    var bannerData: [BannerModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        txtSearch.delegate = self
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
        cell.configure(with: banner)
        cell.onPayTap = {
            let vc = PaymentMethodVC.instantiate(fromAppStoryboard: .Main)
            vc.transactionIds = banner.orderID ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BannerDetailVC.instantiate(fromAppStoryboard: .BannerManagement)
        vc.banners = bannerData[indexPath.row]
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
