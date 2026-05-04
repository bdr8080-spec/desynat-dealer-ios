//
//  TabBarVC.swift
//  Altair
//
//  Created by Hari on 25/07/25.
//

import UIKit

class TabBarVC: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var tabButtons: [UIButton]!
    @IBOutlet weak var orderCountLabel: UILabel!
    @IBOutlet weak var orderCountView: CustomView!
    
    var initialTabIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTabSelection(forTag: initialTabIndex)
        //        NotificationCenter.default.addObserver(self, selector: #selector(handleGetNewOrdersDetailsApi), name: NSNotification.Name("ItemRemovedFromBag"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getNewOrdersCountApi()
    }
    
    @IBAction func tabBarAction(_ sender: UIButton) {
        updateTabSelection(forTag: sender.tag)
    }
    
    private func updateTabSelection(forTag tag: Int) {
        loadSubview(forTag: tag)
        setUserButtonImages(selectedTag: tag)
    }
    
    private func setUserButtonImages(selectedTag: Int) {
        let unselectedImages = ["homeUnselected", "productsUnselected", "show", "ordersUnselected", "paymentsUnselected"]
        let selectedImages = ["homeSelected", "productsSelected", "show", "ordersSelected", "paymentsSelected"]
        
        let unselectedArImages = ["homeUnselectedAr", "productsUnselectedAr", "show", "ordersUnselectedAr", "paymentsUnselectedAr"]
        let selectedArImages = ["homeSelectedAr", "productsSelectedAr", "show", "ordersSelectedAr", "paymentsSelectedAr"]
        
//        for button in tabButtons {
//            let imageName = (button.tag == selectedTag) ? selectedImages[button.tag] : unselectedImages[button.tag]
//            button.setImage(UIImage(named: imageName), for: .normal)
//        }
        
        let isArabic = AppLanguageManager.shared.currentLanguage == .ar
                let currentUnselected = isArabic ? unselectedArImages : unselectedImages
                let currentSelected = isArabic ? selectedArImages : selectedImages
                
                for button in tabButtons {
                    let imageName = (button.tag == selectedTag) ? currentSelected[button.tag] : currentUnselected[button.tag]
                    button.setImage(UIImage(named: imageName), for: .normal)
                }
         
    }
    
    @objc func handleGetNewOrdersDetailsApi() {
        getNewOrdersCountApi()
    }
    
    func getNewOrdersCountApi(){
        WebService.sharedInstance.getOrdersCountDetails { [self] count in
            if count > 0 {
                self.orderCountView.isHidden = false
                self.orderCountLabel.text = "\(count)"
            } else {
                self.orderCountView.isHidden = true
            }
        }
    }
}

// MARK: - Load Child VC
extension TabBarVC {
    func loadSubview(forTag tag: Int) {
        guard let containerView = containerView else { return }
        
        // Remove existing child view
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
        
        // Load new child view controller
        let childVC: UIViewController
        switch tag {
        case 0:
            childVC = HomeViewController.instantiate(fromAppStoryboard: .Home)
        case 1:
            childVC = ProductsViewController.instantiate(fromAppStoryboard: .Home)
        case 2:
            childVC = ShowsViewController.instantiate(fromAppStoryboard: .Home)
        case 3:
            childVC = OrdersViewController.instantiate(fromAppStoryboard: .Home)
        case 4:
            childVC = PaymentsViewController.instantiate(fromAppStoryboard: .Home)
        default:
            return
        }
        
        addChild(childVC)
        childVC.view.frame = containerView.bounds
        containerView.addSubview(childVC.view)
        childVC.didMove(toParent: self)
    }
}
