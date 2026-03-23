//
//  SubscriptionCollectionCell.swift
//  DesynatDealer
//
//  Created by fluper on 06/11/25.
//

import UIKit

class SubscriptionCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var gradientImageView: UIImageView!
    @IBOutlet weak var mainContentView: CustomView!
    @IBOutlet weak var viewPlanHeading: UIView!
    @IBOutlet weak var viewAmount: CustomView!
    @IBOutlet weak var lblPlanHeading: CustomLabelFont!
    @IBOutlet weak var lblAmount: CustomLabelFont!
    @IBOutlet weak var lblDays: CustomLabelFont!
    @IBOutlet weak var dataTableView: UITableView!
    @IBOutlet weak var btnContinue: UIButton!
    var purchasePlan: (() -> Void)?
    
    private var heading: [String] = []
    private var data: [String] = []
    private var planData: GetPlansSubscriptionModel?
    weak var delegate: SubscriptionCollectionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        registerXib()
        
    }
    
    private func setupUI() {
        gradientImageView.layer.cornerRadius = 20
        gradientImageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        gradientImageView.layer.masksToBounds = true
        
        mainContentView.layer.shadowColor = UIColor.black.cgColor
        mainContentView.layer.shadowOpacity = 0.2
        mainContentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        mainContentView.layer.shadowRadius = 4
        mainContentView.layer.masksToBounds = false
        mainContentView.layer.cornerRadius = 20
        mainContentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        mainContentView.clipsToBounds = true
        
        viewAmount.layer.cornerRadius = 16
        viewAmount.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        viewAmount.layer.masksToBounds = true
        viewAmount.layer.shadowColor = UIColor.black.cgColor
        viewAmount.layer.shadowOpacity = 0.2
        viewAmount.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewAmount.layer.shadowRadius = 4
        viewAmount.layer.masksToBounds = false
    }
    
    func registerXib() {
        dataTableView.delegate = self
        dataTableView.dataSource = self
        dataTableView.register(UINib(nibName: "SubscriptionDataTableCell", bundle: nil), forCellReuseIdentifier: "SubscriptionDataTableCell")
    }
    
    func configData(data: GetPlansSubscriptionModel?) {
        guard let plan = data else { return }
        planData = plan
        // Set top-level labels
        lblPlanHeading.text = plan.planNameEnglish ?? "N/A"
        lblAmount.text = CommonUtils.formatPrice(plan.price)//"AED \(plan.price ?? 0)"
        
        let durationText: String
        if let duration = plan.duration, let type = plan.durationType {
            durationText = "for \(duration) \(type == 1 ? "Month" : "Years")"
        } else {
            durationText = "N/A"
        }
        lblDays.text = durationText
        
        // Prepare headings
        heading = [
            "Number of Products:",
            "Number of Videos (Reels):",
            "Number of Highlights:",
            "Stories:",
            "\(plan.noOfEmployee ?? 0) store Employees",
            "Commission:"
        ]
        
        // Handle "Stories" — show "Open" if 0, otherwise "Close"
        let storiesStatus: String
        if (plan.stories ?? 0) == 0 {
            storiesStatus = "Open"
        } else {
            storiesStatus = "Close"
        }
        
        // Prepare data
        self.data = [
            "\(plan.noOfProducts ?? 0)",
            "\(plan.noOfVideos ?? 0)",
            "\(plan.noOfHighlights ?? 0)",
            storiesStatus,
            "",
            "\(plan.commissionPercentage ?? 0)%"
        ]
        
        dataTableView.reloadData()
    }


    @IBAction func btnTapContinue(_ sender: Any) {
        if let plan = planData {
            delegate?.didTapContinue(for: plan)
        }
        purchasePlan?()
    }
    
}

extension SubscriptionCollectionCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return heading.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionDataTableCell", for: indexPath) as! SubscriptionDataTableCell
            cell.selectionStyle = .none
            cell.lblTitle.text = heading[indexPath.row]
            cell.lblData.text = data[indexPath.row]
            return cell
        }
    
}

protocol SubscriptionCollectionCellDelegate: AnyObject {
    func didTapContinue(for plan: GetPlansSubscriptionModel)
}
