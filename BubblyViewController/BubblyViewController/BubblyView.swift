//
//  BubblyViewController.swift
//  BubblyViewController
//
//  Created by David Johnson on 6/30/15.
//  Copyright (c) 2015 David Johnson. All rights reserved.
//

import Foundation
import UIKit

class BubblyView: UICollectionView, UICollectionViewDelegate {
    let items = ["Electronics", "Entertainment", "Finance", "Food and Drink", "Gifts", "Health & Beauty", "Home", "Home Improvement & Automotive", "Jewelry & Watches", "Kids & Baby", "Men", "Office & Education", "Patio, Lawn & Garden", "Pets", "Shoes", "Sports, Fitness & Camping", "Travel", "Women"]
    
    var displayedItems = [String]()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.lightGrayColor()

        let nib = UINib(nibName: "BubbleCell", bundle: nil)
        registerNib(nib, forCellWithReuseIdentifier: BubbleCell.reuseId())

        dataSource = self
        delegate = self
        
        contentInset = UIEdgeInsetsMake(contentInset.top, 50, contentInset.bottom, 50)
            
        collectionViewLayout = BubblyLayout()
    }

}

extension BubblyView: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedItems.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let layout = (collectionViewLayout as! BubblyLayout)
        var selectedAttributes = layout.dynamicAnimator?.layoutAttributesForCellAtIndexPath(indexPath)
        
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as! BubbleCell
        cell.toggleState()
        selectedAttributes!.bounds = cell.bounds
        
        layout.dynamicAnimator?.updateItemUsingCurrentState(selectedAttributes!)
        
        var behaviors = layout.dynamicAnimator!.behaviors;
        layout.dynamicAnimator?.removeAllBehaviors()
        
        for beh in behaviors {
            layout.dynamicAnimator?.addBehavior(beh as! UIDynamicBehavior)
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var item = items[indexPath.row]
        
        var cell = self.dequeueReusableCellWithReuseIdentifier(BubbleCell.reuseId(), forIndexPath: indexPath) as! BubbleCell
        
        cell.label.text = item
        
        return cell
    }

}

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