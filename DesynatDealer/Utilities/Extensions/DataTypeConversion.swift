//  BasicSetupProject
//
//  Created by Developer on 02/12/23.
//


import Foundation

extension NSNumber {
    
    /// Get NSNumber from anyObject, returns 0 if nil
    /// - Parameter value: AnyObject
    /// - Returns: NSNumber
    static func getNSNumber(_ value: Any?) -> NSNumber {
        guard let number = value as? NSNumber else {
            guard let strNumber = value as? String else {
                return 0
            }
            guard let intNumber = Int(strNumber) else {
                guard let doubleNumber = Double(strNumber) else {
                    return 0
                }
                return NSNumber(value: Double(doubleNumber))
            }
            return NSNumber(value: Int(intNumber))
        }
        return number
    }
}

extension Double {
    
    /// Get Double from anyObject, returns 0.0 if nil
    /// - Parameter value: AnyObject
    /// - Returns: Double
    static func getDouble(_ value: Any?) -> Double {
        guard let dblValue = value as? Double else {
            guard let strDouble = value as? String else{
                return 0.0
            }
            return Double(strDouble) ?? 0.0
        }
        return dblValue
    }
    
    func rounded(toPlaces places:Int) -> Decimal {
        let divisor = pow(10.0, Double(places))
        let divide = (self * divisor).rounded(.toNearestOrAwayFromZero)
        return Decimal(divide / divisor)
    }
}

extension Int {
    
    /// Get Int from anyObject, returns 0 if nil
    /// - Parameter value: AnyObject
    /// - Returns: Int
    static func getInt(_ value: Any?) -> Int {
        guard let intValue = value as? Int else {
            let strInt = String.getString(value)
            guard let intValueOfString = Int(strInt) else { return 0 }
            return intValueOfString
        }
        return intValue
    }
    
    static func parse(from input: String) -> Int? {
        do {
            let regex = try NSRegularExpression(pattern: "\\d+", options: .caseInsensitive)
            let range = NSRange(input.startIndex..., in: input)
            if let match = regex.firstMatch(in: input, options: [], range: range) {
                if let numberRange = Range(match.range, in: input),
                   let number = Int(input[numberRange]) {
                    return number
                }
            }
            return nil
        } catch {
//            print("Error creating regex: \(error)")
            return nil
        }
    }
    
    /// returns number of digits in Int number
    public var digitCount: Int {
        get {
            return numberOfDigits(in: self)
        }
    }
    /// returns number of useful digits in Int number
    public var usefulDigitCount: Int {
        get {
            var count = 0
            for digitOrder in 0..<self.digitCount {
                /// get each order digit from self
                let digit = self % (Int(truncating: pow(10, digitOrder + 1) as NSDecimalNumber))
                / Int(truncating: pow(10, digitOrder) as NSDecimalNumber)
                if isUseful(digit) { count += 1 }
            }
            return count
        }
    }
    
    // private recursive method for counting digits
    private func numberOfDigits(in number: Int) -> Int {
        if number < 10 && number >= 0 || number > -10 && number < 0 {
            return 1
        } else {
            return 1 + numberOfDigits(in: number/10)
        }
    }
    // returns true if digit is useful in respect to self
    private func isUseful(_ digit: Int) -> Bool {
        return (digit != 0) && (self % digit == 0)
    }
}

extension String {
    
    /// Get String from anyObject, returns " " if nil
    /// - Parameter value: AnyObject
    /// - Returns: String
    static func getString(_ value: Any?) -> String {
        guard let strMessage = value as? String else {
            guard let doubleValue = value as? Double else {
                guard let intValue = value as? Int else {
                    guard let int64Value = value as? Int64 else { return "" }
                    return String(int64Value)
                }
                return String(intValue)
            }
            
            let formatter                     = NumberFormatter()
            formatter.minimumFractionDigits   = 0
            formatter.maximumFractionDigits   = 2
            formatter.minimumIntegerDigits    = 1
            guard let formattedNumber = formatter.string(from: NSNumber(value: doubleValue)) else {
                return ""
            }
            return formattedNumber
        }
        return strMessage.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
