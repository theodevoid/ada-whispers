//
//  InboxRowView.swift
//  ada-bisikan
//
//  Created by Theodore Mangowal on 09/03/24.
//

import SwiftUI

var sampleMessage: Message = Message(id: "1", content: "Hello there Hello there Hello there Hello there", createdAt: Date(timeIntervalSinceNow: -600))

struct InboxRowView: View {
    let formatter = RelativeDateTimeFormatter()
    
    var message: Message
    
    var body: some View {
        HStack {
//            Color.gray
//                .opacity(0.2)
//                .frame(width: 50, height: 50)
//                .clipShape(.buttonBorder)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(.black, lineWidth: 2)
//                )
//                .overlay(
//                    Image(systemName: "envelope.fill")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width:35)
//                        .padding(.horizontal)
//                        .foregroundStyle(Color("Primary"))
//                )
//                .padding(.trailing, 4)

            VStack(alignment: .leading) {
                Text(message.content)
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
