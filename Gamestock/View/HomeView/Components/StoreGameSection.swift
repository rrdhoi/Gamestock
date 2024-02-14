//
//  NewThisYearGameComponent.swift
//  Gamestock
//
//  Created by IT on 10/02/24.
//

import Foundation
import SwiftUI
import Kingfisher

struct StoreGameView: View {
    @StateObject var viewModel = StoresViewModel()
    @State private var isLoading: Bool = true

    var body: some View {
        VStack(spacing: 0, content: {
            Text("Popular Store")
                .customFont(Fonts.poppinsSemiBold,
                            size: 18,
                            color: Colors.blackColor
                ).padding(.bottom, 16)
        })
        if isLoading {
            VStack(alignment: .center, spacing: 0) {
                LoadingIndicatorView()
                    .task {
                        await viewModel.getStoresData()
                        self.isLoading = false
                    }
            }.frame(maxWidth: .infinity, maxHeight: 400)
        } else {
            if viewModel.isLoadStoresError {
                VStack(alignment: .center, content: {
                    Text("Terjadi kesalahan, silahkan coba lagi")
                        .customFont(Fonts.poppinsLight, size: 14, color: Colors.blackColor)
                        .padding(.bottom, 8)

                    Button(action: {
                        Task {
                            self.isLoading = true
                            await viewModel.getStoresData()
                            self.isLoading = false
                        }
                    }, label: {
                        Text("Coba lagi")
                            .customFont(Fonts.poppinsMedium, size: 14, color: .white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 10)
                    }).background(Colors.blueColor)
                    .clipShape(.rect(cornerRadius: 8))
                }).frame(maxWidth: .infinity, minHeight: 140)
            } else {
                ScrollView(.vertical,
                           showsIndicators: false,
                           content: {
                            VStack(alignment: .center, spacing: 16, content: {
                                ForEach(viewModel.stores, id: \.id) { store in
                                    StoreGameItem(
                                        id: store.id,
                                        imageUrl: store.imageBackground,
                                        gameCount: store.gameCount,
                                        title: store.name,
                                        domain: store.domain ?? "-"
                                    )
                                }
                            })
                           }
                ).frame(height: 400)
            }
        }

    }
}

struct StoreGameItem: View {
    var id: Int
    var imageUrl: String?
    var gameCount: Int
    var title: String
    var domain: String

    @State private var isLoading: Bool = false

    var body: some View {
        NavigationLink(
            destination: DetailStoreView(id: id)
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

                    Text(domain).customFont(Fonts.poppinsLight, size: 14, color: Colors.subTitleColor)
                        .lineLimit(1)
                })
                Spacer()
            })
            .frame(alignment: .leading).padding(.all, 10)
            .background(Color.white)
            .clipShape(.rect(cornerRadius: 18))
        }
    }
}
