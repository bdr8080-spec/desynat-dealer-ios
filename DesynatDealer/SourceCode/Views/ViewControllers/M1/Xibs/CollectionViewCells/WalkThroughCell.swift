//
//  WalkThroughCell.swift
//  MultiTaxiUser
//
//  Created by Vriddhi on 29/03/23.
//

import UIKit

class WalkThroughCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageWalk: UIImageView!
    @IBOutlet weak var viewBG:UIView!
    var callBack:(()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.callBack?()
    }
    
    
       
   
}
