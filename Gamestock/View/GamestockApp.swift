//
//  GamestockApp.swift
//  Gamestock
//
//  Created by IT on 07/02/24.
//

import SwiftUI

@main
struct GamestockApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("Hp Kentang")
        }
    }
}
