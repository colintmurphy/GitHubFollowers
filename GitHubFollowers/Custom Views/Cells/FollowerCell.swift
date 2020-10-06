//
//  FollowerCell.swift
//  GitHubFollowers
//
//  Created by Colin Murphy on 6/29/20.
//  Copyright © 2020 Colin Murphy. All rights reserved.
//

import UIKit

class FollowerCell: UICollectionViewCell {
    
    static let reuseID          = "FollowerCell"
    private let avatarImageView = GFAvatarImageView(frame: .zero)
    private let usernameLabel   = GFTitleLabel(textAlignment: .center, fontSize: 16)
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(follower: Follower) {
        
        usernameLabel.text = follower.login
        avatarImageView.downloadImage(fromUrl: follower.avatarUrl)
    }
    
    /// added for the changing cells... (cached images look great, loading ones change around... possibly noticeable bc i'm on a slow network)
    override func prepareForReuse() {
        
        super.prepareForReuse()
        avatarImageView.image = Images.placeholder
    }
    
    private func configure() {
        
        addSubviews(avatarImageView, usernameLabel)
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor), /// makes it a square
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
