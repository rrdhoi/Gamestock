//
//  ContentView.swift
//  Gamestock
//
//  Created by IT on 07/02/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                Color("BgColor")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                ScrollView(.vertical,
                           showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        HeaderView().padding(.horizontal, 24)
                            .padding(.top, 30)
                        PopularGamesView().padding(.bottom, 30)
                        StoreGameView().padding(.horizontal, 24)
                    }
                }
            }.background(Colors.bgColor.ignoresSafeArea())
        }
    }
}

#Preview {
    ContentView()
}
