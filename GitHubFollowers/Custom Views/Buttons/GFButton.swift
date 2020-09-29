//
//  GFButton.swift
//  GitHubFollowers
//
//  Created by Colin Murphy on 6/29/20.
//  Copyright © 2020 Colin Murphy. All rights reserved.
//

import UIKit

class GFButton: UIButton {
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(backgroundColor: UIColor, title: String) {
        
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
    }
    
    private func configure() {
        
        translatesAutoresizingMaskIntoConstraints = false
        setTitleColor(.white, for: .normal)
        titleLabel?.font    = UIFont.preferredFont(forTextStyle: .headline)
        layer.cornerRadius  = 10
    }
    
    func set(backgroundColor: UIColor, title: String) {
        
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal) 
    }
}

/*
 
EDUCATIONAL NOTES:
    - "translatesAutoresizingMaskIntoConstraints = false": use auto layout
    - "let createdAt: Date": Date type bc of the user of .iso8601 in the decoder (does String -> Date for us)
    - "titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)": conform to dynamic types (in settings if the user wants text sizes to be larger)
    - "super.init()": inherits/calls initial default Apple button stuff
    - gets called when item is called via storyboard:
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    - "self.init(frame: .zero)": do this bc we use auto layout
 
*/
