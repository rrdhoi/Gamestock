//
//  DetailStoresModel.swift
//  Gamestock
//
//  Created by IT on 12/02/24.
//

import Foundation

struct DetailStoresModel: Decodable {
    let id: Int
    let name: String
    let domain: String?
    let imageBackground: String
    let gameCount: Int?
    let description: String?

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case domain
        case imageBackground = "image_background"
        case gameCount = "games_count"
        case description
    }
}
