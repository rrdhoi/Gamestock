//
//  DevelopersViewModel.swift
//  Gamestock
//
//  Created by IT on 12/02/24.
//

import Foundation
import Alamofire

class StoresViewModel: ObservableObject {
    @Published var stores: [StoresModel] = []
    @Published var detailStore: DetailStoresModel?

    @Published var isLoadStoresError: Bool = false
    @Published var isLoadDetailStoreError: Bool = false

    func getStoresData() async {
        let response = await AF.request(AppConfigs.API_STORES + "?key=\(AppConfigs.API_KEY)", method: .get)
            .cacheResponse(using: .cache)
            .serializingDecodable(StoresResponse.self)
            .response

        DispatchQueue.main.async {
            if response.error != nil {
                self.isLoadStoresError = true
            } else {
                self.stores = response.value?.results ?? []
            }
        }
    }

    func getDetailStoreData(id: Int) async {
        let response = await AF.request(AppConfigs.API_STORES + "/\(id)" + "?key=\(AppConfigs.API_KEY)", method: .get)
            .cacheResponse(using: .cache)
            .serializingDecodable(DetailStoresModel.self)
            .response

        DispatchQueue.main.async {
            if response.error != nil {
                self.isLoadDetailStoreError = true
            } else {
                self.detailStore = response.value
            }
        }
    }
}
