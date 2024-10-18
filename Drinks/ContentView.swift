//
//  ContentView.swift
//  Drinks
//
//  Created by Han on 2024/9/13.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    init() {
        applyNavigationBarBackground()
    }
    
    var body: some View {
        LoginPage()
    }
}

func applyNavigationBarBackground() {
    let navigationAppearance = UINavigationBarAppearance()
    navigationAppearance.configureWithTransparentBackground()
    navigationAppearance.backgroundColor = UIColor(getBgColor())
    navigationAppearance.shadowColor = .black
    UINavigationBar.appearance().standardAppearance = navigationAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance
}

#Preview {
    ContentView()
}
