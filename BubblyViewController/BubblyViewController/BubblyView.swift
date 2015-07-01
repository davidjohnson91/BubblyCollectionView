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
    let items = ["Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop", "Bibbity", "Bobbity", "Boop"]
    
    var displayedItems = [String]()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.blueColor()

        let nib = UINib(nibName: "BubbleCell", bundle: nil)
        registerNib(nib, forCellWithReuseIdentifier: BubbleCell.reuseId())

        dataSource = self
        delegate = self
        var layout = BubblyLayout()
        
        collectionViewLayout = layout
        for (index, item) in enumerate(items) {
            performBatchUpdates({ () -> Void in
                self.insertItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
                self.displayedItems.append(item)
            }, completion: nil)
        }
    }
    
    //MARK - DataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedItems.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var item = items[indexPath.row]
        
        var cell = self.dequeueReusableCellWithReuseIdentifier(BubbleCell.reuseId(), forIndexPath: indexPath) as! BubbleCell
        
        cell.label.text = item
        
        cell.layer.cornerRadius = cell.bounds.width / 2
        cell.backgroundColor = UIColor.orangeColor()
        return cell
    }
}

class BubblyLayout: UICollectionViewLayout {
    var dynamicAnimator: UIDynamicAnimator?
    var gravityBehavior: UIGravityBehavior?
    var collisionBehavior: UICollisionBehavior?
    
    let kItemSize = 60
    
    override init() {
        super.init()
        dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)

        gravityBehavior = UIGravityBehavior(items: [])
        gravityBehavior?.gravityDirection = CGVectorMake(0, 1)
        dynamicAnimator?.addBehavior(gravityBehavior)
        
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
                attributes.frame = CGRectMake(CGRectGetMaxX(self.collectionView!.frame) + CGFloat(kItemSize), 300, 60, 60)
                
                
                var attachmentBehavior = UIAttachmentBehavior(item: attributes, attachedToAnchor: CGPointMake(CGRectGetMidX(self.collectionView!.bounds), 64))
                attachmentBehavior.length = 300.0;
                attachmentBehavior.damping = 0.4;
                attachmentBehavior.frequency = 1.0;
                
                dynamicAnimator?.addBehavior(attachmentBehavior)
                gravityBehavior?.addItem(attributes)
                collisionBehavior?.addItem(attributes)
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