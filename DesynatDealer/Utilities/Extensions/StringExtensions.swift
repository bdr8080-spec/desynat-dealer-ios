//
//  StringExtensions.swift
//  DemoProject
//
//  Created by Rakhi Kumari on 22/09/25.
//

import Foundation
import UIKit

extension String {
    
    func trimmed() -> String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func localiz(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
  var toInt: Int? {
    return Int(self.trimmingCharacters(in: .whitespacesAndNewlines))
  }

  var areAllDigits: Bool {
    return !isEmpty && rangeOfCharacter(from: .decimalDigits.inverted) == nil
  }
  
}

