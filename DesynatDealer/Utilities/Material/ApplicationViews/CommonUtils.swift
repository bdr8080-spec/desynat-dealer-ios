import Foundation
import UIKit
import SVProgressHUD
import AVFoundation
import DropDown
import FTIndicator

class CommonUtils {
    
    /// This function will help developer to get default country of the user based on locale
//    static func getDefaultCountryCode() -> String {
//        let countryPicker = ADCountryPicker()
//        if #available(iOS 16, *) {
//            return countryPicker.getDialCode(countryCode: NSLocale.current.region?.identifier ?? "UK") ?? "+44"
//        } else {
//            return countryPicker.getDialCode(countryCode: NSLocale.current.identifier) ?? "+44"
//        }
//    }
    
    /// This function will help developer to get top, bottom and total SafeArea Height
    static func getSafeAreaHeight() -> (top: CGFloat, bottom: CGFloat, total: CGFloat) {
        var window: UIWindow!
        
        if #available(iOS 15, *) {
            guard let firstWindow = UIApplication.shared.connectedScenes.first?.inputView?.window else { return (CGFloat.zero, CGFloat.zero, CGFloat.zero) }
            window = firstWindow
        } else {
            guard let firstWindow = UIApplication.shared.windows.first else { return (CGFloat.zero, CGFloat.zero, CGFloat.zero) }
            window = firstWindow
        }
        
        let topPadding = window.safeAreaInsets.top
        let bottomPadding = window.safeAreaInsets.bottom
        return (topPadding, bottomPadding, topPadding + bottomPadding)
    }
    
    /// This function will help developer to get an image with User's Initials
    static func getImageWithUserInitials(withName name: String?, backgroundColor bgColor: UIColor, textColor txtColor: UIColor, textFont txtFont: UIFont, andSize size: CGFloat) -> UIImage? {
        let frame = CGRect(x: 0.0, y: 0.0, width: size, height: size)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = bgColor
        nameLabel.textColor = txtColor
        nameLabel.font = txtFont
        var initials = ""
        if let initialsArray = name?.components(separatedBy: " ") {
            if let firstWord = initialsArray.first {
                if let firstLetter = firstWord.first {
                    initials += String(firstLetter).capitalized
                }
            }
            if initialsArray.count > 1, let lastWord = initialsArray.last {
                if let lastLetter = lastWord.first {
                    initials += String(lastLetter).capitalized
                }
            }
        } else if let name = name, name.count > 0 {
            initials = String(name.prefix(1)).capitalized
        } else {
            return nil
        }
        nameLabel.text = initials
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            return img
        }
        return nil
    }
    
    /// Show Progress Hud
    /// - Parameter show: Boolean value to show/Hide
    static func showHud(show: Bool) {
        if show == true {
            SVProgressHUD.setDefaultMaskType(.none)
            SVProgressHUD.setDefaultStyle(.custom)
           // SVProgressHUD.setForegroundColor(.themeBlue)
            SVProgressHUD.setBackgroundColor(.white)
            SVProgressHUD.show()
        } else {
            SVProgressHUD.dismiss()
        }
    }
    
    static func openPicker(controller:UIViewController, callBack:@escaping ((String,String,String) -> Void)) {
        let picker = ADCountryPicker(style: .grouped)
        picker.searchBarBackgroundColor = .white
        picker.showCallingCodes = true
        picker.didSelectCountryWithCallingCodeClosure = { name,code, callingCodes in
            picker.dismiss(animated: true)
            callBack(name,code, callingCodes)
        }
        let pickerNavigationController = UINavigationController(rootViewController: picker)
        controller.present(pickerNavigationController, animated: true, completion: nil)
    }
    
    /// Get thumnail from video url
    /// - Parameter url: desired video url
    /// - Parameter completion: if found asset at url then will return uiimage else ll return nil
    static func getThumbnailImage(forUrl url: URL, completion:@escaping(UIImage?)->()) {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) ,
                                                                actualTime: nil)
            completion(UIImage(cgImage: thumbnailImage))
        } catch _ {
            completion(nil)
        }
    }
    
    static func openSetting() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    /// String DropDown
    /// - Parameters:
    ///   - dataSource: String array to show list
    ///   - anchorView: view from where it will show listing
    ///   - selectedColor: selected value color
    ///   - completion: Index of selection and value of selection
    static func dropDown(dataSource:[String], anchorView:UIView, selectedColor:UIColor,
                  completion: @escaping (  _ index: Int ,  _ item: String) -> ()) {
        let dropDown = DropDown()
        dropDown.anchorView = anchorView
        dropDown.dataSource = dataSource
        dropDown.backgroundColor = UIColor.white
        dropDown.textColor = .black
        dropDown.direction = .any
        dropDown.selectionBackgroundColor = UIColor.white
        dropDown.selectedTextColor = selectedColor
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dismissMode = .automatic
        // Customize cell configuration for text alignment
//            dropDown.customCellConfiguration = { (index: Int, item: String, cell: DropDownCell) in
//                if kSharedUserDefaults.getValue(Key: .language) == "ar" {
//                    cell.optionLabel.textAlignment = .right // Align text to the right for Arabic
//                } else {
//                    cell.optionLabel.textAlignment = .left // Align text to the left for English
//                }
//            }
        dropDown.show()
        dropDown.selectionAction = {(index: Int, item: String) in
            completion(index,item)
        }
    }
    
//    static func openPicker(controller:UIViewController, callBack:@escaping ((String,String,String) -> Void)) {
//        let picker = ADCountryPicker(style: .grouped)
//        picker.searchBarBackgroundColor = .white
//        picker.showCallingCodes = true
//        picker.didSelectCountryWithCallingCodeClosure = { name,code, callingCodes in
//            picker.dismiss(animated: true)
//            callBack(name,code, callingCodes)
//        }
//        let pickerNavigationController = UINavigationController(rootViewController: picker)
//        controller.present(pickerNavigationController, animated: true, completion: nil)
//    }
    
    static func getCode(dialCode:String) -> String {
        guard let path = Bundle.main.path(forResource: "CallingCodes", ofType: "plist") else {return ""}
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        guard let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [[String:String]] else { return "" }
        let countries = plist.first(where:{$0["dial_code"] ==  dialCode})
        return String.getString(countries?["code"])
    }
    static func convertToPrice(_ value:Double) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.currencySymbol = ""
        formatter.maximumFractionDigits = 0
        formatter.numberStyle = .currency
        if let formattedTipAmount = formatter.string(from: value as NSNumber) {
            return formattedTipAmount
        }
        return String.getString(value)
    }
    static func showToast(message: String) {
        FTIndicator.showNotification(withTitle: Bundle.main.ApplicationName ?? "", message: message.count>0 ? message: "Message")
    }
    
    //MARK: Date Utilities
    static func parseDate(date:String,formate:String = "h:mm a") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
        return dateFormatter.date(from: date)
    }
}


