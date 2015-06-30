//
//  BubbleCell.swift
//  BubblyViewController
//
//  Created by David Johnson on 6/30/15.
//  Copyright (c) 2015 David Johnson. All rights reserved.
//

import Foundation
import UIKit

class BubbleCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    
    class func reuseId() -> String {
        return "BubbleCellReuseId"
    }
}