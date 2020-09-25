//
//  Follower.swift
//  GitHubFollowers
//
//  Created by Colin Murphy on 6/29/20.
//  Copyright © 2020 Colin Murphy. All rights reserved.
//

import Foundation

struct Follower: Codable, Hashable {
    
    var login: String
    var avatarUrl: String
}


/*
 
EDUCATIONAL NOTES:
    - in termal can do curl https.... and we can see what the data looks like
    - Hashable added for the UICollectionView
    - Codable: when using them our variable names must match whats in the data structure
        - don't need to have everything, just creating a struct of what we want to obtain
    - "avatarUrl" done here when var is avatar_url bc converting snake_case to camelCase in the decoder
    - for slight optimization:
        - only hash the login:
            func hash(into hasher: inout Hasher) {
                hasher.combine(login)
            }
*/

