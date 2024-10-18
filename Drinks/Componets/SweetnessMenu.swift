//
//  SweetnessMenu.swift
//  Drinks
//
//  Created by Han on 2024/10/15.
//

import SwiftUI

struct SweetnessMenu: View {
    var sweetness: [String] = ["正常糖", "少糖", "半糖", "微糖", "二分糖", "一分糖", "無糖"]
    @State private var selectedSweetness: String = "正常糖"
    
    var selectedItem: (String) -> Void

    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack {
                Menu {
                    ForEach(sweetness, id: \.self) { sweetness in
                        Button(
                            action: {
                                selectedSweetness = sweetness
                                selectedItem(selectedSweetness)},
                            label: { Text(sweetness) })
                    }
                } label: {
                    HStack {
                        Text(selectedSweetness)
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
            
            Text("甜度")
                .padding([.horizontal], 5)
                .foregroundStyle(.accent)
                .background(getBgColor())
                .padding([.horizontal])
        }
        .padding()
        .background(.clear)
        .onAppear() {
            selectedItem(selectedSweetness)
        }
    }
}

#Preview {
    SweetnessMenu() {_ in }
}
