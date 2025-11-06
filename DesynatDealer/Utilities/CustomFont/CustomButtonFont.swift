//
//  CustomButtonFont.swift
//  PerSquareFeetDealerApp
//
//  Created by Riya on 03/07/25.
//

import UIKit

@IBDesignable
class CustomButtonFont: UIButton {
    
    /// Set this in storyboard using values like: "mon", "alt", "a", "montserrat", "alternates"
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyCustomFont()
    }
    
    // MARK: Font Logic
    
    private func updateFontFamily(from name: String) {
        fontFamily = FontFamily.from(input: name)
        // Optional logging
        //print("✅ Font family for button: \(fontFamily)")
    }
    
    private func applyCustomFont() {
        guard let currentFont = titleLabel?.font else { return }
        let pointSize = currentFont.pointSize
        let weight = currentFont.weight
        let fontName = fontFamily.fontName(for: weight)
        
        if let customFont = UIFont(name: fontName, size: pointSize) {
            titleLabel?.font = customFont
        } else {
            //print("⚠️ Font '\(fontName)' not found. Check that it's in the project and Info.plist.")
        }
    }
}
