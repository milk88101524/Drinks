//
//  Badge.swift
//  Drinks
//
//  Created by Han on 2024/10/17.
//

import SwiftUI

struct Badge: View {
    let count: Int
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.clear
            Text(String(count))
                .font(.system(size: 16))
                .padding(5)
                .background(.accent)
                .foregroundStyle(.white)
                .clipShape(Circle())
            // custom positioning in the top-right corner
                .alignmentGuide(.top) { $0[.bottom] }
                .alignmentGuide(.trailing) { $0[.trailing] - $0.width * 0.25 }
        }
    }
}
