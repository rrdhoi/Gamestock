//
//  ProfileView.swift
//  Gamestock
//
//  Created by IT on 13/02/24.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        NavigationView {
            VStack(
                spacing: 0,
                content: {
                    Image(.imgProfile)
                        .resizable()
                        .frame(width: 180, height: 180)
                        .clipShape(.circle)
                        .padding(.bottom, 16)

                    Text("Muhammad Ridhoi")
                        .customFont(Fonts.poppinsMedium, size: 18, color: Colors.blackColor)
                        .padding(.bottom, 8)
                    Text(.init("[LinkedIn Profile](https://www.linkedin.com/in/rrdhoi/)"))
                        .customFont(Fonts.poppinsLight, size: 14, color: Colors.blueColor)
                        .padding(.bottom, 16)

                    NavigationLink(
                        destination: FavoriteGamesSection()
                    ) {
                        Text("Daftar Game Favorite")
                            .customFont(Fonts.poppinsLight, size: 14, color: Colors.blueColor)
                            .underline()
                            .padding(.bottom, 16)
                    }

                })

        }.toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Colors.bgColor, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Profile")
        .navigationBarItems(
            leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "chevron.left")
                    .frame(width: 28, height: 28)
                    .padding(.all, 8)
                    .foregroundStyle(Colors.blackColor)

            })
        )
    }
}

#Preview {
    ProfileView()
}
