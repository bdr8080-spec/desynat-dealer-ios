//
//  CurveView.swift
//  ChorApp
//
//  Created by Developer on 24/12/23.
//

import UIKit

class CurveView: CustomView {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
}
