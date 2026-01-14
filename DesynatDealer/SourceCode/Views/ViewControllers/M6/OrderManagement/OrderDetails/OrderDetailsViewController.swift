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
  
  lazy var viewModel = OrderDetailsViewModel(hostVC: self)
  var orderId: Int = 0
  var orderDetails: OrdersListData?
  private let deliveryStatus: [String: String] = [
//      "Packed": "2",
      "Shipped": "2.1"
  ]
  
  private let returnDeliveryRequest: [String: String] = [
          "Confirmed": "1",
          "Reject": "2"
      ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.orderDetailRequest()
  }
  
  @IBAction func statusDidTapped(_ sender: UIButton) {
    if orderDetails?.returnType == "1" { // return and exchange
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
    if orderDetails?.returnType == "1" { // return and exchange
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
  
  func bindData() {
    guard let data = orderDetails else { return }
    orderIDLabe.text = "#\(data.id ?? 0)"
    let formattedDate = formatDateString(data.order?.updatedAt ?? "") ?? ""
    dateAndTimeLabel.text = formattedDate
    if data.order?.orderType == "1" {
      orderTypeLabel.text = "Normal Orders"
      customDetailsView.isHidden = true
      customOrderView.isHidden = true
    } else {
      orderTypeLabel.text = "Custom Orders"
      customOrderView.isHidden = false
      customDetailsView.isHidden = false
    }
    customDetailsLabel.text = data.productDetails?.customizedProduct
//    zoneLabel.text = data.order?.del
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
    quotedPriceLabel.text = CommonUtils.formatPriceStringInput(data.amount)
//    returnIdLabel.text = data.re
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
      paidByLabel.text = "COD"
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
//    let totalAmount = data.amount + data.shippingFees
//    totalLabel.text = CommonUtils.formatPriceStringInput(totalAmount)
//    let paidAmount = totalAmount - data.promocodeValue
//    paidByCustomerLabel.text = CommonUtils.formatPriceStringInput(paidAmount)
    
    let totalAmount = toDouble(data.amount) + toDouble(data.shippingFees)
    totalLabel.text = CommonUtils.formatPrice(totalAmount)

    let paidAmount = totalAmount - toDouble(data.promocodeValue)
    paidByCustomerLabel.text = CommonUtils.formatPrice(paidAmount)
    adminComissionLabel.text = CommonUtils.formatPriceStringInput(data.adminCommission)
//    coupanLabel.text = CommonUtils.formatPriceStringInput(data.promocodeValue)
    
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
          orderStatusLabel.text = "Ongoing"
          orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
          updateStatusView.isHidden = false
          statusView.isHidden = false
        case "2", "7": //Ongoing
          orderStatusLabel.text = "Ongoing"
          orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
          updateStatusView.isHidden = false
          statusView.isHidden = false
        case "3": //Delivered
          orderStatusLabel.text = "Delivered"
          orderStatusLabel.textColor = UIColor(hex: "#16B364")
          if data.returnType == "1" {
            orderStatusLabel.text = "Return Req."
            orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
            returnDetailsView.isHidden = false
            returnReasonView.isHidden = false
            updateStatusView.isHidden = false
            statusView.isHidden = false
          }
          
          let userRatingDone = data.userRatingReviewProvide
          guard let ratingData = userRatingDone else { return }
          
          /// ✅ PRODUCT RATING CHECK
          let productReview = ratingData.productReview ?? ""
          let productRatingValue = Double(ratingData.productRating ?? "") ?? 0
          
          if !productReview.isEmpty || productRatingValue > 0 {
              self.customerRatingDetailsView.isHidden = false
              self.customerReviewDetailsLabel.text = productReview
              self.customerRatingView.rating = productRatingValue
          }
          
          if !productReview.isEmpty {
              self.customerReviewDetailsLabel.isHidden = false
          } else {
              self.customerReviewDetailsLabel.isHidden = true
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
          
        case "9": // Exchange
          orderStatusLabel.text = "Exchange Req."
          orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
          returnDetailsView.isHidden = false
          exchangeView.isHidden = false
          exchangeSizeLabel.text = data.exchangeNewSize
          returnReasonView.isHidden = false
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
          orderStatusLabel.text = "Ongoing"
          orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
          updateStatusView.isHidden = false
          statusView.isHidden = false
        case "2", "7": //Ongoing, Picked
          orderStatusLabel.text = "Ongoing"
          orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
          updateStatusView.isHidden = false
          statusView.isHidden = false
        case "3": //Delivered
          orderStatusLabel.text = "Delivered"
          orderStatusLabel.textColor = UIColor(hex: "#16B364")
          
          if data.returnType == "1" {
            orderStatusLabel.text = "Return Req."
            orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
            returnDetailsView.isHidden = false
            returnReasonView.isHidden = false
            updateStatusView.isHidden = false
            statusView.isHidden = false
          }
          let userRatingDone = data.userRatingReviewProvide
          guard let ratingData = userRatingDone else { return }
          
          /// ✅ PRODUCT RATING CHECK
          let productReview = ratingData.productReview ?? ""
          let productRatingValue = Double(ratingData.productRating ?? "") ?? 0
          
          if !productReview.isEmpty || productRatingValue > 0 {
              self.customerRatingDetailsView.isHidden = false
              self.customerReviewDetailsLabel.text = productReview
              self.customerRatingView.rating = productRatingValue
          }
          
          if !productReview.isEmpty {
              self.customerReviewDetailsLabel.isHidden = false
          } else {
              self.customerReviewDetailsLabel.isHidden = true
          }
//          
//          /// ✅ SELLER RATING CHECK
//          let sellerReview = ratingData.storeReview ?? ""
//          let sellerRatingValue = Double(ratingData.storeRating ?? "") ?? 0
//          
//          if !sellerReview.isEmpty || sellerRatingValue > 0 {
//              self.sellerRatingStackView.isHidden = false
//              self.lblSellerReview.text = sellerReview
//              self.sellerRatingView.rating = sellerRatingValue
//              
//          }
//          if !sellerReview.isEmpty {
//              self.sellerReviewTitleLabel.isHidden = false
//          }else {
//              self.sellerReviewTitleLabel.isHidden = true
//          }
          
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
        case "9": // Exchange
          orderStatusLabel.text = "Exchange Req."
          orderStatusLabel.textColor = UIColor(hex: "#FF5F1B")
          returnDetailsView.isHidden = false
          exchangeView.isHidden = false
          exchangeSizeLabel.text = data.exchangeNewSize
          returnReasonView.isHidden = false
        default:
          return
        }
      } else if paymentStatus == "2" {
        orderStatusLabel.text = "Cancelled"
        orderStatusLabel.textColor = UIColor(hex: "#E70000")
        returnReasonView.isHidden = false
      }
    }
  }
  
  
  
}

extension OrderDetailsViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1//viewModel.orderDetails.variationDetails.
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListTableViewCell", for: indexPath) as! ProductListTableViewCell
    cell.configData(data: orderDetails)
    return cell
  }
  
}
