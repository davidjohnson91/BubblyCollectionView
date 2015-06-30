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
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        bubblyView.collectionViewLayout.invalidateLayout()
    }


}

