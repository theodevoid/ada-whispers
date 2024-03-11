//
//  LoginView.swift
//  ada-bisikan
//
//  Created by Theodore Mangowal on 08/03/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var username: String = ""
    @State private var isLoading: Bool = false
    
    var disableButton: Bool {
        username.count < 3
    }
    
    var body: some View {
        ZStack {
            Color("Paper").ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                VStack (spacing: 8) {
                    Text("✨ADA Whispers✨")
                        .font(.largeTitle)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .multilineTextAlignment(.center)
                    
                    Text("Listen to whispers no one is willing to say around you")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                VStack {
                    VStack {
                        TextField(text: $username) {
                            Text("Enter a username")
                                .multilineTextAlignment(.center)
                                .fontWeight(.semibold)
                        }
                        .cornerRadius(8)
                        .multilineTextAlignment(.center)
                        .font(.title2)
                        .padding()
                            
                    }
                    
                    Button(action: {
                        Task {
                            isLoading = true
                            try await viewModel.createAndSignInUser(username: username)
                            isLoading = false
                        }
                    }, label: {
                        isLoading ? VFButton(title: "Loading...") : VFButton(title: "Join ADA Whispers")
                    })
                    .opacity(disableButton ? 0.4 : 1.0)
                    .disabled(disableButton)
                }
                
                Spacer()
                
            }
            .padding(EdgeInsets(top: 40, leading: 16, bottom: 80, trailing: 16))
        }
        
    }
}

#Preview {
    LoginView()
}
