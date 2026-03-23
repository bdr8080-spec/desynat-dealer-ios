//
//  MySubsciptionPlanViewController.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 17/03/26.
//

import UIKit

class MySubsciptionPlanViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var subdcribtionPlanBtn: CustomButton!
    @IBOutlet weak var myPlanBtn: CustomButton!
    @IBOutlet weak var lblsubsciption: UILabel!
    @IBOutlet weak var lblMyPlan: UILabel!
    @IBOutlet weak var subsciptionPlanCollectionView: UICollectionView!{
        didSet{
            subsciptionPlanCollectionView.dataSource = self
            subsciptionPlanCollectionView.delegate = self
            subsciptionPlanCollectionView.registerCellFromNib(cellID: "SubscriptionCollectionCell")
        }
    }
    @IBOutlet weak var myPlanTableView: UITableView! {
        didSet{
            myPlanTableView.dataSource = self
            myPlanTableView.delegate  = self
            myPlanTableView.registerCellFromNib(cellID: "myPlanTableViewCell")
        }
    }
    // MARK: - Variable
    private lazy var viewModel =  MySubscriptionPlanViewModel(hostVc: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subsciptionPlanCollectionView.isHidden = false
        myPlanTableView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getPlans()
        viewModel.resetAndFetchStories()
    }
    
    @IBAction func Backbtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func subscribtionPlansbtn(_ sender: Any) {
        myPlanBtn.setImage(UIImage(named: ""), for: .normal)
        lblMyPlan.textColor = UIColor.black
        
        subdcribtionPlanBtn.setImage(UIImage(named: "btnGradient"), for: .normal)
        lblsubsciption.textColor = UIColor.white
        // Show CollectionView
        subsciptionPlanCollectionView.isHidden = false
        myPlanTableView.isHidden = true
    }
    
    @IBAction func myPlanBtn(_ sender: Any) {
        subdcribtionPlanBtn.setImage(UIImage(named: ""), for: .normal)
        lblsubsciption.textColor = UIColor.black
        
        myPlanBtn.setImage(UIImage(named: "btnGradient"), for: .normal)
        lblMyPlan.textColor = UIColor.white
        
        // Show TableView
        subsciptionPlanCollectionView.isHidden = true
        myPlanTableView.isHidden = false
    }
    
}
extension MySubsciptionPlanViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
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
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
}

extension MySubsciptionPlanViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.myPurchasedPlansList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myPlanTableViewCell", for: indexPath) as! myPlanTableViewCell
        let data = viewModel.myPurchasedPlansList[indexPath.row]
        cell.configData(data: data)
//        cell.onRenewTapped = {[weak self] in
//            viewModel.
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MyPlanDetailsViewController.instantiate(fromAppStoryboard: .NotificationAndSubscribtion)
        vc.planDetails = viewModel.myPurchasedPlansList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MySubsciptionPlanViewController: SubscriptionCollectionCellDelegate {
    
    func didTapContinue(for plan: GetPlansSubscriptionModel) {
        // Call your purchase plan API here
        print("User tapped continue for plan ID: \(plan.id ?? 0)")
        viewModel.payAmt = Int(plan.price ?? 0)
        if let duration = plan.duration, let type = plan.durationType {
            viewModel.durationOfPlan = "for \(duration) \(type == 1 ? "Month" : "Years")"
        } else {
            viewModel.durationOfPlan = "N/A"
        }
        viewModel.purchasePlan(planID: plan.id ?? 0)
    }
}

extension MySubsciptionPlanViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Don't paginate if content is not scrollable
        guard scrollView.contentSize.height > scrollView.frame.height else {
            return
        }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight - 100 {
            viewModel.getMyPlansListRequest()
        }
    }
    
}
