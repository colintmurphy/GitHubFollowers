//
//  WHAddButton.swift
//  Welby
//
//  Created by Colin Murphy on 6/29/20.
//  Copyright © 2020 Seth Merritt. All rights reserved.
//

import UIKit

class WHAddButton: UIButton
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(type: WelbyUIType, size: CGFloat)
    {
        super.init(frame: .zero)
        let plusImage = UIImage(named: "myPlus")
        if type == .filled
        {
            self.backgroundColor = UIColor.WelbyColor.darkBlue
            if #available(iOS 13.0, *) {
                plusImage?.withTintColor(.white)
            } else {
                
            }
            titleLabel?.textColor = .white
        }
        else if type == .outlined
        {
            self.backgroundColor = .white
            if #available(iOS 13.0, *) {
                plusImage?.withTintColor(UIColor.WelbyColor.darkBlue)
            } else {
                
            }
            titleLabel?.textColor = UIColor.WelbyColor.darkBlue
        }
        setImage(plusImage, for: .normal)
        layer.cornerRadius = size/2
        self.configure()
    }
    
    private func configure()
    {
        translatesAutoresizingMaskIntoConstraints = false // use auto layout
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.WelbyColor.darkBlue.cgColor
    }
}
