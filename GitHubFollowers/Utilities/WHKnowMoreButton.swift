//
//  WHKnowMoreButton.swift
//  Welby
//
//  Created by Colin Murphy on 6/29/20.
//  Copyright © 2020 Seth Merritt. All rights reserved.
//

import UIKit

class WHKnowMoreButton: UIButton
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
            setTitleColor(.white, for: .normal)
            if #available(iOS 13.0, *) {
                arrowImage?.withTintColor(UIColor.white)
            } else {
                arrowImage?.sd_color(at: UIColor.white.cgColor as! CGPoint)
            }
        }
        else if type == .outlined
        {
            self.backgroundColor = .white
            self.titleLabel?.textColor = UIColor.WelbyColor.darkBlue
            setTitleColor(UIColor.WelbyColor.darkBlue, for: .normal)
            if #available(iOS 13.0, *) {
                arrowImage?.withTintColor(UIColor.white)
            } else {
                arrowImage?.sd_color(at: UIColor.white.cgColor as! CGPoint)
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
        setTitle("Know More ", for: .normal)
        titleLabel?.font = WelbyFont.montserrat10
        semanticContentAttribute = .forceRightToLeft // get arrow on RHS of title
    }
}
