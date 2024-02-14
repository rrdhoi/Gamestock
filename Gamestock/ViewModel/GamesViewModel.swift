//
//  GamesViewModel.swift
//  Gamestock
//
//  Created by IT on 10/02/24.
//

import Foundation
import Alamofire

class GamesViewModel: ObservableObject {
    @Published var games: [GamesModel] = []
    @Published var detailGame: DetailGamesModel?

    @Published var isLoadGamesError: Bool = false
    @Published var isLoadDetailGamesError: Bool = false

    func getGamesData() async {
        let response = await AF.request(AppConfigs.API_GAMES + "?key=\(AppConfigs.API_KEY)", method: .get)
            .cacheResponse(using: .cache)
            .serializingDecodable(GameResponse.self)
            .response

        DispatchQueue.main.async {
            if response.error != nil {
                self.isLoadGamesError = true
            } else {
                self.games = response.value?.results ?? []
                print(self.games)
            }
        }
    }

    func getDetailGameData(id: Int) async {
        let response = await AF.request(AppConfigs.API_GAMES + "/\(id)" + "?key=\(AppConfigs.API_KEY)", method: .get)
            .cacheResponse(using: .cache)
            .serializingDecodable(DetailGamesModel.self)
            .response

        DispatchQueue.main.async {
            if response.error != nil {
                self.isLoadDetailGamesError = true
            } else {
                self.detailGame = response.value
            }
        }
    }
}

struct APIError {
    let code: Int
    let message: String
}

enum GamesAPIResponse {
    case Success([GamesModel])
    case Fail(APIError)
}
