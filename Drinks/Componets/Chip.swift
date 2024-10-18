//
//  Chip.swift
//  Drinks
//
//  Created by Han on 2024/10/4.
//

import SwiftUI

struct Chip: View {
    var chipTitle: String
    var onTap: () -> Void = { }
    
    var body: some View {
        Button(
            action: onTap,
            label: {
                Text(chipTitle)
                    .padding()
                    .background(.accent)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        )
    }
}

#Preview {
    Chip(chipTitle: "Chip") {}
}
