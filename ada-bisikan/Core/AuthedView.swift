//
//  AuthedView.swift
//  ada-bisikan
//
//  Created by Theodore Mangowal on 09/03/24.
//

import SwiftUI

struct AuthedView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            InboxView()
                .tabItem {
                    Label("Inbox", systemImage: "envelope.fill")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}

#Preview {
    AuthedView()
}
