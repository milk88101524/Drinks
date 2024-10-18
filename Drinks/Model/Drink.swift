//
//  Drink.swift
//  Drinks
//
//  Created by Han on 2024/10/4.
//

import Foundation

// 定義飲料分類模型
struct DrinkCategory: Codable {
    let category: String
    let drinks: [Drink]
}

// 定義飲料模型
struct Drink: Codable {
    let name: String
    let price: DrinkPrice
    let desc: String
    let img: String
}

// 定義價格模型
struct DrinkPrice: Codable {
    let M: Int
    let L: Int
}
