//
//  DetailGameView.swift
//  Gamestock
//
//  Created by IT on 08/02/24.
//

import Foundation
import SwiftUI
import Kingfisher

struct DetailGameView: View {
    let id: Int
    @StateObject private var viewModel = GamesViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var isLoading: Bool = false
    @State var isLiked: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BgColor")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                if isLoading {
                    LoadingIndicatorView()
                } else {
                    if viewModel.isLoadDetailGamesError {
                        VStack(alignment: .center, content: {
                            Text("Terjadi kesalahan, silahkan coba lagi")
                                .customFont(Fonts.poppinsLight, size: 14, color: Colors.blackColor)
                                .padding(.bottom, 8)

                            Button(action: {
                                Task {
                                    DispatchQueue.main.sync { isLoading = true }
                                    await viewModel.getDetailGameData(id: id)
                                    DispatchQueue.main.sync { isLoading = false }
                                }
                            }, label: {
                                Text("Coba lagi")
                                    .customFont(Fonts.poppinsMedium, size: 14, color: .white)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 10)
                            }).background(Colors.blueColor)
                            .clipShape(.rect(cornerRadius: 8))
                        }).frame(maxWidth: .infinity, minHeight: .infinity)
                    } else if let data = viewModel.detailGame {
                        DetailContentSection(
                            imageUrl: data.backgroundImage,
                            title: data.name,
                            subTitle: data.released ?? "-",
                            description: data.description,
                            trailingText: String(describing: data.rating),
                            trailingImage: AnyView(Image(systemName: "star.fill")
                                                    .resizable()
                                                    .frame(width: 18, height: 18)
                                                    .foregroundStyle(Colors.orangeColor)
                                                    .padding(.trailing, 4))
                        )
                    }
                }
            }.background(Colors.bgColor.ignoresSafeArea())
        }.task {
            isLoading = true
            await viewModel.getDetailGameData(id: self.id)
            isLoading = false

            viewModel.getGame(id, completion: { result in
                isLiked = result != nil
            })
        }
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Colors.bgColor, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Detail Game")
        .navigationBarItems(
            leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "chevron.left")
                    .frame(width: 28, height: 28)
                    .padding(.all, 8)
                    .foregroundStyle(Colors.blackColor)

            }),
            trailing: Button(action: {
                Task {
                    if isLiked {
                        viewModel.deleteFavoriteGame(id, completion: {
                            isLiked = false
                        })

                        viewModel.loadFavoriteGames()

                    } else {
                        let gameData = viewModel.detailGame!
                        let data = GamesModel(
                            id: id,
                            name: gameData.name,
                            released: gameData.released,
                            backgroundImage: gameData.backgroundImage,
                            rating: gameData.rating
                        )

                        viewModel.insertFavoriteGame(data, completion: {
                            isLiked = true
                        })
                    }
                }
            }, label: {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .frame(width: 28, height: 28)
                    .padding(.all, 8)
                    .foregroundStyle(isLiked ? Colors.redColor : Colors.blackColor)
            }).isHidden(isLoading)
        )
    }
}
