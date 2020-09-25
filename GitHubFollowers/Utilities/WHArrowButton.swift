//
//  WHArrowButton.swift
//  Welby
//
//  Created by Colin Murphy on 6/29/20.
//  Copyright © 2020 Seth Merritt. All rights reserved.
//

import UIKit

class WHArrowButton: UIButton
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(type: WelbyUIType)
    {
        super.init(frame: .zero)
        let arrowImage = UIImage(named: "arrow.right")
        if type == .filled
        {
            self.backgroundColor = UIColor.WelbyColor.darkBlue
            if #available(iOS 13.0, *) {
                arrowImage?.withTintColor(UIColor.white)
            } else {
                arrowImage?.sd_color(at: UIColor.white.cgColor as! CGPoint)
            }
        }
        else if type == .outlined
        {
            self.backgroundColor = .white
            if #available(iOS 13.0, *) {
                arrowImage?.withTintColor(UIColor.WelbyColor.darkBlue)
            } else {
                arrowImage?.sd_color(at: UIColor.WelbyColor.darkBlue.cgColor as! CGPoint)
            }
        }
        setImage(arrowImage, for: .normal)
        self.configure()
    }
    
    private func configure()
    {
        translatesAutoresizingMaskIntoConstraints = false // use auto layout
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.WelbyColor.darkBlue.cgColor
    }
}
