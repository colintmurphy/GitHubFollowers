//
//  User.swift
//  GitHubFollowers
//
//  Created by Colin Murphy on 6/29/20.
//  Copyright © 2020 Colin Murphy. All rights reserved.
//

import Foundation

struct User: Codable {
    
    let login: String
    let avatarUrl: String
    var name: String? /// optional bc person might not have name set, if null comes back and we have String, it'll throw an error
    var location: String?
    var bio: String?
    let publicRepos: Int
    let publicGists: Int
    let htmlUrl: String
    let following: Int
    let followers: Int
    let createdAt: Date /// Date object bc of our use of .iso8601 in the decoder
}

/*
 
EDUCATIONAL NOTES:
    - "let createdAt: Date": Date type bc of the user of .iso8601 in the decoder (does String -> Date for us)
*/
