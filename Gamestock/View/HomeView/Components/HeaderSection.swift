//
//  HeaderSection.swift
//  Gamestock
//
//  Created by IT on 10/02/24.
//

import Foundation
import SwiftUI

struct HeaderView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Howdy,\nMuh Ridhoi")
                    .customFont(Fonts.poppinsSemiBold, size: 24, color: Colors.blackColor)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(6)

                Spacer()
                NavigationLink(destination: {
                    ProfileView()
                }, label: {
                    Image(.imgProfile)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(.circle)
                })
            }
            Text("What should we play today?")
                .customFont(Fonts.poppinsLight, size: 16, color: Colors.subTitleColor).padding(.bottom, 30)
        }
    }
}
