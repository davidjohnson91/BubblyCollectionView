//
//  BubblyViewController.swift
//  BubblyViewController
//
//  Created by David Johnson on 6/30/15.
//  Copyright (c) 2015 David Johnson. All rights reserved.
//

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
