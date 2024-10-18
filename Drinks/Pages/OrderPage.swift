//
//  OrderPage.swift
//  Drinks
//
//  Created by Han on 2024/10/17.
//

import SwiftUI

struct OrderPage: View {
    private var orderManager = OrderManager()
    
    @State private var orderList: [Cart] = []
    
    var body: some View {
        VStack {
            List {
                ForEach(orderList, id: \.self.id) { order in
                    OrderCard(cart: order)
                }
                .listRowInsets(EdgeInsets())
                .listRowSpacing(.infinity)
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .background(Color.clear)
        }
        .background(getBgColor())
        .onAppear() {
            orderManager.fetchOrders(completion: { orders in
                self.orderList = orders
            })
        }
    }
}

#Preview {
    OrderPage()
}
