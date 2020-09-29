//
//  PersistenceManager.swift
//  GitHubFollowers
//
//  Created by Colin Murphy on 7/1/20.
//  Copyright © 2020 Colin Murphy. All rights reserved.
//

import Foundation

// MARK: - PersistenceActionType enum

enum PersistenceActionType {
    case add, remove
}

// MARK: - PersistenceManager enum

enum PersistenceManager {
    
    // MARK: - Variables
    
    static private let defaults = UserDefaults.standard
    
    // MARK: - Keys Enum
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    // MARK: - Methods
    
    static func updateWith(favorite: Follower, actionType: PersistenceActionType, completed: @escaping (ErrorMessage?) -> Void) {
        
        retrieveFavorites { result in
            
            switch result {
            case .success(var favorites):
                
                switch actionType {
                case .add:
                    guard !favorites.contains(favorite) else {
                        completed(.alreadyInFavorites); return
                    }
                    favorites.append(favorite)
                
                case .remove:
                    favorites.removeAll { $0.login == favorite.login }
                }
                completed(save(favorites: favorites))
            
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    static func retrieveFavorites(completed: @escaping (Result<[Follower], ErrorMessage>) -> Void) {
        
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.unableToFavorite))
        }
    }
    
    static func save(favorites: [Follower]) -> ErrorMessage? {
        
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
}

/*
 
EDUCATIONAL NOTES:
    - UserDefaults purpose: data persistence throughout the app (on all views)
        - have to encode & decode anything thats a custom object, when saving to UserDefaults
*/

