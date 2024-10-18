//
//  HomePage.swift
//  Drinks
//
//  Created by Han on 2024/9/13.
//

import SwiftUI

struct HomePage: View {
    private let drinkManager = DrinkManager()
    private let cartManager = CartManager()
    private let orderManager = OrderManager()
    
    var name: String = ""
    @State private var categoryList: [String] = []
    @State private var drinkList: [Drink] = []
    @State private var orderList: [Cart] = []
    @State private var total: Int = 0
    @State private var showDrinkSheet = false
    @State private var showCartSheet = false
    @State private var selectedDrink: Drink? = nil // 用於存儲選擇的飲品
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Hello")
                                .font(.title)
                                .foregroundStyle(.accent)
                                .padding([.horizontal, .top])
                            Text(name)
                                .font(.title)
                                .foregroundStyle(.accent)
                                .padding([.horizontal, .bottom])
                        }
                        Spacer()
                        NavigationLink(
                            destination: OrderPage(),
                            label: {
                                HStack {
                                    Image("order")
                                        .padding([.vertical, .leading])
                                    Text("團購明細")
                                        .font(.headline)
                                        .foregroundStyle(.accent)
                                        .padding([.vertical, .trailing])
                                }
                                
                                    .overlay(content: {
                                        RoundedRectangle(cornerRadius: 14).stroke(lineWidth: 2)
                                    })
                                    .overlay(
                                        (orderList.count > 0 ? Badge(count: orderList.count) : nil)
                                    )
                                    .padding()
                            }
                        )
                    }
                    .frame(maxWidth: .infinity)
                    // list
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 10) {
                            ForEach(categoryList, id: \.self) { category in
                                Chip(chipTitle: category) {
                                    drinkManager.searchDrink(by: category) { drinks in
                                        self.drinkList = drinks
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 55)
                    LazyVGrid(
                        columns: Array(repeating: GridItem(), count: 2)
                    ) {
                        ForEach(drinkList, id: \.self.name) { item in
                            DrinkCard(
                                drinkName: item.name,
                                drinkImg: item.img
                            ) {
                                selectedDrink = item
                                showDrinkSheet = true
                            }
                        }
                    }
                    .padding()
                }
                .padding([.top])
                .overlay(alignment: .bottomTrailing) {
                    NavigationLink(destination: CartPage()) {
                        FloatActionButton()
                            .overlay(
                                (total > 0 ? Badge(count: total) : nil)
                            )
                    }.padding(30)
                }
            }
            .frame(maxWidth: .infinity)
            .background(getBgColor())
            .onAppear {
                // 當畫面出現時，載入分類資料
                drinkManager.getCategory { categories in
                    self.categoryList = categories  // 更新 @State，觸發畫面更新
                }
                drinkManager.getDrinkName { drinks in
                    self.drinkList = drinks
                }
                cartManager.fetchCart { cartList in
                    total = 0
                    for cart in cartList {
                        total += Int(cart.count)!
                    }
                }
                orderManager.fetchOrders { orderList in
                    self.orderList = orderList
                }
            }
            .sheet(isPresented: Binding<Bool>(
                get: { selectedDrink != nil && showDrinkSheet },
                set: { newValue in
                    if !newValue {
                        selectedDrink = nil // 清空 selectedDrink 當 sheet 被關閉時
                        cartManager.fetchCart { cartList in
                            total = 0
                            for cart in cartList {
                                total += Int(cart.count)!
                            }
                        }
                    }
                }
            )) {
                if let drink = selectedDrink {
                    DrinkDetail(drink: drink, name: name)
                }
            }
        }
    }
}

#Preview {
    HomePage()
}
