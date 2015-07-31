//
//  BubblyLayout.swift
//  BubblyViewController
//
//  Created by David Johnson on 7/31/15.
//  Copyright (c) 2015 David Johnson. All rights reserved.
//

import UIKit

class BubblyLayout: UICollectionViewLayout {
    var dynamicAnimator: UIDynamicAnimator?
    var collisionBehavior: UICollisionBehavior?
    var dynamicItemBehavior: UIDynamicItemBehavior?
    
    let kItemSize = 80
    
    override init() {
        super.init()
        dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
        
        dynamicItemBehavior = UIDynamicItemBehavior(items: [])
        dynamicItemBehavior?.allowsRotation = false
        dynamicItemBehavior?.friction = 0.2
        dynamicItemBehavior?.elasticity = 0.4
        dynamicAnimator?.addBehavior(dynamicItemBehavior)
        
        collisionBehavior = UICollisionBehavior(items: [])
        dynamicAnimator?.addBehavior(collisionBehavior)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        prepareLayout()
    }
    
    override func prepareForCollectionViewUpdates(updateItems: [AnyObject]!) {
        super.prepareForCollectionViewUpdates(updateItems)
        
        let attachAnchor = CGPointMake(collectionViewContentSize().width / 2, CGRectGetMidY(self.collectionView!.bounds))
        
        for item in updateItems as! [UICollectionViewUpdateItem] {
            if item.updateAction == UICollectionUpdateAction.Insert {
                var attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: item.indexPathAfterUpdate!)
                
                let randomX = self.collectionView!.frame.maxX + CGFloat(arc4random_uniform(50))
                let randomY = self.collectionView!.frame.midY + CGFloat(arc4random_uniform(20)) - CGFloat(arc4random_uniform(20))
                
                attributes.frame = CGRectMake(CGFloat(randomX), CGFloat(randomY), 100, 100)
                
                var attachmentBehavior = UIAttachmentBehavior(item: attributes, attachedToAnchor: attachAnchor)
                attachmentBehavior.length = 0.0;
                attachmentBehavior.damping = 0.7;
                attachmentBehavior.frequency = 0.5;
                
                dynamicAnimator?.addBehavior(attachmentBehavior)
                collisionBehavior?.addItem(attributes)
                dynamicItemBehavior?.addItem(attributes)
            }
        }
    }
    
    override func prepareLayout() {
        super.prepareLayout()
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        return dynamicAnimator?.itemsInRect(rect)
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        return dynamicAnimator?.layoutAttributesForCellAtIndexPath(indexPath)
    }
    
    override func collectionViewContentSize() -> CGSize {
        if let cv = collectionView {
            return CGSizeMake(500, cv.frame.size.height - cv.contentInset.top);
        }
        
        return CGSizeMake(1000, 1000)
    }
}