//
//  UILabelExtension.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 26/03/26.
//

import Foundation
import UIKit

extension UILabel {
    func setSecureText(_ text: String) {
        self.text = String(repeating: "•", count: text.count)
    }
}


