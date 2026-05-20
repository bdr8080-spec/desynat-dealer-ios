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


class ArabicTextView: UITextView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupArabicStyle()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
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
        
        textContainerInset = UIEdgeInsets(top: 10,
                                          left: 10,
                                          bottom: 10,
                                          right: 10)
    }
}
