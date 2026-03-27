//
//  SubscriptionVC.swift
//  DesynatDealer
//
//  Created by fluper on 07/11/25.
//

import UIKit

class SubscriptionVC: UIViewController {

    @IBOutlet weak var subscriptionCollView: CollViewAdjustedHeight!
    
    var userId: String? = ""
    private lazy var viewModel = SubscriptionPlaneViewModel(hostVC: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        viewModel.getPlans()
    }
    
    func registerXib() {
        subscriptionCollView.delegate = self
        subscriptionCollView.dataSource = self
        subscriptionCollView.register(UINib(nibName: "SubscriptionCollectionCell", bundle: nil), forCellWithReuseIdentifier: "SubscriptionCollectionCell")
    }
    

    @IBAction func btnSkip(_ sender: Any) {
        kSharedSceneDelegate.navigateToDealerHomeVc()
    }
  
}

extension SubscriptionVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.plansList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubscriptionCollectionCell", for: indexPath) as! SubscriptionCollectionCell
        let data = viewModel.plansList?[indexPath.row]
        cell.configData(data: data)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 40, height: collectionView.frame.size.height)
    }
    
}

extension SubscriptionVC: SubscriptionCollectionCellDelegate {
    func didTapContinue(for plan: GetPlansSubscriptionModel) {
        // Call your purchase plan API here
        print("User tapped continue for plan ID: \(plan.id ?? 0)")
        viewModel.payAmt = plan.price ?? 0
        if let duration = plan.duration, let type = plan.durationType {
            viewModel.durationOfPlan = "for \(duration) \(type == 1 ? "Month" : "Years")"
        } else {
            viewModel.durationOfPlan = "N/A"
        }
        viewModel.purchasePlan(planID: plan.id ?? 0)
    }
}
