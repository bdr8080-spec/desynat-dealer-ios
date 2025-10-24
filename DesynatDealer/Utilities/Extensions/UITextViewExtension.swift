//
//  UITextViewExtension.swift
//  Altair
//
//  Created by Rakhi Kumari on 23/09/25.
//

import UIKit

private var kPlaceholderLabelKey: UInt8 = 0

extension UITextView: UITextViewDelegate {
    
    @IBInspectable var placeholderTextView: String? {
        get {
            return placeholderLabel?.text
        }
        set {
            if let newValue = newValue {
                if placeholderLabel == nil {
                    let label = UILabel()
                    label.textColor = UIColor.lightGray
                    label.numberOfLines = 0
                    label.font = self.font
                    label.translatesAutoresizingMaskIntoConstraints = false
                    addSubview(label)
                    
                    // Constraints
                    NSLayoutConstraint.activate([
                        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
                        label.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
                        label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5)
                    ])
                    
                    placeholderLabel = label
                    self.delegate = self
                }
                placeholderLabel?.text = newValue
                placeholderLabel?.isHidden = !text.isEmpty
            }
        }
    }
    
    private var placeholderLabel: UILabel? {
        get { return objc_getAssociatedObject(self, &kPlaceholderLabelKey) as? UILabel }
        set { objc_setAssociatedObject(self, &kPlaceholderLabelKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        placeholderLabel?.isHidden = !text.isEmpty
    }
}
