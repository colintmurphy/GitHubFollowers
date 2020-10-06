//
//  GFAvatarImageView.swift
//  GitHubFollowers
//
//  Created by Colin Murphy on 6/29/20.
//  Copyright © 2020 Colin Murphy. All rights reserved.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    private let cache               = NetworkManager.shared.cache
    private let placeholderImage    = Images.placeholder

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        layer.cornerRadius  = 10
        clipsToBounds       = true // get image corner radius
        image               = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false // so we don't have to do this in the VC
    }
    
    func downloadImage(fromUrl url: String) {
        
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async { self.image = image }
        }
    }
}
