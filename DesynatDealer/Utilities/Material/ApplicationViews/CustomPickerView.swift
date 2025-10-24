//
//  CustomPickerView.swift
//  CruzeUserApp
//
//  Created by LoveKush Yadav on 13/02/25.
//

import Foundation
import UIKit

protocol CustomPickerViewDelegate: AnyObject {
    func didSelectOption(_ option: String)
}

class CustomPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {

    var didSelectItem: ((Int) -> Void)?
    var data: [Int] = [] {
        didSet {
            reloadAllComponents()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }

    private func commonSetup() {
        delegate = self
        dataSource = self
    }

    // MARK: - UIPickerViewDataSource and UIPickerViewDelegate methods

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(data[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            var customLabel: CustomPickerLabel

            if let reusedView = view as? CustomPickerLabel {
                customLabel = reusedView
            } else {
                customLabel = CustomPickerLabel()
            }
            pickerView.subviews[1].alpha = 0
            customLabel.font = UIFont(name: "Almarai-Bold", size: 20)
            customLabel.text = "\(data[row])"
            customLabel.textAlignment = .center

            return customLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedValue = data[row]
        didSelectItem?(selectedValue)
      //  delegate?.didSelectOption(selectedValue)
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0 // Set the row height to 50
    }
}

class CustomPickerLabel: UILabel {
    override var intrinsicContentSize: CGSize {
        let originalSize = super.intrinsicContentSize
        return CGSize(width: originalSize.width + 20, height: originalSize.height)
    }
}
