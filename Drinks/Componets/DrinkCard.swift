//
//  DrinkCard.swift
//  Drinks
//
//  Created by Han on 2024/9/13.
//

import SwiftUI

struct DrinkCard: View {
    var drinkName: String
    var drinkImg: String?
    var onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack {
                Rectangle()
                    .aspectRatio(0.95, contentMode: .fit)
                    .overlay {
                        let url = URL(string: drinkImg ?? "The_Book_by_YOASOBI")!
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Color.gray
                        }
                    }
                    .clipped()
                    .padding([.top, .horizontal], 10)
                HStack {
                    Text("—")
                        .font(.system(size: 25))
                        .foregroundStyle(.accent)
                        .padding(5)
                    Text(drinkName)
                        .font(.system(size: 20))
                        .foregroundStyle(.accent)
                    Text("—")
                        .font(.system(size: 25))
                        .foregroundStyle(.accent)
                        .padding(5)
                }
            }
            .background(getBgColor())
        }
    }
}

#Preview {
    DrinkCard(drinkName: "Test") {}
}
