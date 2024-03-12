//
//  NetworkManager.swift
//  ada-bisikan
//
//  Created by Theodore Mangowal on 09/03/24.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    static let baseURL = "http://localhost:3000"
    private let usersURL = baseURL + "/users"
    
    private init () {}
    
    func registerUser(username: String, completed: @escaping (Result<User, ServiceError>) -> Void) {
        guard let url = URL(string: usersURL) else {
            completed(.failure(.invalidUrl))
            return
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: ["username": username])
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
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
                
                print(decodedResponse)
                
                completed(.success(decodedResponse.request))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    func mockRegisterUser() -> User {
        return User(id: 1, username: "theo", token: "token")
    }
}
