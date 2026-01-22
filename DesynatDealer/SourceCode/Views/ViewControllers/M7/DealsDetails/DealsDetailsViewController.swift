//
//  DealsDetailsViewController.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 22/01/26.
//

import UIKit

class DealsDetailsViewController: UIViewController {

    @IBOutlet weak var totalRevenueView: CustomView!
    @IBOutlet weak var addMoreProdutsView: UIView!
    @IBOutlet weak var addToDealsView: UIView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var heightOfProductCollectionViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var productsCollectionView: UICollectionView! {
        didSet {
            productsCollectionView.registerCellFromNib(cellID: "ProductsCollectionViewCell")
        }
    }
    
    var tabType: DealsListedType = .listedDeals
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
//        productsCollectionView.reloadData()
//        updateCollectionsHeight()
        searchTF.delegate = self
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addMoreDidTapped(_ sender: Any) {
        
    }
    
    @IBAction func addToDealsDidTapped(_ sender: Any) {
        let vc = RegisterationSuccessViewController.instantiate(fromAppStoryboard: .Main)
        vc.comingReason = .dealAdded
        vc.callBackDismiss = {
            
        }
        self.navigationController?.present(vc, animated: true)
    }
    
    func updateCollectionsHeight() {
        heightOfProductCollectionViewConstraint.constant = productsCollectionView.contentSize.height
    }
    
    func initialSetup() {
        addToDealsView.isHidden = true
        addMoreProdutsView.isHidden = true
        totalRevenueView.isHidden = true
        switch tabType {
        case .listedDeals:
            addToDealsView.isHidden = false
        case .enrolled:
            addMoreProdutsView.isHidden = false
        case .expired:
            totalRevenueView.isHidden = false
        }
    }

}

extension DealsDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath) as! ProductsCollectionViewCell
        cell.configData(type: tabType)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 10
        let totalSpacing = spacing * 2
        let width = (collectionView.frame.width - totalSpacing) / 2
        switch tabType {
        case .listedDeals:
            return CGSize(width: width, height: 250)
        default:
            return CGSize(width: width, height: 270)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

extension DealsDetailsViewController: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
//        searchWorkItem?.cancel()
//        let workItem = DispatchWorkItem { [weak self] in
//            guard let self = self else { return }
//            self.viewModel.searchText = currentText
//            viewModel.getStoresListApi()
//        }
//        searchWorkItem = workItem
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
//        return true
//    }
}
