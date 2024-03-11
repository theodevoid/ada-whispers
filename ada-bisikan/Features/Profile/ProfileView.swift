//
//  ProfileView.swift
//  ada-bisikan
//
//  Created by Theodore Mangowal on 12/03/24.
//

import SwiftUI
import QRCode

func doc1 (data: String) -> QRCode.Document {
    let doc = QRCode.Document(generator: QRCodeGenerator_External())
    
    let black = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
    
    doc.utf8String = data
    
    doc.design.backgroundColor(CGColor(gray: 0, alpha: 0))
    
    doc.design.style.background = QRCode.FillStyle.Solid(0, 0, 0, alpha: 0)
    doc.design.shape.eye = QRCode.EyeShape.RoundedRect()
    doc.design.style.eye = QRCode.FillStyle.Solid(black)
    
    doc.design.shape.pupil = QRCode.PupilShape.Circle()
    doc.design.style.pupil =  QRCode.FillStyle.Solid(black)
    
    doc.design.style.onPixels = QRCode.FillStyle.Solid(black)
    doc.design.shape.onPixels = QRCode.PixelShape.CurvePixel()
    
    doc.design.additionalQuietZonePixels = 1
    
    return doc
}

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var isShowingDialog = false
    
    var body: some View {
        ZStack {
            Color("Paper").ignoresSafeArea()
            
            VStack {
                VStack {
                    QRCodeDocumentUIView(document: doc1(data: authViewModel.currentUser?.username ?? ""))
                    Text(authViewModel.currentUser?.username ?? "")
                        .textCase(.uppercase)
                        .fontWeight(.semibold)
                        .padding()
                        .font(.title)
                    
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .aspectRatio(1, contentMode: .fit)
                .background(.white)
                .clipShape(.rect(
                    cornerRadius: 16
                ))
                .overlay(
                    RoundedRectangle(
                        cornerRadius: 16
                    )
                    .stroke(lineWidth: 6)
                    .clipShape(.rect(
                        topLeadingRadius: 16,
                        bottomLeadingRadius: 16,
                        bottomTrailingRadius: 16,
                        topTrailingRadius: 16
                    ))
                )
                
                Button(action: {
                    isShowingDialog = true
                }, label: {
                    Text("DELETE ACCOUNT")
                        .frame(maxWidth: .infinity, maxHeight: 36)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(.black, lineWidth: 4)
                        )
                        .background(.red)
                        .foregroundColor(.white)
                        .cornerRadius(4)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color("Accent"))
                                .shadow(color: .black, radius: 0, x: 4, y: 4)
                        )
                    
                })
                .confirmationDialog("Are you sure you want to delete your account?", isPresented: $isShowingDialog) {
                    Button("Delete Account", role: .destructive) {
                        authViewModel.signOut()
                    }
                    Button("Cancel", role: .cancel) {
                        isShowingDialog = false
                    }
                }
            }
            .padding(24)
        }
    }
}

#Preview {
    ProfileView()
}
