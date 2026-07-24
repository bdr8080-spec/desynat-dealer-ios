//
//  StorieTopSliderCollectionViewCell.swift
//  DesynatUser
//
//  Created by fluper_mac3 on 27/03/26.
//

import UIKit

class StorieTopSliderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var progressBackgroundView: UIView!
    @IBOutlet weak var progressFillView: UIView!
    @IBOutlet weak var progressFillWidthConstraint: NSLayoutConstraint!
    
    private var totalWidth: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        progressBackgroundView.semanticContentAttribute = .forceLeftToRight
    }
    
    private func setupUI() {
        // Default background for unused progress
        progressBackgroundView.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        progressBackgroundView.layer.cornerRadius = 2
        progressBackgroundView.clipsToBounds = true
        
        // Fill bar
        progressFillView.backgroundColor = .white
        progressFillView.layer.cornerRadius = 2
        
        progressFillWidthConstraint.constant = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        totalWidth = progressBackgroundView.bounds.width
    }
    
    func configure(isActive: Bool, isSeen: Bool, progress: CGFloat = 0.0) {

        if totalWidth == 0 {
            totalWidth = progressBackgroundView.bounds.width
        }

        // 1️⃣ Seen stories (previous stories)
        if isSeen && !isActive {
            progressBackgroundView.backgroundColor = .white
            progressFillView.backgroundColor = .white
            progressFillWidthConstraint.constant = totalWidth
            return
        }

        // 2️⃣ Active story (animating)
        if isActive {
            progressBackgroundView.backgroundColor = UIColor.white.withAlphaComponent(0.25)

            let newWidth = totalWidth * max(0, min(1, progress))
            progressFillWidthConstraint.constant = newWidth

            UIView.animate(withDuration: 0.05, delay: 0, options: .curveLinear) {
                self.layoutIfNeeded()
            }
            return
        }

        // 3️⃣ Future stories
        progressBackgroundView.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        progressFillView.backgroundColor = .white
        progressFillWidthConstraint.constant = 0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        progressFillWidthConstraint.constant = 0
        progressBackgroundView.backgroundColor = UIColor.white.withAlphaComponent(0.25)
    }
}
