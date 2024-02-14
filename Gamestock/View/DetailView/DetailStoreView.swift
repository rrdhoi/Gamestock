//
//  DetailGameView.swift
//  Gamestock
//
//  Created by IT on 08/02/24.
//

import Foundation
import SwiftUI
import Kingfisher

enum DetailType {
    case game, store
}

struct DetailStoreView: View {
    let id: Int
    @StateObject private var viewModel = StoresViewModel()
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
                    if viewModel.isLoadDetailStoreError {
                        VStack(alignment: .center, content: {
                            Text("Terjadi kesalahan, silahkan coba lagi")
                                .customFont(Fonts.poppinsLight, size: 14, color: Colors.blackColor)
                                .padding(.bottom, 8)

                            Button(action: {
                                Task {
                                    self.isLoading = true
                                    await viewModel.getDetailStoreData(id: id)
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
                    } else if let data = viewModel.detailStore {
                        DetailContentSection(
                            imageUrl: data.imageBackground,
                            title: data.name,
                            subTitle: data.domain ?? "-",
                            description: data.description ?? "-",
                            trailingText: data.gameCount != nil ? String(data.gameCount!) : "-",
                            trailingImage: AnyView(Image(systemName: "gamecontroller.fill")
                                                    .resizable()
                                                    .frame(width: 18, height: 18)
                                                    .foregroundStyle(Colors.orangeColor)
                                                    .padding(.trailing, 4)
                            )
                        )
                    }
                }
            }.background(Colors.bgColor.ignoresSafeArea())
        }.task {
            isLoading = true
            await viewModel.getDetailStoreData(id: self.id)
            isLoading = false
        }
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Colors.bgColor, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Detail Store")
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
