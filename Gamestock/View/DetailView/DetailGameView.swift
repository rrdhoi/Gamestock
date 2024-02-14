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
        NavigationView {
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
                                    self.isLoading = true
                                    await viewModel.getDetailGameData(id: id)
                                    self.isLoading = false
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
                isLiked = !isLiked
            }, label: {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .frame(width: 28, height: 28)
                    .padding(.all, 8)
                    .foregroundStyle(isLiked ? Colors.redColor : Colors.blackColor)
            })
        )
    }
}
