//
//  OrderDetailsViewController.swift
//  DesynatDealer
//
//  Created by fluper on 05/01/26.
//

import UIKit
import Cosmos
import SDWebImage

class OrderDetailsViewController: UIViewController {
    
    @IBOutlet weak var discountOnMRpLabel: UILabel!
    @IBOutlet weak var discountOnMRPStackView: UIStackView!
    @IBOutlet weak var storeAttachmentView: CustomView!
    @IBOutlet weak var storeRatingattachmentImageView: UIImageView!
    @IBOutlet weak var productattachmentView: CustomView!
    @IBOutlet weak var productAttackemntImageView: UIImageView!
    @IBOutlet weak var productRatingSetailsStackView: UIStackView!
    @IBOutlet weak var storeRatngStackView: UIStackView!
    @IBOutlet weak var storeRatingCosmisView: CosmosView!
    @IBOutlet weak var storeReviewDescriptonLabel: UILabel!
    @IBOutlet weak var updateStatusView: UIView!
    @IBOutlet weak var statusView: CustomView!
    @IBOutlet weak var paymentDetailsView: CustomView!
    @IBOutlet weak var couponAppliedStackView: UIStackView!
    @IBOutlet weak var couponAppliedView: UIView!
    @IBOutlet weak var transactionStackView: UIStackView!
    @IBOutlet weak var paidByLabel: UILabel!
    @IBOutlet weak var userProfileImageView: CustomImageView!
    @IBOutlet weak var orderStatusLabel: UILabel!
    @IBOutlet weak var statusTF: UITextField!
    @IBOutlet weak var adminComissionLabel: UILabel!
    @IBOutlet weak var paidByCustomerLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var viewSubItem: UIStackView!
    @IBOutlet weak var viewItemPrice: UIStackView!
    @IBOutlet weak var viewTax: UIStackView!
    @IBOutlet weak var lblItemPrice: UILabel!
    @IBOutlet weak var lblItemPriceAmt: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var storeReviewsStackView: UIStackView!
    @IBOutlet weak var shippingChargeLAbel: UILabel!
    @IBOutlet weak var totalSavingAmountLabel: UILabel!
    @IBOutlet weak var coupanLabel: UILabel!
    @IBOutlet weak var totalItemLabel: UILabel!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var transcationIdLabel: UILabel!
    @IBOutlet weak var exchangeSizeLabel: CustomLabelFont!
    @IBOutlet weak var exchangeView: UIView!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var returnReasonView: UIStackView!
    @IBOutlet weak var returnRequestDateLabel: CustomLabelFont!
    @IBOutlet weak var returnIdLabel: CustomLabelFont!
    @IBOutlet weak var returnDetailsView: UIView!
    @IBOutlet weak var customerReviewDetailsLabel: UILabel!
    @IBOutlet weak var customerRatingDetailsView: UIStackView!
    @IBOutlet weak var customerRatingView: CosmosView!
    @IBOutlet weak var customDetailsLabel: UILabel!
    @IBOutlet weak var customDetailsView: UIStackView!
    @IBOutlet weak var customOrderView: CustomView!
    @IBOutlet weak var quotedPriceLabel: UILabel!
    @IBOutlet weak var totalQuantityLabel: UILabel!
    @IBOutlet weak var customerAddresSLabel: UILabel!
    @IBOutlet weak var emailIdLabel: UILabel!
    @IBOutlet weak var phoneumberLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var zoneLabel: UILabel!
    @IBOutlet weak var orderTypeLabel: UILabel!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var orderIDLabe: UILabel!
    @IBOutlet weak var productTableView: UITableView! {
        didSet {
            productTableView.registerCellFromNib(cellID: "ProductListTableViewCell")
        }
    }
    
    @IBOutlet weak var reviewStackView: UIStackView!
    @IBOutlet weak var lblReturnExchangeHeading: CustomLabelFont!
    @IBOutlet weak var lblReturnExchangeId: CustomLabelFont!
    
