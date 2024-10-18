//
//  OrderCard.swift
//  Drinks
//
//  Created by Han on 2024/10/18.
//

import SwiftUI

struct OrderCard: View {
    var cart: Cart
    
    var body: some View {
        HStack(alignment: .top) {
            Rectangle()
                .frame(width: 100, height: 100)
                .aspectRatio(0.95, contentMode: .fill)
                .overlay {
                    let url = URL(string: "https://raw.githubusercontent.com/milk88101524/kebukeMenu/main/\(cart.drinkName).jpg")!
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .frame(width: 100, height: 100)
                            .scaledToFill()
                    } placeholder: {
                        Color.gray
                    }
                }
            VStack(alignment: .leading) {
                Text(cart.name)
                    .font(.headline)
                    .foregroundStyle(.accent)
                Text(cart.drinkName)
                    .font(.subheadline)
                    .foregroundStyle(.accent)
                Text(cart.size)
                    .font(.subheadline)
                    .foregroundStyle(.accent)
                Text(cart.sweetness)
                    .font(.subheadline)
                    .foregroundStyle(.accent)
                Text(cart.ice)
                    .font(.subheadline)
                    .foregroundStyle(.accent)
            }
            .padding([.horizontal], 1)
            Spacer()
            Text("NT$ \(cart.price) x\(cart.count)")
                .font(.headline)
                .foregroundStyle(.accent)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(getBgColor())
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(content: {
            RoundedRectangle(cornerRadius: 14).stroke(.accent, lineWidth: 3)
        })
        .padding()
        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 10)
    }
}


#Preview {
    let test = Cart(id: UUID().uuidString, size: "L", sweetness: "no", drinkName: "Test", name: "Han", ice: "no", price: "40", count: "1")
    OrderCard(cart: test)
}
