//
//  UIViewController.swift
//  ChorApp
//
//  Created by Developer on 07/12/23.
//

import Foundation
import UIKit
import Toaster
import PDFKit

extension UIViewController {
    
    private static var isAlertVisible = false
    
//    public func showAlert(msg:String, completion:(()->())? = nil) {
//        let alert = UIAlertController(title: Bundle.main.ApplicationName ?? "", message: msg, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: StringConstant.ok.value(), style: .default, handler: { _ in
//            completion?()
//        }))
//        self.present(alert, animated: true)
//    }
    
    public func showAlert(msg: String, completion: (() -> Void)? = nil) {
            // Prevent multiple alerts
            guard !UIViewController.isAlertVisible else { return }
            UIViewController.isAlertVisible = true
            
            DispatchQueue.main.async {
                let alert = UIAlertController(title: Bundle.main.ApplicationName ?? "",
                                              message: msg,
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: StringConstant.ok.value(), style: .default, handler: { _ in
                    UIViewController.isAlertVisible = false   // reset flag
                    completion?()
                }))
                
                self.present(alert, animated: true)
            }
        }
    
    public func showConfirmationAlert(
        msg: String,
        completion: (() -> Void)? = nil
    ) {
        // Prevent multiple alerts
        guard !UIViewController.isAlertVisible else { return }
        UIViewController.isAlertVisible = true

        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: Bundle.main.ApplicationName ?? "",
                message: msg,
                preferredStyle: .alert
            )

            // Yes Action
            let yesButton = UIAlertAction(title: "Yes", style: .default) { _ in
                UIViewController.isAlertVisible = false
                completion?()
            }

            // Cancel Action (red color)
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                UIViewController.isAlertVisible = false
            }

            // Apply red color to Cancel button text
            cancelButton.setValue(UIColor.red, forKey: "titleTextColor")

            alert.addAction(yesButton)
            alert.addAction(cancelButton)

            self.present(alert, animated: true)
        }
    }

    
    static func convertPDFToImages(pdfURL: URL) -> [UIImage]? {
        guard let pdfDocument = PDFDocument(url: pdfURL) else {
            return nil
        }
        var images: [UIImage] = []
        
        for pageNum in 0..<pdfDocument.pageCount {
            if let pdfPage = pdfDocument.page(at: pageNum) {
                let pdfPageSize = pdfPage.bounds(for: .mediaBox)
                let renderer = UIGraphicsImageRenderer(size: pdfPageSize.size)
                
                let image = renderer.image { ctx in
                    UIColor.white.set()
                    ctx.fill(pdfPageSize)
                    ctx.cgContext.translateBy(x: 0.0, y: pdfPageSize.size.height)
                    ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
                    
                    pdfPage.draw(with: .mediaBox, to: ctx.cgContext)
                }
                images.append(image)
            }
        }
        return images
    }
    