    var orderCategoryType: OrderCategoryType = .normalOrders
    lazy var viewModel = OrderDetailsViewModel(hostVC: self)
    var orderId: Int = 0
    var orderDetails: OrdersListData?
    private let deliveryStatus: [String: String] = ["Shipped": "2.1"]
    private let returnDeliveryRequest: [String: String] = ["Accept": "1","Reject": "2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        storeRatingCosmisView.settings.fillMode = .precise
        customerRatingView.settings.fillMode = .precise
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.orderDetailRequest()
    }
    
    @IBAction func statusDidTapped(_ sender: UIButton) {
        if orderDetails?.returnType == "1" || orderDetails?.returnType == "2" { // return and exchange
            kSharedAppDelegate.dropDown(
                dataSource: Array(returnDeliveryRequest.keys),
                anchorView: self.paymentDetailsView
            ) { index, item in
                self.statusTF.text = item
            }
        } else {
            kSharedAppDelegate.dropDown(
                dataSource: Array(deliveryStatus.keys),
                anchorView: self.paymentDetailsView
            ) { index, item in
                self.statusTF.text = item
            }
        }
    }
    
    @IBAction func submitDidTapped(_ sender: Any) {
        if orderDetails?.returnType == "1" || orderDetails?.returnType == "2" { // return and exchange
            guard let selectedStatus = statusTF.text?.trimmed(),
                  let apiStatus = returnDeliveryRequest[selectedStatus] else {
                CommonUtils.showToast(message: "Please update the status")
                return
            }
            viewModel.orderStatusRequestForExchangeAndReturn(status: apiStatus)
        } else {
            guard let selectedStatus = statusTF.text?.trimmed(),
                  let apiStatus = deliveryStatus[selectedStatus] else {
                CommonUtils.showToast(message: "Please update the status")
                return
            }
            
            viewModel.orderStatusRequest(status: apiStatus)
        }
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpUI() {
        if orderCategoryType == .normalOrders {
            viewItemPrice.isHidden = true
            viewSubItem.isHidden = false
            couponAppliedStackView.isHidden = false
            totalSavingAmountLabel.isHidden = true
        } else {
            viewItemPrice.isHidden = false
            viewSubItem.isHidden = true
            couponAppliedStackView.isHidden = true
            totalSavingAmountLabel.isHidden = true
        }
    }
    
    func bindData() {
        guard let data = orderDetails else { return }
        orderIDLabe.text = "#\(data.id ?? 0)"
        let formattedDate = formatDateString(data.order?.updatedAt ?? "") ?? ""
        dateAndTimeLabel.text = formattedDate
        if data.orderType == "1" {
            orderTypeLabel.text = "Normal Orders"
            customDetailsView.isHidden = true
            customOrderView.isHidden = true
        } else {
            orderTypeLabel.text = "Custom Orders"
            customOrderView.isHidden = false
            customDetailsView.isHidden = false
        }
        customDetailsLabel.text = data.chatRoomrecords?.customDetails
        userNameLabel.text = data.order?.userDetails?.fullName
        phoneumberLabel.text = "\(data.order?.userDetails?.countryCode ?? "") \(data.order?.userDetails?.mobile ?? "")"
        emailIdLabel.text = data.order?.userDetails?.email
        if let imageUrlString = data.order?.userDetails?.profileImage,
           let url = URL(string: imageUrlString) {
            userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            userProfileImageView.sd_imageIndicator?.startAnimatingIndicator()
            userProfileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "userProfile"))
        } else {
            userProfileImageView.image = UIImage(named: "userProfile")
        }
        
        customerAddresSLabel.text = self.buildFullAddress(from: data.order?.deliveryDetails)
        orderStatus()
        productTableView.reloadData()
        
