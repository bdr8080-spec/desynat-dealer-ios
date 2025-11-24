import Foundation
import UIKit

struct StringValidation {
    let string: String
    var count: Int
    var validation: Validation
    
    init(string: String, characterCount: Int, validation: Validation) {
        self.string = string
        self.count = characterCount
        self.validation = validation
    }
    
    func validate() -> Bool {
        if (validation.matchCharacter.isEmpty) {
            return true
        } else {
            if (self.string.count > count) {
                return false
            }
            return self.matchCharacters(string, matchCharacters: validation.matchCharacter)
        }
    }
    
    enum Validation {
        case none, firstName, lastName, mobileNo, tableName, packageName,
             time, cardExpiration, cvv, bankName, accountNo, accountHolderName, emailId, bankCode,
             cost, noBookings, password, agencyName, managerCode, unitNumber, buildingName, dewaNo, area, specialRequest
        
        var matchCharacter: String {
            switch self {
            case .none :
                return ""
            case .firstName:
                return MatchCharacterConstant.capitalAlphabet + MatchCharacterConstant.smallAlphabet + " "
            case .lastName:
                return MatchCharacterConstant.capitalAlphabet + MatchCharacterConstant.smallAlphabet
            case .mobileNo, .accountNo, .cvv, .cost, .noBookings, .dewaNo:
                return MatchCharacterConstant.number
            case .accountHolderName:
                return MatchCharacterConstant.capitalAlphabet + MatchCharacterConstant.smallAlphabet + " "
            case .emailId:
                return MatchCharacterConstant.capitalAlphabet + MatchCharacterConstant.smallAlphabet + "@._" + MatchCharacterConstant.number
            case .bankCode:
                return MatchCharacterConstant.capitalAlphabet + MatchCharacterConstant.smallAlphabet + MatchCharacterConstant.number
            case .password:
                return MatchCharacterConstant.capitalAlphabet + MatchCharacterConstant.smallAlphabet + MatchCharacterConstant.number + MatchCharacterConstant.spacialCharacter
            case .bankName:
                return MatchCharacterConstant.capitalAlphabet + MatchCharacterConstant.smallAlphabet + " "
            case .time :
                return MatchCharacterConstant.timing
            case .cardExpiration:
                return MatchCharacterConstant.cardExpiration
            case .tableName,.packageName:
                return MatchCharacterConstant.number + MatchCharacterConstant.smallAlphabet + MatchCharacterConstant.spacialCharacter + MatchCharacterConstant.capitalAlphabet + " "
            case .agencyName, .buildingName, .area, .specialRequest:
                return MatchCharacterConstant.capitalAlphabet + MatchCharacterConstant.smallAlphabet + " "
                
            case .managerCode, .unitNumber:
                return MatchCharacterConstant.capitalAlphabet + MatchCharacterConstant.smallAlphabet + MatchCharacterConstant.number
            }
        }
    }
    
    func matchCharacters(_ string: String, matchCharacters characters: String) -> Bool {
        let cs = NSCharacterSet(charactersIn: characters).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        return (string == filtered)
    }
}

extension UIColor {
    convenience init?(hex: String) {
        var hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted.remove(at: hexFormatted.startIndex)
        }

        guard hexFormatted.count == 6,
              let rgbValue = UInt64(hexFormatted, radix: 16) else { return nil }

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255,
            blue: CGFloat(rgbValue & 0x0000FF) / 255,
            alpha: 1.0
        )
    }
}
