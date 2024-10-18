//
//  SizeMenu.swift
//  Drinks
//
//  Created by Han on 2024/10/15.
//

import SwiftUI

struct SizeMenu: View {
    @State private var selectedSize: String = "M"
    
    var selectedItem: (String) -> Void
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack {
                Menu {
                    Button(
                        action: {
                            selectedSize = "M"
                            selectedItem(selectedSize)
                        },
                        label: {
                            Text("M")
                        }
                    )
                    Button(
                        action: {
                            selectedSize = "L"
                            selectedItem(selectedSize)
                        },
                        label: {
                            Text("L")
                        }
                    )
                } label: {
                    HStack {
                        Text(selectedSize)
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
            
            Text("尺寸")
                .padding([.horizontal], 5)
                .foregroundStyle(.accent)
                .background(getBgColor())
                .padding([.horizontal])
        }
        .padding()
        .background(.clear)
        .onAppear() {
            selectedItem(selectedSize)
        }
    }
}

#Preview {
    SizeMenu() {_ in }
}
