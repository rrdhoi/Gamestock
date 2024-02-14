//
//  APIError.swift
//  Gamestock
//
//  Created by IT on 14/02/24.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
    // Tambahkan case lain sesuai kebutuhan

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .requestFailed(let error):
            return "Request failed: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from the server"
        case .decodingFailed(let error):
            return "Decoding failed: \(error.localizedDescription)"
        // Tambahkan localizedDescription untuk case lain jika diperlukan
        }
    }
}
