//
//  RadioBtnCollectionViewCell.swift
//  DesynatDealer
//
//  Created by  shailendra singh on 24/03/26.
//

import UIKit

class RadioBtnCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        updateSelectionState(isSelected: false)
    }
    func updateSelectionState(isSelected: Bool) {
        // Toggle radio button images + background/border
        if isSelected {
            // Selected state
            imageView.image = UIImage(named: "radioSelected" )  // Filled radio selected ✓
        } else {
            // Unselected state
            imageView.image = UIImage( named: "radioUnselected")  // Empty circle ○
        }
    }

}
