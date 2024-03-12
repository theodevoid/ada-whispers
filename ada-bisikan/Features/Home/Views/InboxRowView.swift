//
//  InboxRowView.swift
//  ada-bisikan
//
//  Created by Theodore Mangowal on 09/03/24.
//

import SwiftUI

var sampleMessage: Message = Message(id: 1, messageId: "1", body: "Hello there Hello there Hello there Hello there", createdAt: Date(timeIntervalSinceNow: -600))

struct InboxRowView: View {
    let formatter = RelativeDateTimeFormatter()
    
    var message: Message
    
    var body: some View {
        HStack {
            Circle()
                .fill(message.isRead ? .white : .red)
                .frame(width: 15, height: 15)
                .padding(.trailing, 4)
            
            VStack(alignment: .leading) {
                Text(message.body)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .font(.title3)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                
                Text(formatter.localizedString(for: message.createdAt, relativeTo: Date()))
                    .font(.footnote)
            }
            .padding(.trailing)
            
            Spacer()
            
            Image(systemName: "chevron.right")
        }
        .padding()
        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 2)
        .background(.white)
        .background(
            Rectangle()
                .fill(Color.white)
                .shadow(color: .black, radius: 0, x: 4, y: 4)
        )
        
    }
    
}

#Preview {
    InboxRowView(message: sampleMessage)
}
