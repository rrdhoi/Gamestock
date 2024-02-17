//
//  DetailGamesModel.swift
//  Gamestock
//
//  Created by IT on 12/02/24.
//

import Foundation

struct DetailGamesModel: Decodable {
    let id: Int
    let name: String
    let released: String?
    let backgroundImage: String?
    let rating: CGFloat
    let description: String

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case released
        case backgroundImage = "background_image"
        case rating
        case description = "description_raw"
    }
}
