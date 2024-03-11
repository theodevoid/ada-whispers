//
//  AuthViewModel.swift
//  ada-bisikan
//
//  Created by Theodore Mangowal on 09/03/24.
//

import SwiftUI
import Foundation

struct User: Decodable, Identifiable, Encodable {
    var id: String
    var username: String
    var token: String
}

struct UserResponse: Decodable {
    let request: User
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    
    var networkManager = NetworkManager.shared
    
    let defaults = UserDefaults.standard
    
    init() {
        if let loggedInUser = defaults.object(forKey: "loggedInUser") as? Data,
           let decodedUser = try? JSONDecoder().decode(User.self, from: loggedInUser) {
            self.currentUser = decodedUser
        }
    }
    
    func createAndSignInUser (username: String) async throws {
        let user = networkManager.mockRegisterUser()
        
        self.currentUser = User(id: "abc123", username: username, token: "token")
        
        if let encodedUser = try? JSONEncoder().encode(user) {
            defaults.set(encodedUser, forKey: "loggedInUser")
        }
    }
    
    func signOut () {
        self.currentUser = nil
        defaults.removeObject(forKey: "loggedInUser")
    }
}
