//
//  GradientCalendarCell.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 13/02/26.
//


import UIKit
import FSCalendar

class GradientCalendarCell: FSCalendarCell {

    private let gradientLayer = CAGradientLayer()
    private let circleView = UIView()

    override init!(frame: CGRect) {
        super.init(frame: frame)
        setupCircle()
        setupGradient()
    }

    required init!(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        setupCircle()
        setupGradient()
    }

    private func setupCircle() {
        circleView.backgroundColor = .clear
        circleView.isHidden = true
        contentView.insertSubview(circleView, at: 0)
    }

    private func setupGradient() {
        gradientLayer.colors = [
            UIColor(hexString: "#DFBF8F").cgColor,
            UIColor(hexString: "#6E4527").cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        circleView.layer.insertSublayer(gradientLayer, at: 0)
    }

//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        // FSCalendar uses titleLabel size as reference
//        let diameter = min(bounds.width, bounds.height) * 0.9
//        let x = (bounds.width - diameter) / 2
//        let y = (bounds.height - diameter) / 2
//
//        circleView.frame = CGRect(x: x, y: y, width: diameter, height: diameter)
//        circleView.layer.cornerRadius = diameter / 2
//        circleView.clipsToBounds = true
//
//        gradientLayer.frame = circleView.bounds
//        gradientLayer.cornerRadius = diameter / 2
//    }
  
  override func layoutSubviews() {
      super.layoutSubviews()

      guard let titleLabel = titleLabel else { return }

      // FSCalendar's titleLabel is the true center
      let diameter = titleLabel.frame.width - 6// + 6

      circleView.frame = CGRect(
          x: titleLabel.frame.midX - diameter / 2,
          y: titleLabel.frame.midY - diameter / 2,
          width: diameter,
          height: diameter
      )

      circleView.layer.cornerRadius = diameter / 2
      circleView.clipsToBounds = true

      gradientLayer.frame = circleView.bounds
      gradientLayer.cornerRadius = diameter / 2
  }


    override var isSelected: Bool {
        didSet {
            circleView.isHidden = !isSelected
            titleLabel.textColor = isSelected ? .white : .black
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        circleView.isHidden = true
        titleLabel.textColor = .black
    }
}