//    public func showAlert(msg: String, completion: (() -> ())? = nil) {
//        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
//
//        // Image View
//        let imageView = UIImageView(image: UIImage(named: "alertImg"))
//        imageView.contentMode = .scaleAspectFit
//        imageView.layer.cornerRadius = 6
//        imageView.clipsToBounds = true
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
//
//        // Message Label
//        let messageLabel = UILabel()
//        messageLabel.text = msg
//        messageLabel.numberOfLines = 0
//        messageLabel.textAlignment = .center
//        messageLabel.font = UIFont.systemFont(ofSize: 14)
//        messageLabel.textColor = .label
//        messageLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        // Separator Line
//        let separator = UIView()
//        separator.backgroundColor = UIColor.systemGray4
//        separator.translatesAutoresizingMaskIntoConstraints = false
//        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
//
//        // Stack View
//        let stackView = UIStackView(arrangedSubviews: [imageView, messageLabel, separator])
//        stackView.axis = .vertical
//        stackView.spacing = 12
//        stackView.alignment = .fill
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//
//        alert.view.addSubview(stackView)
//
//        NSLayoutConstraint.activate([
//            stackView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 20),
//            stackView.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor, constant: 20),
//            stackView.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor, constant: -20),
//            stackView.bottomAnchor.constraint(lessThanOrEqualTo: alert.view.bottomAnchor, constant: -70),
//            separator.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
//            separator.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
//        ])
//
//        // OK button
//        alert.addAction(UIAlertAction(title: StringConstant.ok.value(), style: .default, handler: { _ in
//            completion?()
//        }))
//
//        self.present(alert, animated: true)
//    }
    
    func getCurrentTime() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, hh:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Kolkata")
        return dateFormatter.string(from: currentDate)
    }
    public func showBlockAlert(msg:String, completion:(()->())? = nil) {
        let alert = UIAlertController(title: Bundle.main.ApplicationName ?? "", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: StringConstant.ok.value(), style: .default, handler: { _ in
            completion?()
            UserDefaults.standard.set("no", forKey: "isGuest")
            kSharedSceneDelegate.logoutUser()
        }))
        self.present(alert, animated: true)
    }
    
    /// Show Toater Alert
    public func showToast(msg:String) {
        let tost = Toast(text: msg)
        tost.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        tost.view.layer.cornerRadius = 5
        tost.view.textColor = UIColor.white
        tost.start()
    }
    
    func getAttributedText(fullText: String, highlightedText: String, highlightedFont: UIFont, highlightedColor: UIColor) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: fullText)
        
        if let range = fullText.range(of: highlightedText) {
            let nsRange = NSRange(range, in: fullText)
            // Apply both font and color to the highlighted text
            attributedString.addAttributes([
                .font: highlightedFont,
                .foregroundColor: highlightedColor
            ], range: nsRange)
        }
        
        return attributedString
    }
    func formattedMinimumRate(from amount: String?) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = Locale(identifier: "en_US")
        guard let amountString = amount, let value = Double(amountString) else {
            return "0.00"
        }
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        
        if let formattedString = numberFormatter.string(from: NSNumber(value: value)) {
            return formattedString
        }
        return "0.00"
    }


    func formattedMinimu(from amount: Float?) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = Locale(identifier: "en_US")
        
        let value = Double(amount ?? 0)
        
        // Check if the value is a whole number
        if value == floor(value) {
            // If it's a whole number, we can avoid showing decimals
            numberFormatter.minimumFractionDigits = 0
            numberFormatter.maximumFractionDigits = 0
        } else {
            // If it's a floating-point number, we ensure two decimals
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 2
        }
        
        if let formattedString = numberFormatter.string(from: NSNumber(value: value)) {
            return formattedString
        }
        
        return "0.00"
    }

    func formattedAmount(from amount: Double?) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = Locale(identifier: "en_US")
        
        // Use the Double value directly, with a default of 0.0 if nil
        let value = amount ?? 0.0
        
        // Check if the value is a whole number
        if value == floor(value) {
            // If it's a whole number, we can avoid showing decimals
            numberFormatter.minimumFractionDigits = 0
            numberFormatter.maximumFractionDigits = 0
        } else {
            // If it's a floating-point number, we ensure two decimals
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 2
        }
        
        // Format the number and return as a string
        if let formattedString = numberFormatter.string(from: NSNumber(value: value)) {
            return formattedString
        }
        
        return "0.00"
    }


    func convertDateString(inputDateString: String, inputDateFormat: String, outputDateFormat: String) -> String? {
        // Step 1: Create a DateFormatter to parse the original string
        let originalDateFormatter = DateFormatter()
        originalDateFormatter.dateFormat = inputDateFormat
        originalDateFormatter.timeZone = TimeZone.current // Adjust timezone if necessary

        // Step 2: Convert the string to a Date object
        if let date = originalDateFormatter.date(from: inputDateString) {
            
            // Step 3: Create a new DateFormatter for the desired output format
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = outputDateFormat
            outputDateFormatter.locale = Locale(identifier: "en_US") // You can change this to a different locale if necessary
            
            // Step 4: Convert the Date object to the desired format
            let formattedDate = outputDateFormatter.string(from: date)
            return formattedDate
        } else {
            print("Invalid date format")
            return nil
        }
    }
    func removeSpecialCharacters(from string: String) -> String {
        let cleanedString = string.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        return cleanedString
    }
    
    func backController() {
          let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
          self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true)
      }
    func backTwoController() {
          let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
          self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
      }
//    func backControllerOne() {
//        guard let nav = self.navigationController else { return }
//        let viewControllers = nav.viewControllers
//
//        if viewControllers.count >= 2 {
//            nav.popToViewController(viewControllers[viewControllers.count - 2], animated: true)
//        } else {
//            // No previous screen — decide what to do here
//            // e.g., navigate to ProfileSelectionVC or dismiss
//            let profileVC = ProfileSelectionVC.instantiate(fromAppStoryboard: .Main)
//            let nc = UINavigationController(rootViewController: profileVC)
//            nc.isNavigationBarHidden = true
//            let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
//            sceneDelegate.window!.rootViewController = nc
//            sceneDelegate.window!.makeKeyAndVisible()
//        }
//    }

}


extension UINavigationController {
    func previousViewController() -> UIViewController?{
        let lenght = self.viewControllers.count
        let previousViewController: UIViewController? = lenght >= 2 ? self.viewControllers[lenght-2] : nil
        return previousViewController
    }
    
    func secondPreviousViewController() -> UIViewController?{
        let lenght = self.viewControllers.count
        
        let previousViewController: UIViewController? = lenght >= 3 ? self.viewControllers[lenght-3] : nil
        return previousViewController
    }
    
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
          if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(vc, animated: animated)
          }
    }
    
}


