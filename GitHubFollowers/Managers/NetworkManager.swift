//
//  NetworkManager.swift
//  GitHubFollowers
//
//  Created by Colin Murphy on 6/29/20.
//  Copyright © 2020 Colin Murphy. All rights reserved.
//

import UIKit

class NetworkManager {
    
    // MARK: - Variables
    
    static let shared   = NetworkManager()
    private let baseURL = "https://api.github.com/users/"
    let cache           = NSCache<NSString, UIImage>()
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Methods
    
    func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower], ErrorMessage>) -> Void) {
        
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder                 = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers               = try decoder.decode([Follower].self, from: data)
                completed(.success(followers))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    func getUserInfo(for username: String, completed: @escaping (Result<User, ErrorMessage>) -> Void) {
        
        let endpoint = baseURL + "\(username)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder                     = JSONDecoder()
                decoder.keyDecodingStrategy     = .convertFromSnakeCase
                decoder.dateDecodingStrategy    = .iso8601
                let user                        = try decoder.decode(User.self, from: data)
                completed(.success(user))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        /// if not cached image: download the image
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        /// not handling errors b/c we have the placeholder image, which conveys that the image wasn't downloadable
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) else {
                    completed(nil)
                    return
            } /// here combined the statements bc all return completed(nil)
            
            self.cache.setObject(image, forKey: cacheKey) // add image to cache
            completed(image)
        }
        task.resume()
    }
}

/*
 
EDUCATIONAL NOTES:
    - This class is a Singleton
    - Child ViewController > UIView
        - get Lifecycle Methods: viewDidLoad...
        - self contained: can present and can drive the logic
        - flexible context: can be pushed on a nav controller
    - "static let shared = NetworkManager()" static so every NetworkManager will have this variable on it (Singleton remember)
    - "NSCache<NSString, UIImage>()" takes in a <key, value> pair: similar to a dictionary
        - fun fact: NS stands for Next Step, "Next" as in Steve Job's old company
    - "completed: @escaping (Result<[Follower], ErrorMessage>) -> Void)": "Result<>":  gets rid of optionals, and makes views that call this func easier to read/handle
    - "response.statusCode == 200": status code 200 means everything is OK from the web response
    - @escaping: closers are either escaping or non-escaping:
        - escaping can outlive the function, used for async stuff. The completed() call in the func will be used elsewhere, so it needs to live longer
        - non-escaping does NOT outlive the function
    - "decoder.dateDecodingStrategy = .iso8601": iso8601 is a standard date format which our API uses (and a lot of others use as well): "yyyy-MM-dd'T'HH:mm:ssZ"
        - this essentially does what our "convertToDate()" did in our String extension, so old code using that func was removed
*/

