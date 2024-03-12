//
//  HomeView.swift
//  ada-bisikan
//
//  Created by Theodore Mangowal on 10/03/24.
//

import SwiftUI

enum ActiveAlert {
    case success, error
}

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var recipientUsername: String = ""
    @State private var messageText: String = ""
    @State private var placeholderText: String = "Message"
    
    @State private var showAlert: Bool = false
    @State private var activeAlert: ActiveAlert = .success
    
    @StateObject var locationManager = LocationManager()
    
    var userLatitude: String {
        return "\(locationManager.location?.latitude ?? 0)"
    }
    
    var userLongitude: String {
        return "\(locationManager.location?.longitude ?? 0)"
    }
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color("Paper").ignoresSafeArea()
                
                VStack(alignment: .center) {
                    HStack {
                        Circle()
                            .frame(width: 8, height: 8)
                            .foregroundStyle(locationManager.isInADA ? .green : .red)
                            .padding(.trailing, 2)
                        Text(locationManager.isInADA ? "You are currently in Academy regions" : "You are currently not in Academy regions")
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                    Text("Send an anonymous message")
                        .fontWeight(.bold)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                    
                    VStack(spacing: 0) {
                        VStack(alignment: .leading) {
                            TextField("To:", text: $recipientUsername)
                                .fontWeight(.bold)
                                .font(.largeTitle)
                                .autocorrectionDisabled()
                        }
                        .padding()
                        .background(.white)
                        .clipShape(.rect(
                            topLeadingRadius: 4,
                            topTrailingRadius: 4
                        ))
                        
                        Rectangle()
                            .fill(.black)
                            .frame(height: 2)
                        
                        
                        VStack(alignment: .leading) {
                            ZStack(alignment: .leading) {
                                VStack(alignment: .leading) {
                                    TextEditor(text: $messageText)
                                        .fontWeight(.semibold)
                                        .autocorrectionDisabled()
                                        .scrollContentBackground(.hidden)
                                    Spacer()
                                }
                                
                                
                                
                                if messageText.isEmpty {
                                    TextEditor(text: $placeholderText)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                        .autocorrectionDisabled()
                                        .scrollContentBackground(.hidden)
                                        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                    
                                }
                            }.padding()
                        }
                        .frame(maxHeight: 150)
                        .background(.ultraThinMaterial)
                        .background()
                        .clipShape(.rect(
                            bottomLeadingRadius: 4,
                            bottomTrailingRadius: 4
                        ))
                    }
                    .overlay(
                        RoundedRectangle(
                            cornerRadius: 4
                        )
                        .stroke(lineWidth: 4)
                        .clipShape(.rect(
                            topLeadingRadius: 4,
                            bottomLeadingRadius: 4,
                            bottomTrailingRadius: 4,
                            topTrailingRadius: 4
                        ))
                    )
                    .background(
                        Rectangle()
                            .fill(Color.black)
                            .clipShape(.rect(
                                topLeadingRadius: 4,
                                bottomLeadingRadius: 4,
                                bottomTrailingRadius: 4,
                                topTrailingRadius: 4
                            ))
                            .shadow(color: .black, radius: 0, x: 4, y: 4)
                    )
                    Text("\(messageText.count)/300")
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(messageText.count > 300 ? .red : .black)
                    
                    Button(action: {
                        Task {
                            if !locationManager.isInADA {
                                activeAlert = .error
                                showAlert = true
                                
                                return
                            }
                            
                            let result = try await authViewModel.sendMessage(message: messageText, username: recipientUsername)
                            
                            print(result)
                            
                            if result == "success" {
                                messageText = ""
                                recipientUsername = ""
                                activeAlert = .success
                            } else {
                                activeAlert = .error
                            }
                            
                            showAlert = true
                        }
                    }, label: {
                        Text("Send message")
                            .frame(maxWidth: .infinity, maxHeight: 36)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(.black, lineWidth: 4)
                            )
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color("Accent"))
                                    .shadow(color: .black, radius: 0, x: 4, y: 4)
                            )
                            .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    })
                    .alert(isPresented: $showAlert) {
                        switch activeAlert {
                        case .error:
                            return Alert(
                                title: Text("An error has occured"),
                                message: Text("Make sure the user exists, your message is 1-300 characters long, and you are in Academy regions")
                            )
                        case .success:
                            return Alert(
                                title: Text("Message sent!")
                            )
                        }
                        
                    }
                    .padding(.top)
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}

#Preview {
    HomeView()
}
