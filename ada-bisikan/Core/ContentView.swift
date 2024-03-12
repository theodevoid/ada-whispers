//
//  ContentView.swift
//  ada-bisikan
//
//  Created by Theodore Mangowal on 09/03/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    
    var body: some View {
        Group {
            if viewModel.currentUser != nil {
                AuthedView()
            } else {
                LoginView()
            }
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
