//
//  VFButton.swift
//  ada-bisikan
//
//  Created by Theodore Mangowal on 08/03/24.
//

import SwiftUI

struct VFButton: View {
    var title: String
    
    var body: some View {
        Text(title)
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
    }
}

#Preview {
    VFButton(title: "Test Title")
}
