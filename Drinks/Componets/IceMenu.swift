//
//  IceMenu.swift
//  Drinks
//
//  Created by Han on 2024/10/15.
//

import SwiftUI

struct IceMenu: View {
    var ice: [String] = ["正常冰", "少冰", "微冰", "去冰", "完全去冰", "常溫", "溫", "熱"]
    @State private var selectedIce: String = "正常冰"
    
    var selectedItem: (String) -> Void

    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack {
                Menu {
                    ForEach(ice, id: \.self) { ice in
                        Button(
                            action: {
                                selectedIce = ice
                                selectedItem(selectedIce)},
                            label: { Text(ice) })
                    }
                } label: {
                    HStack {
                        Text(selectedIce)
                            .tint(.white)
                            .padding(5)
                        Spacer()
                        Image(uiImage: UIImage(named: "down")!)
                    }
                    .padding()
                    .background(.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding()
                }
            }
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(.accent, lineWidth: 4))
            .padding([.top], 12)
            
            Text("冰塊")
                .padding([.horizontal], 5)
                .foregroundStyle(.accent)
                .background(getBgColor())
                .padding([.horizontal])
        }
        .padding()
        .background(.clear)
        .onAppear() {
            selectedItem(selectedIce)
        }
    }
}

#Preview {
    IceMenu() { _ in}
}
