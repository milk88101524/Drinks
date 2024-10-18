//
//  DrinkManager.swift
//  Drinks
//
//  Created by Han on 2024/10/11.
//

import Foundation

class DrinkManager {
    let urlString = "https://raw.githubusercontent.com/milk88101524/kebukeMenu/main/kebukeMenu.json"
    
    func getCategory(completion: @escaping ([String]) -> Void) {
        var categoryNames: [String] = []
        
        categoryNames.append("全部")
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    do {
                        let categories = try JSONDecoder().decode([DrinkCategory].self, from: data)
                        // 取得所有 category 的名稱並加入 categoryNames
                        categories.forEach { category in
                            categoryNames.append(category.category)
                        }
                        
                        // 在非同步操作完成後，通過 completion 回傳結果
                        completion(categoryNames)
                        
                    } catch {
                        print("解析失敗: \(error)")
                        completion([]) // 若解析失敗，回傳空陣列
                    }
                } else {
                    completion([]) // 若資料為 nil，回傳空陣列
                }
            }.resume()
        } else {
            completion([]) // 若 URL 無效，回傳空陣列
        }
    }
    
    func getDrinkName(completion: @escaping ([Drink]) -> Void) {
        var drinkNames: [Drink] = []
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    do {
                        let drinkCategories = try JSONDecoder().decode([DrinkCategory].self, from: data)
                        // 從每個 category 的 drinks 中提取名稱
                        for category in drinkCategories {
                            drinkNames.append(contentsOf: category.drinks)
                        }
                        completion(drinkNames)
                    } catch {
                        print("解析失敗: \(error)")
                        completion([]) // 若解析失敗，回傳空陣列
                    }
                } else {
                    completion([])
                }
            }.resume()
        } else {
            completion([])
        }
    }
    
    func searchDrink(by category: String, completion: @escaping ([Drink]) -> Void) {
        var filteredDrinks: [Drink] = []
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    do {
                        // 解析 JSON 並取得所有的 DrinkCategory
                        let drinkCategories = try JSONDecoder().decode([DrinkCategory].self, from: data)
                        
                        if category == "全部" {
                            // 如果選擇 "全部"，回傳所有飲料
                            for drinkCategory in drinkCategories {
                                filteredDrinks.append(contentsOf: drinkCategory.drinks)
                            }
                        } else {
                            // 過濾特定分類的飲料
                            if let selectedCategory = drinkCategories.first(where: { $0.category == category }) {
                                filteredDrinks = selectedCategory.drinks
                            }
                        }
                        
                        // 回傳篩選後的飲料
                        completion(filteredDrinks)
                        
                    } catch {
                        print("解析失敗: \(error)")
                        completion([]) // 解析失敗，回傳空陣列
                    }
                } else {
                    completion([]) // 如果資料為 nil，回傳空陣列
                }
            }.resume()
        } else {
            completion([]) // 如果 URL 無效，回傳空陣列
        }
    }
    
}
