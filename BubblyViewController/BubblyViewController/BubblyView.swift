//
//  BubblyViewController.swift
//  BubblyViewController
//
//  Created by David Johnson on 6/30/15.
//  Copyright (c) 2015 David Johnson. All rights reserved.
//

import Foundation
import UIKit

class BubblyView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    let items = ["Electronics", "Entertainment", "Finance", "Food and Drink", "Gifts", "Health & Beauty", "Home", "Home Improvement & Automotive", "Jewelry & Watches", "Kids & Baby", "Men", "Office & Education", "Patio, Lawn & Garden", "Pets", "Shoes", "Sports, Fitness & Camping", "Travel", "Women"]
    
    var displayedItems = [String]()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.lightGrayColor()

        let nib = UINib(nibName: "BubbleCell", bundle: nil)
        registerNib(nib, forCellWithReuseIdentifier: BubbleCell.reuseId())

        dataSource = self
        delegate = self
        var layout = BubblyLayout()
        
        collectionViewLayout = layout
    }
    
    //MARK - DataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedItems.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let layout = (collectionViewLayout as! BubblyLayout)
        var selectedAttributes = layout.dynamicAnimator?.layoutAttributesForCellAtIndexPath(indexPath)
        
        var cell = collectionView.cellForItemAtIndexPath(indexPath)
        (cell as! BubbleCell).toggleState()
        
        selectedAttributes!.bounds = cell!.bounds
        
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
        
        cell.layer.cornerRadius = cell.bounds.width / 2
        return cell
    }
}

class BubblyLayout: UICollectionViewLayout {
    var dynamicAnimator: UIDynamicAnimator?
    var gravityBehavior: UIGravityBehavior?
    var collisionBehavior: UICollisionBehavior?
    var dynamicItemBehavior: UIDynamicItemBehavior?
    
    let kItemSize = 80
    
    override init() {
        super.init()
        dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)

        gravityBehavior = UIGravityBehavior(items: [])
        gravityBehavior?.gravityDirection = CGVectorMake(0, 1)
        gravityBehavior?.magnitude = 0.2
        dynamicAnimator?.addBehavior(gravityBehavior)
        
        dynamicItemBehavior = UIDynamicItemBehavior(items: [])
        dynamicItemBehavior?.allowsRotation = false
        dynamicItemBehavior?.friction = 0.2
        dynamicItemBehavior?.elasticity = 0.2
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
        
        for item in updateItems as! [UICollectionViewUpdateItem] {
            if item.updateAction == UICollectionUpdateAction.Insert {
                var attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: item.indexPathAfterUpdate!)
                
                let lowerX : UInt32 = UInt32(self.collectionView!.frame.minX)
                let upperX : UInt32 = UInt32(self.collectionView!.frame.maxX)
                let randomX = arc4random_uniform(upperX - lowerX) + lowerX
                
                let lowerY : UInt32 = UInt32(self.collectionView!.frame.minY)
                let upperY : UInt32 = UInt32(self.collectionView!.frame.maxY)
                let randomY = arc4random_uniform(upperY - lowerY) + lowerY
            
                attributes.frame = CGRectMake(CGFloat(randomX), CGFloat(randomY), 100, 100)
                
                var attachmentBehavior = UIAttachmentBehavior(item: attributes, attachedToAnchor: CGPointMake(CGRectGetMidX(self.collectionView!.bounds), CGRectGetMidY(self.collectionView!.bounds)))
                attachmentBehavior.length = 0.4;
                attachmentBehavior.damping = 0.7;
                attachmentBehavior.frequency = 0.5;
                
                dynamicAnimator?.addBehavior(attachmentBehavior)
                gravityBehavior?.addItem(attributes)
                collisionBehavior?.addItem(attributes)
                dynamicItemBehavior?.addItem(attributes)
            }
        }
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        return dynamicAnimator?.itemsInRect(rect)
    }

    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        return dynamicAnimator?.layoutAttributesForCellAtIndexPath(indexPath)
    }

    override func collectionViewContentSize() -> CGSize {
        if let cv = collectionView {
            return CGSizeMake(cv.frame.size.width,
                cv.frame.size.height - cv.contentInset.top);
        }
        
        return CGSizeMake(0, 0)
    }
}