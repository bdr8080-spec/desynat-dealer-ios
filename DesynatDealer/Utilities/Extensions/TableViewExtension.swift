//
//  TableViewExtension.swift
//  DemoProject
//
//  Created by Rakhi Kumari on 22/09/25.
//


import UIKit

extension UITableView {

    func registerCellFromNib(cellID: String) {
        self.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
    }

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .darkGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel
    }

    func restore() { self.backgroundView = nil }
}

extension UITableViewCell {
    func setColorBox(size: String, label: UILabel, hexColor: String, quantity: String) {
        
        // Use this square → fully tintable solid square
        let coloredSquare = "■"
        let dot = "●"
        let text = "Size".localiz()
        let text1 = "Color:".localiz()
        let text2 = "Qnt:".localiz()
        let fullText = "\(text) \(size)  \(dot)  \(text1) \(coloredSquare)  \(dot)  \(text2) \(quantity)"
        
        let attributedString = NSMutableAttributedString(
            string: fullText,
            attributes: [
                .font: UIFont(name: "Poppins-Light", size: 10.0) ?? UIFont.systemFont(ofSize: 10)
            ]
        )
        
        let grayColor = UIColor(hexString: "#D9D9D9") //?? UIColor.gray
        let nsText = fullText as NSString
        
        // Gray dots
        var searchRange = NSRange(location: 0, length: nsText.length)
        while true {
            let range = nsText.range(of: dot, options: [], range: searchRange)
            if range.location == NSNotFound { break }
            attributedString.addAttribute(.foregroundColor, value: grayColor, range: range)
            
            let nextLoc = range.location + range.length
            searchRange = NSRange(location: nextLoc, length: nsText.length - nextLoc)
        }
        
        // Colored square with API color + slightly larger
        if let productColor = UIColor(hexStringBox: hexColor) {
            let squareRange = nsText.range(of: coloredSquare)
            if squareRange.location != NSNotFound {
                attributedString.addAttribute(.foregroundColor, value: productColor, range: squareRange)
                // Make the square pop (bigger + medium weight)
                attributedString.addAttribute(.font, value: UIFont(name: "Poppins-Medium", size: 11) ?? UIFont.systemFont(ofSize: 11, weight: .medium), range: squareRange)
            }
        }
        
        label.attributedText = attributedString
    }
    
    func setColorBoxWithoutQuantity(size: String, label: UILabel, hexColor: String) {
        
        // Use this square → fully tintable solid square
        let coloredSquare = "■"
        let dot = "●"
        let text = "Size".localiz()
        let text1 = "Color:".localiz()
        let fullText = "\(text) \(size)  \(dot)  \(text1) \(coloredSquare)"
        
        let attributedString = NSMutableAttributedString(
            string: fullText,
            attributes: [
                .font: UIFont(name: "Poppins-Light", size: 10.0) ?? UIFont.systemFont(ofSize: 10)
            ]
        )
        
        let grayColor = UIColor(hexString: "#D9D9D9") //?? UIColor.gray
        let nsText = fullText as NSString
        
        // Gray dots
        var searchRange = NSRange(location: 0, length: nsText.length)
        while true {
            let range = nsText.range(of: dot, options: [], range: searchRange)
            if range.location == NSNotFound { break }
            attributedString.addAttribute(.foregroundColor, value: grayColor, range: range)
            
            let nextLoc = range.location + range.length
            searchRange = NSRange(location: nextLoc, length: nsText.length - nextLoc)
        }
        
        // Colored square with API color + slightly larger
        if let productColor = UIColor(hexStringBox: hexColor) {
            let squareRange = nsText.range(of: coloredSquare)
            if squareRange.location != NSNotFound {
                attributedString.addAttribute(.foregroundColor, value: productColor, range: squareRange)
                // Make the square pop (bigger + medium weight)
                attributedString.addAttribute(.font, value: UIFont(name: "Poppins-Medium", size: 11) ?? UIFont.systemFont(ofSize: 11, weight: .medium), range: squareRange)
            }
        }
        
        label.attributedText = attributedString
    }
}

extension UIColor {
    convenience init?(hexStringBox: String) {
        var hexFormatted = hexStringBox.trimmingCharacters(in: .whitespacesAndNewlines)
        hexFormatted = hexFormatted.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgb)
        
        let r = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let g = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let b = CGFloat(rgb & 0xFF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
  
  convenience init(hexString: String) {
      
      let hexString: String       = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
      let scanner                 = Scanner(string: hexString as String)
      
      if hexString.hasPrefix("#") {
          scanner.scanLocation = 1
      }
      var color: UInt32 = 0
      scanner.scanHexInt32(&color)
      
      let mask = 0x000000FF
      let r = Int(color >> 16) & mask
      let g = Int(color >> 8) & mask
      let b = Int(color) & mask
      
      let red   = CGFloat(r) / 255.0
      let green = CGFloat(g) / 255.0
      let blue  = CGFloat(b) / 255.0
      self.init(red:red, green:green, blue:blue, alpha:1)
  }
}

