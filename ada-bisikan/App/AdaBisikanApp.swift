//
//  AdaBisikanApp.swift
//  ada-bisikan
//
//  Created by Theodore Mangowal on 09/03/24.
//

import SwiftUI

@main
struct AdaBisikanApp: App {
    @StateObject var viewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
