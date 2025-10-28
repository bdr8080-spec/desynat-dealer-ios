//
//  String.swift
//  ChorApp
//
//  Created by Developer on 21/12/23.
//

import Foundation

extension Collection {
    func subSequences(limitedTo maxLength: Int) -> [SubSequence] {
        precondition(maxLength > 0, "groups must be greater than zero")
        return .init(sequence(state: startIndex) { start in
            guard start < self.endIndex else { return nil }
            let end = self.index(start, offsetBy: maxLength, limitedBy: self.endIndex) ?? self.endIndex
            defer { start = end }
            return self[start..<end]
        })
    }
    var pairs: [SubSequence] { subSequences(limitedTo: 2) }
}

extension String {
    func endsWithString(_ string: String) -> Bool {
        guard self.count >= string.count else { return false }
        let index = self.index(startIndex, offsetBy: self.count - string.count)
        let substring = self.substring(from: index)
        return substring == string
    }
    
    func isPhoneNumber(minDigit:Int=7,maxDigit:Int = 15) -> Bool {
        if self.isStringEmpty() {
            return false
        }
        let phoneRegex = "^\\d{\(minDigit),\(maxDigit)}$"
        let phoneText = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        let isValid = phoneText.evaluate(with: self) as Bool
        return isValid
    }
    
    func isValidPhoneNumber() -> Bool {
        // Remove all non-digit characters
        let digitsOnly = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        // Check if digit count is between 7 and 15
        return digitsOnly.count >= 7 && digitsOnly.count <= 15
    }
    
    //    func isPhoneNumber() -> Bool {
    //        if self.isStringEmpty() {
    //            return false
    //        }
    //        let phoneRegex = "^\\d{10}$"
    //        let phoneText = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
    //        let isValid = phoneText.evaluate(with: self) as Bool
    //        return isValid
    //    }
    
    func isStringEmpty() -> Bool {
        return self.stringByTrimmingWhiteSpace().count == 0 ? true : false
    }
    
    func stringByTrimmingWhiteSpace() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    func isEmail() -> Bool {
        let emailRegex = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@" + "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,4})$" as String
        let emailText = NSPredicate(format: "SELF MATCHES %@",emailRegex)
        let isValid  = emailText.evaluate(with: self) as Bool
        return isValid
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        // Minimum 8 characters, at least 1 uppercase, 1 lowercase, and 1 special character
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*(),.?\":{}|<>]).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    func isNumber() -> Bool {
        if self.isStringEmpty() {
            return false
        }
        let digitsCharacters = CharacterSet(charactersIn: "0123456789")
        return CharacterSet(charactersIn: self).isSubset(of: digitsCharacters)
    }
}

extension String {
    /// Converts ISO8601 string (with or without fractional seconds) to Date
    func toDate() -> Date? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC
        if let date = isoFormatter.date(from: self) {
            // Return date at start of day in local timezone
            return Calendar.current.startOfDay(for: date)
        }
        
        // fallback: try without fractional seconds
        isoFormatter.formatOptions = [.withInternetDateTime]
        return isoFormatter.date(from: self).map { Calendar.current.startOfDay(for: $0) }
    }
}
