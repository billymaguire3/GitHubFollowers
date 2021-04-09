//
//  PersistenceManager.swift
//  GHFollowers
//
//  Created by William Maguire on 4/8/21.
//

import Foundation

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    // Enum for Adding or Removing favorites
    enum PersistenceActionType {
        case add, remove
    }
    
    // Enum for user defaults
    enum Keys {
        static let favorites = "favorites"
    }
    
    // Function that brings everything together. Need to know whether we are adding or removing a favorite and use enum properties accordingly
    static func updateWith(favorite: Follower, actionType: PersistenceActionType, completed: @escaping (GFError?) -> Void) {
        // reach into user defaults, retrieve the array to update it to add or remove
        retrieveFavorites { (result) in
            switch result {
            case .success(let favorites):
                // favorites is immutable, create a mutable copy
                var retrievedFavorites = favorites
                switch actionType {
                case .add:
                    guard !retrievedFavorites.contains(favorite) else {
                        // if it does exist, send a new error alert
                        completed(.favoriteAlreadyExists)
                        return
                    }
                    // if the favorite does not exist in the array, append it to the array
                    retrievedFavorites.append(favorite)

                case .remove:
                    // Go through the array and remove all instances where the follower matches
                    retrievedFavorites.removeAll { $0.login == favorite.login }
                }
                // Save the array back into user defaults
                completed(save(favorites: retrievedFavorites))
                
            case .failure(let error):
                completed(error)
                return
            }
        }
    }
    
    // Function to retrieve the UserDefaults
    static func retrieveFavorites(completed: @escaping (Result<[Follower], GFError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.unableToAddFavorite))
        }
    }
    
    // Function to set and save a favorite to user defaults
    static func save(favorites: [Follower]) -> GFError? {
        
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch  {
            return .unableToAddFavorite
        }
    }
    
    
}
