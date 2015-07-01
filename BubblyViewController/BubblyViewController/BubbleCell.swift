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
        backgroundColor = UIColor(red: 39/255, green: 142/255, blue: 171/255, alpha: 1.0)
    }
    
    override func awakeFromNib() {
        setStateBasic()
    }
    
    class func reuseId() -> String {
        return "BubbleCellReuseId"
    }
    
    func toggleState() {
        if let state = currentState {
            switch state {
            case .Basic:
                setStateLike()
            case .Like:
                setStateLove()
            case .Love:
                setStateBasic()
            }
        }
        
        
        setNeedsLayout()
    }
    
    private func setStateBasic(){
        currentState = .Basic
        bounds = CGRectMake(0, 0, 100, 100)
        imageView.alpha = 0.0
//        backgroundColor = backgroundColor?.colorWithAlphaComponent(1.0)
        layer.cornerRadius = bounds.size.height / 2
    }
    
    private func setStateLike(){
        currentState = .Like
        bounds = CGRectMake(0, 0, 120, 120)
        imageView.alpha = 0.3
//        backgroundColor = backgroundColor?.colorWithAlphaComponent(0.7)
        layer.cornerRadius = bounds.size.height / 2
    }
    
    private func setStateLove(){
        currentState = .Love
        bounds = CGRectMake(0, 0, 140, 140)
        imageView.alpha = 0.4
//        backgroundColor = backgroundColor?.colorWithAlphaComponent(0.5)
        layer.cornerRadius = bounds.size.height / 2
    }
}