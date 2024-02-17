//
//  PopularGamesComponent.swift
//  Gamestock
//
//  Created by IT on 10/02/24.
//

import Foundation
import SwiftUI
import Kingfisher

struct PopularGamesView: View {
    @StateObject var viewModel = GamesViewModel()
    @State var isLoading = true

    var body: some View {
        if isLoading {
            VStack(alignment: .center, spacing: 0) {
                LoadingIndicatorView().task {
                    await viewModel.getGamesData()
                    self.isLoading = false
                }
            }.frame(maxWidth: .infinity, maxHeight: 220)
        } else {
            if viewModel.isLoadGamesError {
                VStack(alignment: .center, content: {
                    Text("Terjadi kesalahan, silahkan coba lagi")
                        .customFont(Fonts.poppinsLight, size: 14, color: Colors.blackColor)
                        .padding(.bottom, 8)

                    Button(action: {
                        Task {
                            self.isLoading = true
                            await viewModel.getGamesData()
                            self.isLoading = false
                        }
                    }, label: {
                        Text("Coba lagi")
                            .customFont(Fonts.poppinsMedium, size: 14, color: .white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 10)
                    }).background(Colors.blueColor)
                    .clipShape(.rect(cornerRadius: 8))
                }).frame(maxWidth: .infinity, minHeight: 180)
            } else {
                ScrollView(.horizontal,
                           showsIndicators: false,
                           content: {
                            LazyHStack(spacing: 16, content: {
                                ForEach(viewModel.games, id: \.id, content: { game in
                                    PopularGameItem(
                                        id: game.id,
                                        imageUrl: game.backgroundImage,
                                        rating: game.rating,
                                        title: game.name,
                                        subTitle: game.released ?? "-"
                                    )
                                })
                            }).padding(.horizontal, 24)
                           })
            }
        }
    }
}

struct PopularGameItem: View {
    var id: Int
    var imageUrl: String?
    var rating: CGFloat
    var title: String
    var subTitle: String

    @State private var isLoading: Bool = false

    var body: some View {
        NavigationLink(
            destination: DetailGameView(id: id)
        ) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    if let imageUrl = imageUrl,
                       let url = URL(string: imageUrl) {
                        KFImage(url)
                            .resizable()
                            .frame(width: 200, height: 220)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(.rect(cornerRadius: 18))

                        HStack(spacing: 0) {
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
                        }.padding(.bottom, 7)
                        .padding(.leading, 6).background(Color.white).clipShape(.rect(bottomLeadingRadius: 18))

                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 200, height: 220)
                            .clipShape(.rect(cornerRadius: 18))
                    }
                }.padding(.bottom, 20)

                VStack(alignment: .leading, spacing: 0, content: {
                    Text(title)
                        .customFont(Fonts.poppinsMedium, size: 18, color: Colors.blackColor)
                        .lineLimit(1)
                        .padding(.bottom, 5)
                    Text(subTitle)
                        .customFont(Fonts.poppinsLight, size: 14, color: Colors.subTitleColor)
                })
                .padding(.horizontal, 10)
                .padding(.bottom, 16)

            }.frame(width: 200)
            .padding([.horizontal, .top], 10)
            .background(.white)
            .clipShape(.rect(cornerRadius: 18))
        }
    }
}
