//
//  OrderManager.swift
//  Drinks
//
//  Created by Han on 2024/10/17.
//

import Foundation

class OrderManager {
    private var url = URL(string: "https://api.airtable.com/v0/appWGfuE25modmD0d/Orders")!
    private var request: URLRequest
    private var AIRTABLE_API_KEY = "api_key"
    
    
    init() {
        self.request = URLRequest(url: url)
        self.request.setValue("Bearer \(self.AIRTABLE_API_KEY)", forHTTPHeaderField: "Authorization")
    }
    
    func fetchOrders(completion: @escaping ([Cart]) -> Void) {
        var carts: [Cart] = []
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion([])
                print("錯誤: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                completion([])
                print("HTTP 狀態碼錯誤: \(httpResponse.statusCode)")
                return
            }
            
            guard let data else {
                completion([])
                print("沒有收到資料")
                return
            }
            
            do {
                // 將資料解碼為 CartRecords 結構
                let cartRecords = try JSONDecoder().decode(CartRecords.self, from: data)
                for record in cartRecords.records {
                    carts.append(record.fields)
                }
                completion(carts)
            } catch {
                print("JSON 解析失敗: \(error)")
                completion([])
            }
        }.resume()
    }
    
    func addToCart(cart: Cart) {
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = CartRecords(records: [CartRecord(fields: cart)])
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(body)
            request.httpBody = data
        } catch {
            print(error)
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else { return }
            guard let content = String(data: data, encoding: .utf8) else { return }
            print(content)
            
            if let error = error {
                print("錯誤: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("HTTP 狀態碼錯誤: \(httpResponse.statusCode)")
                return
            }
        }.resume()
    }
}
