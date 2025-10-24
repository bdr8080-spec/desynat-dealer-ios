//
//  tableViewDynamicHeight.swift
//  MultiTaxiUSer
//
//  Created by Vriddhi on 20/03/23.
//

import UIKit

class TableViewDynamicHeight: UITableView {
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }
    override var contentSize: CGSize { didSet { self.invalidateIntrinsicContentSize() } }
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
}

class CollViewAdjustedHeight : UICollectionView {
    
    override func layoutSubviews() {
       super.layoutSubviews()
       if !__CGSizeEqualToSize(bounds.size,self.intrinsicContentSize){
         self.invalidateIntrinsicContentSize()
       }
     }
    
     override var intrinsicContentSize: CGSize {
       return contentSize
     }
    
    override func reloadData() {
        super.reloadData()
        self.collectionViewLayout.invalidateLayout()
        self.invalidateIntrinsicContentSize()
    }
}
