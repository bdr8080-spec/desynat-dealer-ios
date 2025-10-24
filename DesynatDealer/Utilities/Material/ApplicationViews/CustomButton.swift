//
//  CustomView.swift
//  ChorApp
//
//  Created by Developer on 19/12/23.
//

import UIKit

class CustomButton: UIButton {

    @IBInspectable
    /// Should the corner be as circle
    public var circleCorner: Bool {
        get {
            return min(bounds.size.height, bounds.size.width) / 2 == cornerRadius
        }set {
            cornerRadius = newValue ? min(bounds.size.height, bounds.size.width) / 2 : cornerRadius
        }
    }
    @IBInspectable
    /// Corner radius of view; also inspectable from Storyboard.
    public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        } set {
            layer.cornerRadius = circleCorner ? min(bounds.size.height, bounds.size.width) / 2 : newValue
        }
    }
    @IBInspectable
    /// Border color of view; also inspectable from Storyboard.
    public var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            layer.borderColor = color.cgColor
        }
    }
    
    @IBInspectable
    /// Border width of view; also inspectable from Storyboard.
    public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        } set {
            layer.borderWidth = newValue
        }
    }
    @IBInspectable
    /// Shadow color of view; also inspectable from Storyboard.
    public var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: color)
        } set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    @IBInspectable
    /// Shadow offset of view; also inspectable from Storyboard.
    public var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        } set {
            layer.shadowOffset = newValue
        }
    }
    @IBInspectable
    /// Shadow opacity of view; also inspectable from Storyboard.
    public var shadowOpacity: Double {
        get {
            return Double(layer.shadowOpacity)
        } set {
            layer.shadowOpacity = Float(newValue)
        }
    }
    @IBInspectable
    /// Shadow radius of view; also inspectable from Storyboard.
    public var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        } set {
            layer.shadowRadius = newValue
        }
    }
    @IBInspectable
    /// Shadow path of view; also inspectable from Storyboard.
    public var shadowPath: CGPath? {
        get {
            return layer.shadowPath
        } set {
            layer.shadowPath = newValue
        }
    }
    @IBInspectable
    /// Should shadow rasterize of view; also inspectable from Storyboard.
    /// cache the rendered shadow so that it doesn't need to be redrawn
    public var shadowShouldRasterize: Bool {
        get {
            return layer.shouldRasterize
        } set {
            layer.shouldRasterize = newValue
        }
    }
    @IBInspectable
    /// Should shadow rasterize of view; also inspectable from Storyboard.
    /// cache the rendered shadow so that it doesn't need to be redrawn
    public var shadowRasterizationScale: CGFloat {
        get {
            return layer.rasterizationScale
        } set {
            layer.rasterizationScale = newValue
        }
    }
    @IBInspectable
    /// Corner radius of view; also inspectable from Storyboard.
    public var maskToBounds: Bool {
        get {
            return layer.masksToBounds
        } set {
            layer.masksToBounds = newValue
        }
    }
    
    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }

    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        return gradient
    }
}