        totalQuantityLabel.text = data.quantity?.description
        self.returnIdLabel.text = "#\(data.id ?? 0)"
        self.returnRequestDateLabel.text = data.updatedAt?.formattedPlacedDate() ?? ""
        self.reasonLabel.text = data.returnReason ?? data.exchangeReason ?? data.cancelReason ?? "-"
        let paymentMethod = data.order?.paymentMethod ?? "1"
        switch paymentMethod {
        case "1":
            paidByLabel.text = "Online"
            transactionStackView.isHidden = false
        case "2":
            paidByLabel.text = "Wallet"
            transactionStackView.isHidden = false
        default:
            paidByLabel.text = "Via COD"
            transactionStackView.isHidden = true
        }
        totalItemLabel.text = "\(data.quantity ?? 1) item"
        let promocodeValue = data.promocodeValue ?? ""
        if !promocodeValue.isEmpty {
            couponAppliedStackView.isHidden = false
            totalSavingAmountLabel.text = CommonUtils.formatPriceStringInput(data.promocodeValue)
            coupanLabel.text = CommonUtils.formatPriceStringInput(data.promocodeValue)
        } else {
            couponAppliedStackView.isHidden = true
        }
        shippingChargeLAbel.text = CommonUtils.formatPriceStringInput(data.shippingFees)
        subTotalLabel.text = CommonUtils.formatPriceStringInput(data.amount)
        lblTax.text = CommonUtils.formatPriceStringInput(data.tax)
        
        let priceString = data.amount ?? "0"   // String
        let quantity = data.quantity ?? 1      // Int
        
        let price = Double(priceString) ?? 0
        let totalPrice = price * Double(quantity)
        
        lblItemPrice.text = "Item Price (\(CommonUtils.formatPriceStringInput(priceString)) x \(quantity))"
        lblItemPriceAmt.text = CommonUtils.formatPriceStringInput(String(totalPrice))
        discountOnMRpLabel.text = CommonUtils.formatPriceStringInput(data.order?.discountMrp ?? "", currency: "KD")
        let totalAmount = toDouble(data.amount) + toDouble(data.shippingFees) + toDouble(data.tax)
        
        
        let totalCustomPrice = totalPrice + toDouble(data.tax) + toDouble(data.shippingFees)
        if orderCategoryType == .normalOrders {
            totalLabel.text = CommonUtils.formatPrice(totalAmount)
            let paidAmount = totalAmount - toDouble(data.promocodeValue)
            paidByCustomerLabel.text = CommonUtils.formatPrice(paidAmount)
            discountOnMRPStackView.isHidden = false
        } else {
            totalLabel.text = CommonUtils.formatPrice(totalCustomPrice)
            paidByCustomerLabel.text = CommonUtils.formatPrice(totalCustomPrice)
            quotedPriceLabel.text = CommonUtils.formatPrice(totalCustomPrice)
            discountOnMRPStackView.isHidden = true
        }
        
