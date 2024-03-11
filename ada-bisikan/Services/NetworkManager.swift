//
//  NetworkManager.swift
//  ada-bisikan
//
//  Created by Theodore Mangowal on 09/03/24.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    static let baseURL = "http://localhost:2000"
    private let authURL = baseURL + "/auth"
    
    private init () {}
    
    func registerUser(completed: @escaping (Result<User, ServiceError>) -> Void) {
        guard let url = URL(string: authURL) else {
            completed(.failure(.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let _ = error else {
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
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(UserResponse.self, from: data)
                
                completed(.success(decodedResponse.request))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    func mockRegisterUser() -> User {
        return User(id: "abc123", username: "theo", token: "token")
    }
}
