//
//  GFTitleLabel.swift
//  GitHubFollowers
//
//  Created by Colin Murphy on 6/29/20.
//  Copyright © 2020 Colin Murphy. All rights reserved.
//

import UIKit

class GFTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        self.init(frame: .zero) /// calls the init above
        self.textAlignment = textAlignment /// do self. bc they have the same names here
        font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }
    
    private func configure() {
        textColor                   = .label
        adjustsFontSizeToFitWidth   = true
        minimumScaleFactor          = 0.9
        lineBreakMode               = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}

/*
EDUCATIONAL NOTES:
    - convenience initializer: needs to call one of the designated initializers, so only need configure() in the above init
        - also allows default parameters when calling inits with a bunch of parameters, so only need to user some of the params
    - designated initializers: "override init(frame: CGRect) {...}"
*/