        adminComissionLabel.text = CommonUtils.formatPriceStringInput(data.adminCommission)
    }
    
    func toDouble(_ value: String?) -> Double {
        return Double(value ?? "") ?? 0
    }
    
    private func buildFullAddress(from details: DeliveryDetails?) -> String {
        guard let details = details else { return "" }
        var addressParts: [String] = []
        if let baseAddress = details.address?.trimmingCharacters(in: .whitespacesAndNewlines),
           !baseAddress.isEmpty {
            addressParts.append(baseAddress)
        }
        let additionalParts = [
            details.houseNo,
            details.streetNo,
            details.landmark,
            details.city,
            details.state,
            details.countryName,
            details.postalCode]
        for part in additionalParts {
            guard let value = part?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !value.isEmpty else { continue }
            if !addressParts.joined(separator: " ").localizedCaseInsensitiveContains(value) {
                addressParts.append(value)
            }
        }
        return addressParts.joined(separator: ", ")
    }
    
    private func formatDateString(_ isoDate: String) -> String? {
        let isoFormatter = DateFormatter()
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        isoFormatter.locale = Locale(identifier: "en_US_POSIX")
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        guard let date = isoFormatter.date(from: isoDate) else { return nil }
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "dd/MM/yyyy 'at' h:mm a" // 12-hour format
        displayFormatter.locale = Locale(identifier: "en_US_POSIX")
        displayFormatter.timeZone = TimeZone.current // local time
        return displayFormatter.string(from: date)
    }
    
    private func orderStatus() {
        customerRatingDetailsView.isHidden = true
        returnDetailsView.isHidden = true
        returnReasonView.isHidden = true
        exchangeView.isHidden = true
        updateStatusView.isHidden = true
        statusView.isHidden = true
        
        guard let data = orderDetails else { return }
        
        let paymentMethod = data.order?.paymentMethod ?? "1"
        let paymentStatus = data.paymentStatus ?? "1"
        let deliveryStatus = data.deliveryStatus ?? "1"
        if paymentMethod == "1" || paymentMethod == "2" {
            if paymentStatus == "1" {
                switch deliveryStatus {
                case "0":
                    if data.rEApprove == "1" {
                        orderStatusLabel.text = "Return Conf."
                        orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
                        returnDetailsView.isHidden = false
                        returnReasonView.isHidden = false
                    }
                    
                case "1": //Pending
                    orderStatusLabel.text = "Confirmed"
                    orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
                    updateStatusView.isHidden = false
                    statusView.isHidden = false
                    
                    if data.assignStatus == "1" || data.rEApprove == "1" {
                        orderStatusLabel.text = "On The Way"
                        orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
                        updateStatusView.isHidden = true
                        statusView.isHidden = true
                        if data.returnType == "1" && data.rEApprove == "1" && data.assignStatus == "0"{
                            orderStatusLabel.text = "Return Accepted"
                            orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
                            updateStatusView.isHidden = true
                            statusView.isHidden = true
                        }
                    }
                    
                case "2": //Ongoing
                    orderStatusLabel.text = "Ongoing"
                    orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
                    updateStatusView.isHidden = false
                    statusView.isHidden = false
                    
                case "3": //Delivered
                    orderStatusLabel.text = "Delivered"
                    orderStatusLabel.textColor = UIColor(hex: "#16B364")
                    if data.returnType == "1" || data.returnType == "2" {
                        if data.returnType == "1" {
                            orderStatusLabel.text = "Return Req."
                            orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
                            returnDetailsView.isHidden = false
                            returnReasonView.isHidden = false
                            updateStatusView.isHidden = false
                            statusView.isHidden = false
                            lblReturnExchangeHeading.text = "Return Details"
                            lblReturnExchangeId.text = "Return Id"
                        } else if data.returnType == "2" {
                            orderStatusLabel.text = "Exchange Req."
                            orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
                            returnDetailsView.isHidden = false
                            returnReasonView.isHidden = false
                            updateStatusView.isHidden = true
                            statusView.isHidden = false
                            lblReturnExchangeHeading.text = "Exchange Details"
                            lblReturnExchangeId.text = "Exchange Id"
                        }
                        if data.rEApprove == "1" {
                            orderStatusLabel.text = "Completed"
                            orderStatusLabel.textColor = UIColor(hex: "#16B364")
                            updateStatusView.isHidden = true
                            statusView.isHidden = true
                            if data.returnType == "2" {
                                orderStatusLabel.text = "Exchange Req Accepted"
                                orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
                                updateStatusView.isHidden = true
                                statusView.isHidden = true
                            }
                        } else if data.rEApprove == "2" {
                            orderStatusLabel.text = "Rejected"
                            orderStatusLabel.textColor = UIColor(hex: "#E70000")
                            updateStatusView.isHidden = true
                            statusView.isHidden = true
                        }
                    }
                    
                case "4": //Cancelled
                    orderStatusLabel.text = "Cancelled"
                    orderStatusLabel.textColor = UIColor(hex: "#E70000")
                    returnReasonView.isHidden = false
                    
                case "5": // Return
                    orderStatusLabel.text = "Return Req."
                    orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
                    returnDetailsView.isHidden = false
                    returnReasonView.isHidden = false
                    updateStatusView.isHidden = false
                    statusView.isHidden = false
                    
                case "7": //Picked
                    orderStatusLabel.text = "On The Way "
                    orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
                    updateStatusView.isHidden = true
                    statusView.isHidden = true
                    
                case "9": // Exchange
                    orderStatusLabel.text = "Exchange Req."
                    orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
                    returnDetailsView.isHidden = false
                    exchangeView.isHidden = false
                    exchangeSizeLabel.text = data.exchangeNewSize
                    returnReasonView.isHidden = false
                    
                case "2.1": //Shipped
                    orderStatusLabel.text = "Shipped"
                    orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
                    updateStatusView.isHidden = true
                    statusView.isHidden = true
                    if data.assignStatus == "1" {
                        orderStatusLabel.text = "On The Way"
                        orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
                        updateStatusView.isHidden = true
                        statusView.isHidden = true
                    }
                    
                default:
                    return
                }
            } else if paymentStatus == "3" {
                orderStatusLabel.text = "Cancelled"
                orderStatusLabel.textColor = UIColor(hex: "#E70000")
                returnReasonView.isHidden = false
            }
        } else if paymentMethod == "3" {
            if paymentStatus == "0" || paymentStatus == "1" {
                switch deliveryStatus {
                case "0":
                    if data.rEApprove == "1" {
                        orderStatusLabel.text = "Return Conf."
                        orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
                        returnDetailsView.isHidden = false
                        returnReasonView.isHidden = false
                    }
                case "1": //Pending
                    orderStatusLabel.text = "Confirmed"
                    orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
                    updateStatusView.isHidden = false
                    statusView.isHidden = false
                    
                    if data.assignStatus == "1" || data.rEApprove == "1" {
                        orderStatusLabel.text = "On The Way"
                        orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
                        updateStatusView.isHidden = true
                        statusView.isHidden = true
                        if data.returnType == "1" && data.rEApprove == "1" && data.assignStatus == "0"{
                            orderStatusLabel.text = "Return Accepted"
                            orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
                            updateStatusView.isHidden = true
                            statusView.isHidden = true
                        }
                    }
                    
                    
                case "2": //Ongoing, Picked
                    orderStatusLabel.text = "Ongoing"
                    orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
                    updateStatusView.isHidden = false
                    statusView.isHidden = false
                    
                case "3": //Delivered
                    orderStatusLabel.text = "Delivered"
                    orderStatusLabel.textColor = UIColor(hex: "#16B364")
                    if data.returnType == "1" || data.returnType == "2" {
                        if data.returnType == "1" {
                            orderStatusLabel.text = "Return Req."
                            orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
                            returnDetailsView.isHidden = false
                            returnReasonView.isHidden = false
                            updateStatusView.isHidden = false
                            statusView.isHidden = false
                            lblReturnExchangeHeading.text = "Return Details"
                            lblReturnExchangeId.text = "Return Id"
                        } else if data.returnType == "2" {
                            orderStatusLabel.text = "Exchange Req."
                            orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
                            returnDetailsView.isHidden = true
                            returnReasonView.isHidden = false
                            updateStatusView.isHidden = false
                            statusView.isHidden = false
                            lblReturnExchangeHeading.text = "Exchange Details"
                            lblReturnExchangeId.text = "Exchange Id"
                        }
                        if data.rEApprove == "1" {
                            orderStatusLabel.text = "Completed"
                            orderStatusLabel.textColor = UIColor(hex: "#16B364")
                            updateStatusView.isHidden = true
                            statusView.isHidden = true
                            if data.returnType == "2" {
                                orderStatusLabel.text = "Exchange Req Accepted"
                                orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
                                updateStatusView.isHidden = true
                                statusView.isHidden = true
                            }
                        } else if data.rEApprove == "2" {
                            orderStatusLabel.text = "Rejected"
                            orderStatusLabel.textColor = UIColor(hex: "#E70000")
                            updateStatusView.isHidden = true
                            statusView.isHidden = true
                        }
                    }
                case "4", "8":
                    orderStatusLabel.text = "Cancelled"
                    orderStatusLabel.textColor = UIColor(hex: "#E70000")
                    returnReasonView.isHidden = false
                case "5": // Return
                    orderStatusLabel.text = "Return Req."
                    orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
                    returnDetailsView.isHidden = false
                    returnReasonView.isHidden = false
                    updateStatusView.isHidden = false
                    statusView.isHidden = false
                    
                case "7": //Picked
                    orderStatusLabel.text = "On The Way "
                    orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
                    updateStatusView.isHidden = true
                    statusView.isHidden = true
                    
                case "9": // Exchange
                    orderStatusLabel.text = "Exchange Req."
                    orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
                    returnDetailsView.isHidden = false
                    exchangeView.isHidden = false
                    exchangeSizeLabel.text = data.exchangeNewSize
                    returnReasonView.isHidden = false
                    
                case "2.1": //Shipped
                    orderStatusLabel.text = "Shipped"
                    orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
                    updateStatusView.isHidden = true
                    statusView.isHidden = true
                    if data.assignStatus == "1" {
                        orderStatusLabel.text = "On The Way"
                        orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
                        updateStatusView.isHidden = true
                        statusView.isHidden = true
                    }
                    
                default:
                    return
                }
            } else if paymentStatus == "2" {
                orderStatusLabel.text = "Cancelled"
                orderStatusLabel.textColor = UIColor(hex: "#E70000")
                returnReasonView.isHidden = false
            }
        }
        
        let userRatingDone = data.userRatingReviewProvide
        guard let ratingData = userRatingDone else { return }
        customerRatingDetailsView.isHidden = false
        if let storeurl = URL(string: userRatingDone?.storeImage ?? "") {
          self.storeRatingattachmentImageView.sd_setImage(with: storeurl,placeholderImage: UIImage(named: ""))
        }
        
        if let productUrl = URL(string: userRatingDone?.productImage ?? "") {
          self.productAttackemntImageView.sd_setImage(with: productUrl,placeholderImage: UIImage(named: ""))
        }
        /// ✅ PRODUCT RATING CHECK
        let productReview = ratingData.productReview ?? ""
        let productRatingValue = Double(ratingData.productRating ?? "") ?? 0
        
        if !productReview.isEmpty || productRatingValue > 0 {
            self.reviewStackView.isHidden = false
            self.customerReviewDetailsLabel.text = productReview
            self.customerRatingView.rating = productRatingValue
        }
        
        if !productReview.isEmpty {
            self.reviewStackView.isHidden = false
        } else {
            self.reviewStackView.isHidden = true
        }
        
        /// ✅ store RATING CHECK
        let storeReview = ratingData.storeReview ?? ""
        let StoreRatingValue = Double(ratingData.storeRating ?? "") ?? 0
        
        if !storeReview.isEmpty || StoreRatingValue > 0 {
            self.storeReviewsStackView.isHidden = false
            self.storeReviewDescriptonLabel.text = storeReview
            self.storeRatingCosmisView.rating = StoreRatingValue
        }
        
        if !storeReview.isEmpty {
            self.storeReviewsStackView.isHidden = false
        } else {
            self.storeReviewsStackView.isHidden = true
        }
        
        if let productImage = userRatingDone?.productImage,
           !productImage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
           productImage.lowercased() != "null" {
            productattachmentView.isHidden = false
        } else {
            productattachmentView.isHidden = true
        }

        if let storeImage = userRatingDone?.storeImage,
           !storeImage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
           storeImage.lowercased() != "null" {
            storeAttachmentView.isHidden = false
        } else {
            storeAttachmentView.isHidden = true
        }
        
    }
    
    
}

extension OrderDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1//viewModel.orderDetails.variationDetails.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListTableViewCell", for: indexPath) as! ProductListTableViewCell
        if orderCategoryType == .normalOrders {
            cell.configData(data: orderDetails, isCustomOrder: false)
        } else {
            cell.configData(data: orderDetails, isCustomOrder: true)
        }
        
        return cell
    }
    
}
