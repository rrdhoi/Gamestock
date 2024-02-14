//
//  GamesModel.swift
//  Gamestock
//
//  Created by IT on 10/02/24.
//

import Foundation

struct GameResponse: Decodable {
    let results: [GamesModel]
}

struct GamesModel: Codable {
    let id: Int
    let name: String
    let released: String?
    let backgroundImage: String?
    let rating: CGFloat

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case released
        case backgroundImage = "background_image"
        case rating
    }
}
