//
//  AppFont.swift
//  PerSquareFeetDealerApp
//
//  Created by Riya on 30/06/25.
//

import UIKit

@IBDesignable
class CustomLabelFont: UILabel {
    
    /// Accepts values like: "mon", "alt", "montserrat", "alternates", etc.
    @IBInspectable var fontFamilyName: String = "" {
        didSet {
            updateFontFamily(from: fontFamilyName)
        }
    }

    private var fontFamily: FontFamily = .montserrat {
        didSet {
            applyCustomFont()
        }
    }

    enum FontFamily {
        case montserrat
        case montserratAlternates
        case nunito
        case poppins

        static func from(input: String) -> FontFamily {
            let normalized = input.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            switch normalized {
            case "alt", "a", "alternates", "montserratalternates":
                return .montserratAlternates
                
            case "nunito", "nun", "n":
                return .nunito
                
            case "pop", "poppins", "p":
                return .poppins
                
            default:
                return .montserrat
            }
        }

        func fontName(for weight: UIFont.Weight) -> String {
            switch self {
            case .montserrat:
                switch weight {
                case .medium: return "Montserrat-Medium"
                case .semibold: return "Montserrat-SemiBold"
                case .bold: return "Montserrat-Bold"
                default: return "Montserrat-Regular"
                }
            case .montserratAlternates:
                switch weight {
                case .medium: return "MontserratAlternates-Medium"
                case .semibold: return "MontserratAlternates-SemiBold"
                case .bold: return "MontserratAlternates-Bold"
                default: return "MontserratAlternates-Regular"
                }
            case .nunito:
                switch weight {
                case .medium: return "Nunito-Medium"
                case .semibold: return "Nunito-SemiBold"
                case .bold: return "Nunito-Bold"
                default: return "Nunito-Regular"
                }
            case .poppins:
                switch weight {
                case .medium: return "Poppins-Medium"
                case .semibold: return "Poppins-SemiBold"
                case .bold: return "Poppins-Bold"
                default: return "Poppins-Regular"
                }
            }
        }
    }

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateFontFamily(from: fontFamilyName)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updateFontFamily(from: fontFamilyName)
    }

    // MARK: Font Handling
    override var font: UIFont! {
        didSet {
            applyCustomFont()
        }
    }

    private func updateFontFamily(from name: String) {
        let selected = FontFamily.from(input: name)
        fontFamily = selected
        // Optional console output for clarity
        //print("✅ Font family selected: \(selected)")
    }

    private func applyCustomFont() {
        let pointSize = font?.pointSize ?? UIFont.labelFontSize
        let weight = font.weight
        let fontName = fontFamily.fontName(for: weight)

        if let customFont = UIFont(name: fontName, size: pointSize) {
            super.font = customFont
        } else {
            //print("⚠️ Font '\(fontName)' not found. Did you add it to the project and Info.plist?")
        }
    }
}

extension UIFont {
    var weight: UIFont.Weight {
        let traits = fontDescriptor.object(forKey: .traits) as? [UIFontDescriptor.TraitKey: Any]
        if let weightValue = traits?[.weight] as? CGFloat {
            return UIFont.Weight(rawValue: weightValue)
        }
        return .regular
    }
}
