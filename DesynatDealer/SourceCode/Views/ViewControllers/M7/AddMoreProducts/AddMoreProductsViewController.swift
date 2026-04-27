//
//  AddMoreProductsViewController.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 23/01/26.
//

import UIKit

class AddMoreProductsViewController: UIViewController {
    
    @IBOutlet weak var addToDealsButton: CustomButton!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var productsCollectionView: UICollectionView! {
        didSet {
            productsCollectionView.registerCellFromNib(cellID: "ProductsCollectionViewCell")
        }
    }
    var dealDetails: [ProductsList]?
    var dealID: Int? = 0
    private var searchWorkItem: DispatchWorkItem?
    var selectedProductIDs: Set<Int> = []
    private lazy var viewModel = AddMoreProductsViewModel(hostVC: self)
    var hasActionPermission: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTF.delegate = self
        updateAddToDealsButtonState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.dealDetailsRequest()
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addToDealsDidTapped(_ sender: Any) {
        guard !selectedProductIDs.isEmpty else {
            self.showAlert(msg: "Please select at least one product")
            return
        }
        let selectedIDsArray = Array(selectedProductIDs)
        viewModel.addProductsRequest(ids: selectedIDsArray)
    }
    
    func updateAddToDealsButtonState() {
        let isEnabled = !selectedProductIDs.isEmpty
        addToDealsButton.isEnabled = isEnabled
        addToDealsButton.alpha = isEnabled ? 1.0 : 0.5
    }

    
}

extension AddMoreProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dealDetails?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath) as! ProductsCollectionViewCell
        cell.configData(type: .listedDeals, hasActionPermission: hasActionPermission)
        cell.configDealData(data: dealDetails?[indexPath.row])
        let productID = dealDetails?[indexPath.row].id ?? 0

        if selectedProductIDs.contains(productID) {
            cell.checkboxButton.setImage(UIImage(named: "filledCheckbox"), for: .normal)
        } else {
            cell.checkboxButton.setImage(UIImage(named: "checkBox"), for: .normal)
        }

        cell.checkboxButtonTapped = { [weak self] in
            guard let self = self else { return }
            guard let productID = self.dealDetails?[indexPath.row].id else { return }

            if self.selectedProductIDs.contains(productID) {
                self.selectedProductIDs.remove(productID)
            } else {
                self.selectedProductIDs.insert(productID)
            }

            self.updateAddToDealsButtonState()

            // Reload only this cell
            self.productsCollectionView.reloadItems(at: [indexPath])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 10
        let totalSpacing = spacing * 2
        let width = (collectionView.frame.width - totalSpacing) / 2
        return CGSize(width: width, height: 245)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

extension AddMoreProductsViewController: UITextFieldDelegate {
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            searchWorkItem?.cancel()
            let workItem = DispatchWorkItem { [weak self] in
                guard let self = self else { return }
                self.viewModel.searchText = currentText
                viewModel.dealDetailsRequest()
            }
            searchWorkItem = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
            return true
        }
}

