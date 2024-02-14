//
//  FontModifier.swift
//  Gamestock
//
//  Created by IT on 08/02/24.
//

import Foundation
import SwiftUI

struct CustomFontModifier: ViewModifier {
    var fontName: String
    var size: CGFloat
    var color: Color

    func body(content: Content) -> some View {
        content.font(.custom(fontName, size: size)).foregroundStyle(color)
    }
}

extension View {
    func customFont(_ fontName: String, size: CGFloat, color: Color) -> some View {
        return self.modifier(CustomFontModifier(fontName: fontName, size: size, color: color))
    }
}
