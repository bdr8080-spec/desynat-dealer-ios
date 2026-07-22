//
//  DashedBorderView.swift
//  DesynatDealer
//
//  Created by fluper_mac2 on 22/07/26.
//


import UIKit

@IBDesignable
class DashedBorderView: UIView {

    private let dashedLayer = CAShapeLayer()

    @IBInspectable var borderColor: UIColor = UIColor.darkBrown {
        didSet { setNeedsLayout() }
    }

    @IBInspectable var borderWidth: CGFloat = 2 {
        didSet { setNeedsLayout() }
    }

    @IBInspectable var cornerRadius: CGFloat = 16 {
        didSet { setNeedsLayout() }
    }

    @IBInspectable var dashLength: NSNumber = 8 {
        didSet { setNeedsLayout() }
    }

    @IBInspectable var gapLength: NSNumber = 4 {
        didSet { setNeedsLayout() }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true

        dashedLayer.removeFromSuperlayer()

        let path = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: cornerRadius
        )

        dashedLayer.path = path.cgPath
        dashedLayer.fillColor = UIColor.clear.cgColor
        dashedLayer.strokeColor = borderColor.cgColor
        dashedLayer.lineWidth = borderWidth
        dashedLayer.lineDashPattern = [dashLength, gapLength]
        dashedLayer.frame = bounds

        layer.addSublayer(dashedLayer)
    }
}

@IBDesignable
class DashedBorderImageView: UIImageView {

    private let dashedLayer = CAShapeLayer()

    @IBInspectable var borderColor: UIColor = .brown {
        didSet { setNeedsLayout() }
    }

    @IBInspectable var borderWidth: CGFloat = 2 {
        didSet { setNeedsLayout() }
    }

    @IBInspectable var cornerRadius: CGFloat = 16 {
        didSet { setNeedsLayout() }
    }

    @IBInspectable var dashLength: NSNumber = 8 {
        didSet { setNeedsLayout() }
    }

    @IBInspectable var gapLength: NSNumber = 4 {
        didSet { setNeedsLayout() }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true

        dashedLayer.removeFromSuperlayer()

        let path = UIBezierPath(
            roundedRect: bounds.insetBy(dx: borderWidth / 2, dy: borderWidth / 2),
            cornerRadius: cornerRadius
        )

        dashedLayer.path = path.cgPath
        dashedLayer.fillColor = UIColor.clear.cgColor
        dashedLayer.strokeColor = borderColor.cgColor
        dashedLayer.lineWidth = borderWidth
        dashedLayer.lineDashPattern = [dashLength, gapLength]
        dashedLayer.frame = bounds

        layer.addSublayer(dashedLayer)
    }
}
