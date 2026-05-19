//
//  ArabicTextField.swift
//  DesynatDealer
//
//  Created by fluper_mac2 on 19/05/26.
//


import UIKit

class ArabicTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupArabicStyle()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupArabicStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupArabicStyle()
    }
    
    private func setupArabicStyle() {
        
        textAlignment = .right
        semanticContentAttribute = .forceRightToLeft
        
        autocorrectionType = .no
        spellCheckingType = .no
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: 10, dy: 0)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: 10, dy: 0)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: 10, dy: 0)
    }
}
