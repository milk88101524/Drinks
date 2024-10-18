//
//  LoginPage.swift
//  Drinks
//
//  Created by Han on 2024/10/17.
//

import SwiftUI

struct LoginPage: View {
    
    @State private var name: String = ""
    @State private var showAlert = false  // 用來控制提示框
    @State private var navigateToHome = false  // 用來控制導航
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Image("kebuke")
                    .resizable()
                    .scaledToFit()
                    .padding()
                Text("今天    你想來杯可不可嗎")
                    .foregroundStyle(.accent)
                    .padding()
                HStack {
                    TextField("", text: $name)
                        .foregroundStyle(.accent)
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 14).stroke(.accent, lineWidth: 1)
                        }
                        .padding([.vertical, .leading])
                    Button(action: {
                        if (name != "") {
                            navigateToHome = true  // 當名稱不為空時，觸發導航
                        } else {
                            showAlert.toggle()
                        }
                        
                    }, label: {
                        FloatActionButton(img: "forward")
                            .padding()
                    })
                    .alert("Warning", isPresented: $showAlert, actions: {}, message: {
                        Text("名字不能為空")
                    })
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(getBgColor())
            .navigationDestination(isPresented: $navigateToHome) {
                HomePage(name: name)  // 這裡設定導航目標
            }
            
        }
    }
}

#Preview {
    LoginPage()
}
