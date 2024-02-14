//
//  DevelopersModel.swift
//  Gamestock
//
//  Created by IT on 12/02/24.
//

import Foundation

struct StoresResponse: Decodable {
    let results: [StoresModel]
}

struct StoresModel: Codable {
    let id: Int
    let name: String
    let domain: String?
    let imageBackground: String?
    let gameCount: Int

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case domain
        case imageBackground = "image_background"
        case gameCount = "games_count"
    }
}
