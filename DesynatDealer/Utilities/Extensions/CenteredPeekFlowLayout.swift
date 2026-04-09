//
//  CenteredPeekFlowLayout.swift
//  DesynatDealer
//
//  Created by fluper_mac3 on 09/04/26.
//


import UIKit

class CenteredFlowLayout: UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        let parent = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        let collectionCenter = collectionView.bounds.width / 2.0
        let proposedCenterX = proposedContentOffset.x + collectionCenter
        
        // Fixed: Manual rect creation (standard pattern)
        let rect = CGRect(
            x: proposedContentOffset.x,
            y: 0,
            width: collectionView.bounds.width,
            height: collectionView.bounds.height
        )
        guard let attributesArray = layoutAttributesForElements(in: rect) else {
            return parent
        }
        
        var closestAttribute: UICollectionViewLayoutAttributes?
        var distance = CGFloat.greatestFiniteMagnitude
        
        for attributes in attributesArray {
            let cellAttributesDistance = abs(attributes.center.x - proposedCenterX)
            if cellAttributesDistance < distance {
                closestAttribute = attributes
                distance = cellAttributesDistance
            }
        }
        
        var targetOffset = CGPoint(x: closestAttribute!.center.x - collectionCenter, y: parent.y)
        
        // Center last cell if near end
        let totalItems = collectionView.numberOfItems(inSection: 0)
        if totalItems > 0 {
            let lastIndexPath = IndexPath(item: totalItems - 1, section: 0)
            if let lastAttributes = layoutAttributesForItem(at: lastIndexPath) {
                let lastCellDistance = abs(lastAttributes.center.x - proposedCenterX)
                if lastCellDistance < collectionCenter {
                    targetOffset.x = lastAttributes.center.x - collectionCenter
                }
            }
        }
        
        // Clamp bounds
        let maxOffset = max(0, collectionView.contentSize.width - collectionView.bounds.width)
        targetOffset.x = max(0, min(targetOffset.x, maxOffset))
        
        return targetOffset
    }
}
