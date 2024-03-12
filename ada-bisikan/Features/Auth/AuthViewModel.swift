//
//  AuthViewModel.swift
//  ada-bisikan
//
//  Created by Theodore Mangowal on 09/03/24.
//

import SwiftUI
import Foundation

struct User: Decodable, Identifiable, Encodable {
    var id: Int
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
    
    let baseURL = "https://ada-whispers-be-production.up.railway.app"
    
    let defaults = UserDefaults.standard
    
    @Published var messages: [Message] = []
    
    @Published var openedMessage: Message? = nil
    
    init() {
        if let id = defaults.integer(forKey: "id") as Int?, let username = defaults.string(forKey: "username"),
           let token = defaults.string(forKey: "token") {
            print(id)
            print(username)
            print(token)
            
            if id != 0 {
                self.currentUser = User(id: id, username: username, token: token)
            }
        }
    }
    
    func createAndSignInUser (username: String) async throws {
        guard let url = URL(string: baseURL + "/users" ) else { fatalError("Missing URL") }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: ["username": username])
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = jsonData
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 201 {
                guard let data = data else { return }
                
                DispatchQueue.main.async {
                    do {
                        let decodedUser = try JSONDecoder().decode(User.self, from: data)
                        
                        self.currentUser = decodedUser
                                                
                        self.defaults.setValue(self.currentUser?.token, forKey: "token")
                        self.defaults.setValue(self.currentUser?.username, forKey: "username")
                        self.defaults.setValue(self.currentUser?.id, forKey: "id")
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        
        dataTask.resume()
    }
    
    func signOut () {
        self.currentUser = nil
        
        defaults.removeObject(forKey: "id")
        defaults.removeObject(forKey: "username")
        defaults.removeObject(forKey: "token")
    }
    
    func sendMessage(message: String, username: String) async throws -> String {
        guard let url = URL(string: baseURL + "/messages" ) else { fatalError("Missing URL") }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: ["toUsername": username, "messageBody": message])
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer " + (currentUser?.token ?? ""), forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 201 else { return "fail" }
        
        return "success"
    }
    
    func getMessages () async throws -> String {
        guard let url = URL(string: baseURL + "/messages" ) else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer " + (currentUser?.token ?? ""), forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { return "fail" }
        
        do {
            let decoder = JSONDecoder()
            
            decoder.dateDecodingStrategy = .custom { decoder -> Date in
                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)

                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                formatter.timeZone = TimeZone(identifier: "UTC")

                if let date = formatter.date(from: dateString) {
                    return date
                } else {
                    throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format")
                }
            }
            
            let decodedMessages = try decoder.decode([Message].self, from: data)
            
            self.messages = decodedMessages
        } catch {
            print("failed to decode")
            print(error)
        }
        
        return "success"
    }
    
    func getMessage (messageId: String) async throws -> String {
        guard let url = URL(string: baseURL + "/messages/" + messageId ) else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer " + (currentUser?.token ?? ""), forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { return "fail" }
        
        do {
            let decoder = JSONDecoder()
            
            decoder.dateDecodingStrategy = .custom { decoder -> Date in
                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)

                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                formatter.timeZone = TimeZone(identifier: "UTC")

                if let date = formatter.date(from: dateString) {
                    return date
                } else {
                    throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format")
                }
            }
            
            let decodedMessages = try decoder.decode(Message.self, from: data)
            
            self.openedMessage = decodedMessages
            
            let openedMessageIndex = self.messages.firstIndex(where: {
                return $0.messageId == messageId
            })
            
            self.messages[openedMessageIndex!].isRead = true
        } catch {
            
            print("failed to decode")
            print(error)
        }
        
        return "success"
    }
}
