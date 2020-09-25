//
//  GFAlertContainerView.swift
//  GitHubFollowers
//
//  Created by Colin Murphy on 7/2/20.
//  Copyright © 2020 Colin Murphy. All rights reserved.
//

import UIKit

class GFAlertContainerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor     = .systemBackground
        layer.cornerRadius  = 16
        layer.borderWidth   = 2
        layer.borderColor   = UIColor.white.cgColor /// dealing with .layer (which is a layer down), which is why we have to do the UIColor...cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
}
