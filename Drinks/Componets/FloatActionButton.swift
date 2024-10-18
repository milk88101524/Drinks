//
//  FloatActionButton.swift
//  Drinks
//
//  Created by Han on 2024/9/13.
//

import SwiftUI

struct FloatActionButton: View {
    var width: CGFloat? = 60
    var height: CGFloat? = 60
    var img: String = "shopping_cart"
    
    var body: some View {
        VStack {
            Image(uiImage: UIImage(named: img)!)
                .foregroundStyle(.teal, .white)
                .padding()
                .frame(maxWidth: width, maxHeight: height)
                .background(getBgColor())
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(.accent, lineWidth: 4))
        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 10)
    }
}

#Preview {
    FloatActionButton()
}
