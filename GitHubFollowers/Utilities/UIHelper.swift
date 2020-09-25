//
//  UIHelper.swift
//  GitHubFollowers
//
//  Created by Colin Murphy on 6/30/20.
//  Copyright © 2020 Colin Murphy. All rights reserved.
//

import UIKit

enum UIHelper {
    
    static func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        
        let width                       = view.bounds.width
        let padding: CGFloat            = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth              = width - (padding * 2) - (minimumItemSpacing * 2) /// b/w left+middle & right+middle
        let itemWidth                   = availableWidth / 3
        
        let flowLayout          = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize     = CGSize(width: itemWidth, height: itemWidth + 40) /// +40 gives that extra room for the label
        return flowLayout
    }
}

/*
 
EDUCATIONAL NOTES:
    - all white text and ... no green... this usually means this can be put somewhere other than the VC
    - func made static so things can reach it
 
*/

