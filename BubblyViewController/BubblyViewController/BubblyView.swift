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
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.blueColor()

        let nib = UINib(nibName: "BubbleCell", bundle: nil)
        registerNib(nib, forCellWithReuseIdentifier: BubbleCell.reuseId())

        dataSource = self
        delegate = self
        var layout = BubblyLayout()
        
        collectionViewLayout = layout
    }
    
    //MARK - DataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
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

class BubblyLayout: UICollectionViewFlowLayout {
    var dynamicAnimator: UIDynamicAnimator?
    
    override init() {
        super.init()
        minimumInteritemSpacing = 10
        minimumLineSpacing = 10
        itemSize = CGSize(width: 60, height: 60)
        sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
    }

    required init(coder aDecoder: NSCoder) {
        super.init()
        prepareLayout()
    }

    override func prepareLayout() {
        super.prepareLayout()
        
        if let contentSize = self.collectionView?.contentSize {
            var items = super.layoutAttributesForElementsInRect(CGRectMake(0, 0, contentSize.width, contentSize.height))
            
            if dynamicAnimator?.behaviors.count == 0 {
                for item in items! {
                    if let obj = item as? UIDynamicItem {
                        var behavior = UIAttachmentBehavior(item: obj, attachedToAnchor: obj.center)
                        
                        behavior.length = 0.5
                        behavior.damping = 0.5
                        behavior.frequency = 1.0
                        dynamicAnimator?.addBehavior(behavior)
                    }
                }
            }
        }
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        return dynamicAnimator?.itemsInRect(rect)
    }

    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        return dynamicAnimator?.layoutAttributesForCellAtIndexPath(indexPath)
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        var scrollView = collectionView
        var delta = newBounds.origin.y - scrollView!.bounds.origin.y
        
        var touchLocation = collectionView?.panGestureRecognizer.locationInView(collectionView)
        
        for behavior in dynamicAnimator!.behaviors {
            var behavior = behavior as! UIAttachmentBehavior
            var yDistance = fabs(touchLocation!.y - behavior.anchorPoint.y)
            var xDistance = fabs(touchLocation!.x - behavior.anchorPoint.x)
            var scrollResistance = (yDistance + xDistance) / 1500.0
            
            var item:UICollectionViewLayoutAttributes = behavior.items.first as! UICollectionViewLayoutAttributes
            var center = item.center
            
            if delta < 0 {
                center.y += max(delta, delta * scrollResistance)
            } else {
                center.y += min(delta, delta * scrollResistance)
            }
            
            item.center = center
            
            dynamicAnimator?.updateItemUsingCurrentState(item)
        }
        
        return false
    }
}