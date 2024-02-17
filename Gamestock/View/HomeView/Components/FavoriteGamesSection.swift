//
//  FavoriteGamesSection.swift
//  Gamestock
//
//  Created by IT on 17/02/24.
//

import Foundation
import SwiftUI
import Kingfisher

struct FavoriteGamesSection: View {
    @StateObject var viewModel = GamesViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BgColor")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                if viewModel.isFavoriteLoading {
                    VStack(alignment: .center, spacing: 0) {
                        LoadingIndicatorView()
                    }.frame(maxWidth: .infinity, maxHeight: 400)
                } else {
                    if viewModel.favoriteGames.isEmpty {
                        VStack(alignment: .center, content: {
                            Text("Belum ada game yang disukai")
                                .customFont(Fonts.poppinsLight, size: 14, color: Colors.blackColor)
                                .padding(.bottom, 8)
                        }).frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView(.vertical,
                                   showsIndicators: false,
                                   content: {
                                    LazyVStack(alignment: .leading, spacing: 16, content: {
                                        ForEach(viewModel.favoriteGames, id: \.id) { game in
                                            FavoritegameItem(
                                                id: game.id,
                                                imageUrl: game.backgroundImage,
                                                title: game.name,
                                                subTitle: game.released ?? "-",
                                                rating: game.rating
                                            )
                                        }
                                    }).padding(.all, 24)

                                   }
                        )
                    }
                }
            }.toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Colors.bgColor, for: .navigationBar)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Favorite Games")
            .navigationBarItems(leading:
                                    Button(action: {
                                        self.presentationMode.wrappedValue.dismiss()
                                    }, label: {
                                        Image(systemName: "chevron.left")
                                            .frame(width: 28, height: 28)
                                            .padding(.all, 8)
                                            .foregroundStyle(Colors.blackColor)
                                    })
            )
        }.onAppear {
            viewModel.loadFavoriteGames()
        }
    }
}

struct FavoritegameItem: View {
    var id: Int
    var imageUrl: String?
    var title: String
    var subTitle: String
    var rating: CGFloat

    @State private var isLoading: Bool = false

    var body: some View {
        NavigationLink(
            destination: DetailGameView(id: id)
        ) {
            HStack(spacing: 0, content: {
                if let imageUrl = imageUrl,
                   let url = URL(string: imageUrl) {
                    KFImage(url)
                        .resizable()
                        .frame(width: 70, height: 70)
                        .aspectRatio(contentMode: .fill)
                        .clipShape(.rect(cornerRadius: 18))
                        .padding(.trailing, 16)

                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .clipShape(.rect(cornerRadius: 18))
                        .padding(.trailing, 16)
                        .foregroundStyle(Colors.greyColor)
                }

                VStack(alignment: .leading, spacing: 0, content: {
                    Text(title).customFont(Fonts.poppinsMedium, size: 18, color: Colors.blackColor)
                        .lineLimit(1)
                        .padding(.bottom, 5)

                    Text(subTitle).customFont(Fonts.poppinsLight, size: 14, color: Colors.subTitleColor)
                        .lineLimit(1)
                })
                Spacer()
                HStack(spacing: 0, content: {
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Colors.orangeColor)
                        .padding(.trailing, 4)

                    Text(String(format: "%.1f", rating))
                        .customFont(
                            Fonts.poppinsMedium,
                            size: 14,
                            color: Colors.blackColor
                        )
                })
            })
            .frame(alignment: .leading).padding(.all, 10)
            .background(Color.white)
            .clipShape(.rect(cornerRadius: 18))
        }
    }
}
