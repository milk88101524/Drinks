//
//  CartPage.swift
//  Drinks
//
//  Created by Han on 2024/10/15.
//

import SwiftUI

struct CartPage: View {
    private let cartManager = CartManager()
    private let orderManager = OrderManager()
    
    @State private var cartList: [Cart] = []
    @State private var totalPrice: Int = 0
    @State private var total: Int = 0
    
    // 使用 @Environment(\.dismiss) 來控制 navigation 的 pop
    @Environment(\.dismiss) private var dismiss
    
    func updateUI() {
        total = 0
        totalPrice = 0
        cartManager.fetchCart { cartList in
            self.cartList = cartList
            for cart in cartList {
                totalPrice += Int(cart.price)! * Int(cart.count)!
                total += Int(cart.count)!
            }
        }
    }
    
    var body: some View {
        VStack {
            List {
                ForEach($cartList, id: \.self.id) { $item in
                    CartCard(
                        cart: item,
                        onIncrement: {
                            if let count = Int(item.count) {
                                item.count = String(count + 1)
                                cartManager.editCart(id: item.id, count: item.count, completion: {
                                    updateUI()
                                })
                            }
                        },
                        onDecrement: {
                            if let count = Int(item.count), count > 0 {
                                item.count = String(count - 1)  // 將數量減 1
                                if count - 1 == 0 {
                                    // 如果數量變成 0，刪除該項目
                                    cartManager.deleteCart(id: item.id, completion: {
                                        updateUI()
                                    })
                                } else {
                                    // 如果數量不為 0，則只更新數量
                                    cartManager.editCart(id: item.id, count: item.count, completion: {
                                        updateUI()
                                    })
                                }
                            }
                        }
                    )
                }
                .listRowInsets(EdgeInsets())
                .listRowSpacing(.infinity)
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .background(Color.clear)
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("杯數")
                            .foregroundStyle(.accent)
                            .padding([.horizontal, .top])
                        Text("\(total)")
                            .foregroundStyle(.accent)
                            .padding([.horizontal, .bottom])
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("總計")
                            .foregroundStyle(.accent)
                            .padding([.horizontal, .top])
                        Text("NT$ \(totalPrice)")
                            .foregroundStyle(.accent)
                            .padding([.horizontal, .bottom])
                    }
                }
                Button(action: {
                    // 使用 DispatchGroup 來管理多個異步操作
                    let dispatchGroup = DispatchGroup()
                    
                    for order in cartList {
                        dispatchGroup.enter() // 進入 DispatchGroup
                        
                        orderManager.addToCart(cart: order)
                        cartManager.deleteCart(id: order.id) {
                            dispatchGroup.leave() // 當刪除完成後離開 DispatchGroup
                        }
                    }
                    
                    // 等待所有的刪除操作完成
                    dispatchGroup.notify(queue: .main) {
                        // 在所有的刪除操作完成後再 dismiss
                        updateUI() // 更新 UI
                        dismiss() // 關閉視圖
                    }
                }, label: {
                    HStack {
                        Image(uiImage: UIImage(named: "desk")!)
                        Text("結帳")
                            .foregroundStyle(.white)
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(.accent)
                })
            }
            .frame(maxWidth: .infinity)
            .background(getBgColor().shadow(.inner(color: .black.opacity(0.6), radius: 10)))
        }
        .background(getBgColor())
        .onAppear() {
            updateUI()
        }
    }
}

#Preview {
    CartPage()
}
