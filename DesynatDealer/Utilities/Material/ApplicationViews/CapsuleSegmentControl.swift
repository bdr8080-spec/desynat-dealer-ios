//
//  CapsuleSegmentControl.swift
//  ChorApp
//
//  Created by Developer on 22/12/23.
//

import Foundation
import UIKit

//class CapsuleSegmentControl : UISegmentedControl {
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
//    private let segmentInset: CGFloat = 3
//    private let segmentImage: UIImage? = UIImage(color:  UIColor(named: "themeBlue") ?? .white)
//
//    override func layoutSubviews(){
//        super.layoutSubviews()
//        layer.cornerRadius = 6
//        let foregroundIndex = numberOfSegments
//        if subviews.indices.contains(foregroundIndex), let foregroundImageView = subviews[foregroundIndex] as? UIImageView {
//            foregroundImageView.bounds = foregroundImageView.bounds.insetBy(dx: segmentInset, dy: segmentInset)
//            foregroundImageView.image = segmentImage
//            foregroundImageView.layer.removeAnimation(forKey: "SelectionBounds")
//            foregroundImageView.layer.cornerRadius = 6
//            self.setTitleTextAttributes([.foregroundColor: UIColor.darkGray,
//                                         .font:UIFont.AppFontWith(name: .Montserrat_Regular, size: 12)!], for: .normal)
//            self.setTitleTextAttributes([.foregroundColor: UIColor.white,
//                                         .font:UIFont.AppFontWith(name: .Montserrat_Medium, size: 12)!], for: .selected)
//        }
//        
//    }
//}
