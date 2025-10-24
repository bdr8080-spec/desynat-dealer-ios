//
//  CollectionViewExtensio.swift
//  DemoProject
//
//  Created by Rakhi Kumari on 22/09/25.
//

import Foundation
import UIKit

extension UICollectionView {

    func registerCellFromNib(cellID: String) {
        self.register(UINib(nibName: cellID, bundle: nil), forCellWithReuseIdentifier: cellID)
    }

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .darkGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel
    }

    func restore() { self.backgroundView = nil }
}
