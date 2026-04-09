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
enum GradiantDirection {
    case leftToRight
    case rightToLeft
    case topToBottom
    case bottomToTop
}

extension UIView {
    @discardableResult
    func applyGradient(colours: [UIColor], gradientDirection: GradiantDirection = .leftToRight, cornerRadius:CGFloat = 0.0,corners:CACornerMask = []) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil, gradientDirection:gradientDirection, cornerRadius: cornerRadius,corners: corners)
    }
    
    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?, gradientDirection: GradiantDirection ,cornerRadius:CGFloat = 0.0,corners:CACornerMask) -> CAGradientLayer {
        var gradient: CAGradientLayer = CAGradientLayer()
        
        switch gradientDirection {
        case .topToBottom:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        case .bottomToTop:
            gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        case .leftToRight:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        case .rightToLeft:
            gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        }
        gradient.cornerRadius = cornerRadius
        if (!corners.isEmpty) {
            gradient.maskedCorners = corners
        }
        gradient.opacity = 1
        gradient.frame = self.bounds
        if let firstLayer = self.layer.sublayers?.first(where: {$0 is CAGradientLayer}) as? CAGradientLayer {
            gradient = firstLayer
        } else {
            gradient.colors = colours.map { $0.cgColor }
            gradient.locations = locations
            self.layer.insertSublayer(gradient, at: 0)
        }
        return gradient
    }
    
    func gLayerVisibility(opacity:Float = 1) {
        if let layer = self.layer.sublayers?.first(where:{$0 is CAGradientLayer}) as? CAGradientLayer {
            layer.opacity = opacity
        }
    }
    func containGLayer(opacity:Float = 1) -> Bool {
        if let gLayers = self.layer.sublayers?.filter({$0 is CAGradientLayer}) as? [CAGradientLayer],gLayers.count > 0 {
            return true
        }
        return false
    }
    
    func refreshGLayer() {
        if let glayer = self.layer.sublayers?.first(where: {$0 is CAGradientLayer}) as? CAGradientLayer {
            glayer.frame = self.bounds
            glayer.cornerRadius = glayer.cornerRadius
        }
    }
    func removeGLayer() {
        if let index = self.layer.sublayers?.firstIndex(where: {$0 is CAGradientLayer}) {
            self.layer.sublayers?.remove(at: index)
        }
    }
}
