//
//  HomeView.swift
//  ada-bisikan
//
//  Created by Theodore Mangowal on 09/03/24.
//

import SwiftUI

let messageMockData = [
    Message(id: 1, messageId: "123", body: "you have really cool style", createdAt: Date(timeIntervalSinceNow: -300)),
    Message(id: 2, messageId: "123", body: "how are you?", createdAt: Date(timeIntervalSinceNow: -100)),
]

struct InboxView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var sheetIsOpen: Bool = false
    @State private var openedMessageId: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("Paper").ignoresSafeArea()
                List {
                    ForEach(viewModel.messages) { message in
                        Button (action: {
                            sheetIsOpen = true
                            openedMessageId = message.messageId
                        }, label: {
                            InboxRowView(message: message)
                        })
                        .listRowSeparator(.hidden)
                        .listRowBackground(
                            Rectangle().fill(.clear)
                        )                    }
                    .background(.red)
                }
                .navigationTitle("Inbox")
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
                .onAppear() {
                    Task {
                        try await viewModel.getMessages()
                    }
                }
                .refreshable {
                    Task {
                        try await viewModel.getMessages()
                    }
                }
            }
        }
        .sheet(isPresented: $sheetIsOpen, content: {
            ZStack {
                Color("Paper").ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            sheetIsOpen = false
                        }, label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.black)
                        })
                        .padding()
                    }
                    
                    Text("Message")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom)
                    
                    if viewModel.openedMessage != nil {
                        Text(viewModel.openedMessage!.body)
                    }
                    Spacer()
                }
                .padding()
            }
            .onAppear() {
                Task {
                    try await viewModel.getMessage(messageId: openedMessageId)
                }
            }
        })
    }
}

#Preview {
    InboxView()
}
