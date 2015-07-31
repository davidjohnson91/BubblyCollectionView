//
//  ViewController.swift
//  BubblyViewController
//
//  Created by David Johnson on 6/30/15.
//  Copyright (c) 2015 David Johnson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var bubblyView: BubblyView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bubblyView.invalidateIntrinsicContentSize()
        
        for (index, item) in enumerate(bubblyView.items) {
            bubblyView.performBatchUpdates({ () -> Void in
                self.bubblyView.insertItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
                self.bubblyView.displayedItems.append(item)
                }, completion: nil)
        }
        bubblyView.setContentOffset(CGPointMake(((bubblyView.contentSize.width / 2) - (view.frame.width / 2)), 0), animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        bubblyView.collectionViewLayout.invalidateLayout()
    }


}

