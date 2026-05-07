//
//  OrdersListTableViewCell.swift
//  DesynatDealer
//
//  Created by fluper on 05/01/26.
//

import UIKit
import SDWebImage

class OrdersListTableViewCell: UITableViewCell {

  @IBOutlet weak var productImageView: CustomImageView!
  @IBOutlet weak var userProfileImageView: CustomImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var orderIdLabel: UILabel!
  @IBOutlet weak var orderDateAndTimeLabel: UILabel!
  @IBOutlet weak var productDetailsLabel: UILabel!
  @IBOutlet weak var quantityLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func configData(data: OrdersListData?) {
    userNameLabel.text = data?.userDetails?.fullName
    orderIdLabel.text = "#\(data?.id ?? 0)"
    let formattedDate = formatDateString(data?.order?.updatedAt ?? "") ?? ""
    orderDateAndTimeLabel.text = formattedDate
    if let imageUrlString = data?.userDetails?.profileImage,
       let url = URL(string: imageUrlString) {
      userProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
      userProfileImageView.sd_imageIndicator?.startAnimatingIndicator()
      userProfileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "userProfile"))
    } else {
      userProfileImageView.image = UIImage(named: "userProfile")
    }
    
    if let imageUrlString = data?.variationDetails?.variantImage?.first,
       let url = URL(string: imageUrlString) {
      productImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
      productImageView.sd_imageIndicator?.startAnimatingIndicator()
      productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
    } else {
      productImageView.image = UIImage(named: "")
    }
      if AppLanguageManager.shared.currentLanguage == .ar {
          productDetailsLabel.text = "\(data?.productDetails?.productNameAr ?? "") (\(data?.variationDetails?.size?.name ?? ""))"
      } else {
          productDetailsLabel.text = "\(data?.productDetails?.productNameEn ?? "") (\(data?.variationDetails?.size?.name ?? ""))"
      }
    
    quantityLabel.text = "\(data?.quantity ?? 1)"
    addressLabel.text =
    self.buildFullAddress(from: data?.order?.deliveryDetails)
    let paymentMethod = data?.order?.paymentMethod ?? "1"
    let paymentStatus = data?.paymentStatus ?? "1"
    let deliveryStatus = data?.deliveryStatus ?? "1"
    if paymentMethod == "1" || paymentMethod == "2" {
      if paymentStatus == "1" {
        switch deliveryStatus {
        case "0":
          if data?.rEApprove == "1" {
              statusLabel.text = "Return Conf.".localiz()
            statusLabel.textColor = UIColor(hex: "#FF5F1B")
          }
        case "1": //Pending
            statusLabel.text = "Confirmed".localiz()
          statusLabel.textColor = UIColor(hex: "#FF5F1B")
            
            if data?.assignStatus == "1" || data?.rEApprove == "1" {
                statusLabel.text = "On The Way".localiz()
                statusLabel.textColor = UIColor(hex: "#FF5F1B")
                
                if data?.returnType == "1" && data?.rEApprove == "1" && data?.assignStatus == "0"{
                    statusLabel.text = "Return Accepted".localiz()
                    statusLabel.textColor = UIColor(hex: "#FF5F1B")
                }
            }
          
        case "2": //Ongoing
            statusLabel.text = "Ongoing".localiz()
          statusLabel.textColor = UIColor(hex: "#FF5F1B")
          
        case "3": //Delivered
            statusLabel.text = "Delivered".localiz()
          statusLabel.textColor = UIColor(hex: "#16B364")
            if data?.returnType == "1" || data?.returnType == "2"  {
                if data?.returnType == "1" {
                    statusLabel.text = "Return Req.".localiz()
                    statusLabel.textColor = UIColor(hex: "#FF5F1B")
                } else if data?.returnType == "2" {
                    statusLabel.text = "Exchange".localiz()
                    statusLabel.textColor = UIColor(hex: "#FF5F1B")
                }
              if data?.rEApprove == "1" {
                  statusLabel.text = "Completed".localiz()
                  statusLabel.textColor = UIColor(hex: "#16B364")
                if data?.returnType == "2" {
                    statusLabel.text = "Exchange Req Accepted".localiz()
                  statusLabel.textColor = UIColor(hex: "#FF5F1B")
                }
              } else if data?.rEApprove == "2" {
                  statusLabel.text = "Rejected".localiz()
                statusLabel.textColor = UIColor(hex: "#E70000")
              }
          }
          
        case "4": //Cancelled
            statusLabel.text = "Cancelled".localiz()
          statusLabel.textColor = UIColor(hex: "#E70000")
            
        case "7": //Picked
            statusLabel.text = "On The Way".localiz()
          statusLabel.textColor = UIColor(hex: "#FF5F1B")
            
        case "2.1": //Shipped
            statusLabel.text = "Shipped".localiz()
           statusLabel.textColor = UIColor(hex: "#FF5F1B")
            if data?.assignStatus == "1" {
                statusLabel.text = "On The Way".localiz()
                statusLabel.textColor = UIColor(hex: "#FF5F1B")
            }
            
        default:
          return
        }
      } else if paymentStatus == "3" {
          statusLabel.text = "Cancelled".localiz()
        statusLabel.textColor = UIColor(hex: "#E70000")
      }
    } else if paymentMethod == "3" {
      if paymentStatus == "0" || paymentStatus == "1" {
        switch deliveryStatus {
        case "0":
          if data?.rEApprove == "1" {
              statusLabel.text = "Return Conf.".localiz()
            statusLabel.textColor = UIColor(hex: "#FF5F1B")
          }
        case "1": //Pending
            statusLabel.text = "Confirmed".localiz()
          statusLabel.textColor = UIColor(hex: "#FF5F1B")
            
            if data?.assignStatus == "1" || data?.rEApprove == "1" {
                statusLabel.text = "On The Way".localiz()
                statusLabel.textColor = UIColor(hex: "#FF5F1B")
                if data?.returnType == "1" && data?.rEApprove == "1" && data?.assignStatus == "0"{
                    statusLabel.text = "Return Accepted".localiz()
                    statusLabel.textColor = UIColor(hex: "#FF5F1B")
                }
            }
          
        case "2": //Ongoing, Picked
            statusLabel.text = "Ongoing".localiz()
          statusLabel.textColor = UIColor(hex: "#FF5F1B")
         
        case "3": //Delivered
            statusLabel.text = "Delivered".localiz()
          statusLabel.textColor = UIColor(hex: "#16B364")
            if data?.returnType == "1" || data?.returnType == "2"  {
                if data?.returnType == "1" {
                    statusLabel.text = "Return Req.".localiz()
                    statusLabel.textColor = UIColor(hex: "#FF5F1B")
                } else if data?.returnType == "2" {
                    statusLabel.text = "Exchange".localiz()
                    statusLabel.textColor = UIColor(hex: "#FF5F1B")
                }
              if data?.rEApprove == "1" {
                  statusLabel.text = "Completed".localiz()
                  statusLabel.textColor = UIColor(hex: "#16B364")
                if data?.returnType == "2" {
                    statusLabel.text = "Exchange Req Accepted".localiz()
                  statusLabel.textColor = UIColor(hex: "#FF5F1B")
                }
              } else if data?.rEApprove == "2" {
                  statusLabel.text = "Rejected".localiz()
                statusLabel.textColor = UIColor(hex: "#E70000")
              }
          }
          
        case "7": //Picked
            statusLabel.text = "On The Way".localiz()
          statusLabel.textColor = UIColor(hex: "#FF5F1B")
            
        case "4", "8": //Cancelled
            statusLabel.text = "Cancelled".localiz()
          statusLabel.textColor = UIColor(hex: "#E70000")
            
        case "2.1": //Shipped
            statusLabel.text = "Shipped".localiz()
           statusLabel.textColor = UIColor(hex: "#FF5F1B")
            if data?.assignStatus == "1" {
                statusLabel.text = "On The Way".localiz()
                statusLabel.textColor = UIColor(hex: "#FF5F1B")
            }
        default:
          return
        }
      } else if paymentStatus == "2" {
          statusLabel.text = "Cancelled".localiz()
        statusLabel.textColor = UIColor(hex: "#E70000")
      }
    }
  }
  
  func buildFullAddress(from details: DeliveryDetails?) -> String {
      guard let details = details else { return "" }
      
      var addressParts: [String] = []
      
      // Base address (if API already provides)
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
          details.postalCode,
      ]
      
      for part in additionalParts {
          guard let value = part?.trimmingCharacters(in: .whitespacesAndNewlines),
                !value.isEmpty else { continue }
          
          if !addressParts.joined(separator: " ").localizedCaseInsensitiveContains(value) {
              addressParts.append(value)
          }
      }
      
      return addressParts.joined(separator: ", ")
  }
  
  func formatDateString(_ isoDate: String) -> String? {
      // 1. Create ISO8601 DateFormatter
      let isoFormatter = DateFormatter()
      isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
      isoFormatter.locale = Locale(identifier: "en_US_POSIX")
      isoFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Z means UTC
      
      // 2. Convert string to Date
      guard let date = isoFormatter.date(from: isoDate) else { return nil }
      
      // 3. Format date to desired format
      let displayFormatter = DateFormatter()
      displayFormatter.dateFormat = "dd/MM/yyyy 'at' h:mm a" // 12-hour format
      displayFormatter.locale = Locale(identifier: "en_US_POSIX")
      displayFormatter.timeZone = TimeZone.current // local time
      
      return displayFormatter.string(from: date)
  }

  
}
