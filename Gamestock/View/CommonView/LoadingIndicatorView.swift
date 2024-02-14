//
//  LoadingIndicatorView.swift
//  Gamestock
//
//  Created by IT on 11/02/24.
//

import Foundation
import SwiftUI

struct LoadingIndicatorView: View {
    var body: some View {
        HStack(alignment: .center, content: {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Colors.greyColor))
                .scaleEffect(1.5)
                .padding(.all, 24)
                .frame(height: 100)
            Spacer()
        })
    }
}
