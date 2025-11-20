//
//  ProductDetailViewController.swift
//  DesynatUser
//
//  Created by fluper on 18/11/25.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    @IBOutlet weak var ratingTableViewHeightConstriant: NSLayoutConstraint!
    @IBOutlet weak var specificationTableViewHieghtConstraint: NSLayoutConstraint!
    @IBOutlet weak var imagesPageController: UIPageControl!
    @IBOutlet weak var addToBagView: CustomView!
    @IBOutlet weak var productImageCollectionView: UICollectionView! {
        didSet {
            productImageCollectionView.registerCellFromNib(cellID: "ProductDetailImageCollectionViewCell")
        }
    }
    
    @IBOutlet weak var colorsCollectionView: UICollectionView! {
        didSet {
            colorsCollectionView.registerCellFromNib(cellID: "ProductColoursCollectionViewCell")
        }
    }
    
    @IBOutlet weak var sizeCollectionView: UICollectionView! {
        didSet {
            sizeCollectionView.registerCellFromNib(cellID: "SizeVariantCollectionViewCell")
        }
    }
    
    @IBOutlet weak var specificationTableView: UITableView! {
        didSet {
            specificationTableView.registerCellFromNib(cellID: "ListTableViewCell")
        }
    }
    
    @IBOutlet weak var ratingsTableView: UITableView! {
        didSet {
            ratingsTableView.registerCellFromNib(cellID: "ProductRatingTableViewCell")
        }
    }
    
    private var selectedColourIndex = 0
    private var selectedSizeIndex = 0
    private var speifcationArray = ["Type 1- Feature", "Type 2- Feature", "Type 3- Feature"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        DispatchQueue.main.async {
            self.specificationTableViewHieghtConstraint.constant = self.specificationTableView.contentSize.height
            self.ratingTableViewHeightConstriant.constant = self.ratingsTableView.contentSize.height
        }
    }
    
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Page Control Tap Handling
    @IBAction func pageControlChanged(_ sender: UIPageControl) {
        let page = sender.currentPage
        let indexPath = IndexPath(item: page, section: 0)
        productImageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
  
  @IBAction func editDidTapped(_ sender: Any) {
    let nextVC = AddNewProductViewController.instantiate(fromAppStoryboard: .Product)
    nextVC.comingReason = .forEditProduct
    self.navigationController?.pushViewController(nextVC, animated: true)
  }
  
}

extension ProductDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case productImageCollectionView:
            return 5
        case colorsCollectionView:
            return 5
        case sizeCollectionView:
            return 5
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case productImageCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductDetailImageCollectionViewCell", for: indexPath) as! ProductDetailImageCollectionViewCell
            return cell
        case colorsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductColoursCollectionViewCell", for: indexPath) as! ProductColoursCollectionViewCell
            if selectedColourIndex == indexPath.row {
                cell.borderView.layer.borderColor = UIColor.darkBrown.cgColor
            } else {
                cell.borderView.layer.borderColor = UIColor.white.cgColor
            }
            return cell
        case sizeCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeVariantCollectionViewCell", for: indexPath) as! SizeVariantCollectionViewCell
            if selectedSizeIndex == indexPath.row {
                cell.mainView.layer.borderColor = UIColor.darkBrown.cgColor
            } else {
                cell.mainView.layer.borderColor = UIColor.lightGray.cgColor
            }
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case productImageCollectionView:
            print("")
        case colorsCollectionView:
            selectedColourIndex = indexPath.row
            colorsCollectionView.reloadData()
        case sizeCollectionView:
            selectedSizeIndex = indexPath.row
            sizeCollectionView.reloadData()
        default:
            print("")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case productImageCollectionView:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        case colorsCollectionView:
            return CGSize(width: 54, height: 45)
        case sizeCollectionView:
            return CGSize(width: 55, height: 42)
        default:
            return CGSize(width: 0, height: 0)
        }
        
    }
    
    // MARK: - Update Page Control on Scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == productImageCollectionView {
            let pageIndex = Int(round(scrollView.contentOffset.x / productImageCollectionView.frame.width))
            imagesPageController.currentPage = pageIndex
        }
    }
    
    
}

extension ProductDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case specificationTableView:
            return speifcationArray.count
        case ratingsTableView:
            return 2
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case specificationTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
            cell.titleLabel.text = "● \(speifcationArray[indexPath.row])"
            return cell
        case ratingsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductRatingTableViewCell", for: indexPath) as! ProductRatingTableViewCell
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewWillLayoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case specificationTableView:
            return 30
        default:
            return UITableView.automaticDimension
        }
    }
    
}
