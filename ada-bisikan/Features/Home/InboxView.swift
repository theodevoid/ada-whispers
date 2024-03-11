//
//  HomeView.swift
//  ada-bisikan
//
//  Created by Theodore Mangowal on 09/03/24.
//

import SwiftUI

let messageMockData = [
    Message(id: "1", content: "you have really cool style", createdAt: Date(timeIntervalSinceNow: -300)),
    Message(id: "2", content: "how are you?", createdAt: Date(timeIntervalSinceNow: -100)),
    Message(id: "3", content: "nice to meet you", createdAt: Date(timeIntervalSinceNow: -5)),
    Message(id: "4", content: "good job", createdAt: Date(timeIntervalSinceNow: -610)),
]

struct InboxView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Paper").ignoresSafeArea()
                List {
                    ForEach(messageMockData) { message in
                        InboxRowView(message: message)
                            .listRowSeparator(.hidden)
                            .listRowBackground(
                                Rectangle().fill(.clear)
                            )
                    }
                    .background(.red)
                }
                .navigationTitle("Inbox")
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
                
            }
        }
        
    }
}

#Preview {
    InboxView()
}
