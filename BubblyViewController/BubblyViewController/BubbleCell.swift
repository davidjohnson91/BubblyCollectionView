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
    @IBOutlet weak var imageView: UIImageView!
    
    var currentState: States?
    
    enum States {
        case Basic, Like, Love
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        setStateBasic()
    }
    
    class func reuseId() -> String {
        return "BubbleCellReuseId"
    }
    
    func toggleState() {
        
        if let state = self.currentState {
            switch state {
            case .Basic:
                self.setStateLike()
            case .Like:
                self.setStateLove()
            case .Love:
                self.setStateBasic()
            }
        }
        
        setNeedsLayout()
        layoutSubviews()

    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        var context = UIGraphicsGetCurrentContext()
        CGContextSetFillColor(context, CGColorGetComponents(UIColor(red: 39/255, green: 142/255, blue: 171/255, alpha: 1.0).CGColor))
        CGContextFillPath(context)
        CGContextFillEllipseInRect(context, rect)
    }
    
    private func setStateBasic(){
        currentState = .Basic
        bounds = CGRectMake(0, 0, 100, 100)
        imageView.layer.cornerRadius = bounds.height / 2
        imageView.alpha = 0.0
    }
    
    private func setStateLike(){
        currentState = .Like
        bounds = CGRectMake(0, 0, 120, 120)
        imageView.layer.cornerRadius = bounds.height / 2
        imageView.alpha = 0.3
    }
    
    private func setStateLove(){
        currentState = .Love
        bounds = CGRectMake(0, 0, 140, 140)
        imageView.layer.cornerRadius = bounds.height / 2
        imageView.alpha = 0.4
    }
}