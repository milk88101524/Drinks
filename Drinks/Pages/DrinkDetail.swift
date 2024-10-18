//
//  DrinkDetail.swift
//  Drinks
//
//  Created by Han on 2024/9/18.
//

import SwiftUI

struct DrinkDetail: View {
    var drink: Drink
    var name: String = ""
    
    private let cartManager = CartManager()
    @State private var selectSizePrice: Int = 0
    @State private var selectSize: String = ""
    @State private var selectSweetness: String = ""
    @State private var selectIce: String = ""
    
    // 使用 @Environment(\.dismiss) 來控制 sheet 的顯示與關閉
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Rectangle()
                        .aspectRatio(CGFloat(16) / 9, contentMode: .fit)
                        .overlay {
                            let url = URL(string: drink.img)
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Color.gray
                            }
                        }
                        .clipped()
                    HStack {
                        Text(drink.name)
                            .font(.system(size: 24))
                            .foregroundStyle(.accent)
                            .padding()
                        Spacer()
                        Text("NT$ \(selectSizePrice)")
                            .foregroundStyle(.accent)
                            .font(.system(size: 24))
                            .padding()
                    }
                    Text(drink.desc)
                        .font(.system(size: 20))
                        .foregroundStyle(.accent)
                        .padding([.horizontal])
                    SizeMenu() { size in
                        selectSize = size
                        if size == "M" {
                            selectSizePrice = drink.price.M
                        } else if size == "L" {
                            selectSizePrice = drink.price.L
                        }
                    }
                    SweetnessMenu { sweetness in
                        selectSweetness = sweetness
                    }
                    IceMenu { ice in
                        selectIce = ice
                    }
                }
            }
            .frame(maxHeight: .infinity)
            VStack(alignment: .leading) {
                Text("\(drink.name) , \(selectSize) , \(selectSweetness) , \(selectIce)\nNT$ \(selectSizePrice)")
                    .foregroundStyle(.white)
                    .padding()
                Button(
                    action: {
                        // add to cart
                        cartManager.addToCart(cart: Cart(id: UUID().uuidString, size: selectSize, sweetness: selectSweetness, drinkName: drink.name, name: name, ice: selectIce, price: String(selectSizePrice), count: "1"))
                        
                        
                        // close sheet
                        dismiss()
                    },
                    label: {
                        HStack {
                            Image(uiImage: UIImage(named: "desk")!)
                            Text("加入購物車")
                                .foregroundStyle(.white)
                        }
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(.accent)
                    }
                )
            }
            .frame(maxWidth: .infinity)
            .background(getBgColor().shadow(.inner(color: .black.opacity(0.6), radius: 10)))
        }
        .background(getBgColor())
    }
}

#Preview {
    let test = Drink(name: "Test", price: DrinkPrice(M: 10, L: 20), desc: "Test", img: "")
    DrinkDetail(drink: test)
}
