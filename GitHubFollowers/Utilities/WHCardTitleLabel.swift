//
//  WHCardTitleLabel.swift
//  Welby
//
//  Created by Colin Murphy on 6/29/20.
//  Copyright © 2020 Seth Merritt. All rights reserved.
//

import UIKit

class WHCardTitleLabel: UILabel
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(textAlignment: NSTextAlignment)
    {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = WelbyFont.montserrat29
        configure()
    }
    
    private func configure()
    {
        textColor = UIColor.WelbyColor.red
        adjustsFontSizeToFitWidth = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}
