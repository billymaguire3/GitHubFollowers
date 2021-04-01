//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by William Maguire on 3/29/21.
//

import Foundation

// MARK: - New Swift 5 Result Network Request Style
class NetworkManager {
    // static means every netowrk manager will have the shared property. Singleton
    static let shared = NetworkManager()

    let baseUrl = "https://api.github.com/users/"

    private init() {}

    func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower], GFError>) -> Void) {
        let endpoint = baseUrl + "\(username)/followers?per_page=100&page=\(page)"

        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Handling the error
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            // Handling the response
            // creating a new response variable with different name
            guard let res = response as? HTTPURLResponse, res.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            // Handling the data
            // creating new data variable with same name
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }

            // If we get successful data, not we need to parse the JSON
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                // error handling. Everything went well, pass our followers array to completed and nil for error message
                completed(.success(followers))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        // This line actually fires the netowrk call. Often forgotten
        task.resume()
    }
}


// MARK: - Old/Fundamental Network Request Style
//class NetworkManager {
//    // static means every netowrk manager will have the shared property
//    static let shared = NetworkManager()
//
//    let baseUrl = "https://api.github.com/users/"
//
//    private init() {}
//
//    func getFollowers(for username: String, page: Int, completed: @escaping ([Follower]?, ErrorMessage?) -> Void) {
//        let endpoint = baseUrl + "\(username)/followers?per_page=100&page=\(page)"
//
//        guard let url = URL(string: endpoint) else {
//            completed(nil, .invalidUsername)
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            // Handling the error
//            if let _ = error {
//                completed(nil, .unableToComplete)
//                return
//            }
//            // Handling the response
//            // creating a new response variable with different name
//            guard let res = response as? HTTPURLResponse, res.statusCode == 200 else {
//                completed(nil, .invalidResponse)
//                return
//            }
//            // Handling the data
//            // creating new data variable with same name
//            guard let data = data else {
//                completed(nil, .invalidData)
//                return
//            }
//
//            // If we get successful data, not we need to parse the JSON
//            do {
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                let followers = try decoder.decode([Follower].self, from: data)
//                // error handling. Everything went well, pass our followers array to completed and nil for error message
//                completed(followers, nil)
//            } catch {
//                completed(nil, .invalidData)
//            }
//        }
//        // This line actually fires the netowrk call. Often forgotten
//        task.resume()
//    }
//}