//
//  CartManager.swift
//  Drinks
//
//  Created by Han on 2024/10/17.
//

import Foundation

class CartManager {
    private var url = URL(string: "https://api.airtable.com/v0/appWGfuE25modmD0d/Drinks")!
    private var request: URLRequest
    private var AIRTABLE_API_KEY = "patyjW8yHd1cIRrxQ.4ee43e8302ed9be89bb00ed74339af553528828a171ad4d79552b6149cc295af"
    
    init() {
        self.request = URLRequest(url: url)
        self.request.setValue("Bearer \(self.AIRTABLE_API_KEY)", forHTTPHeaderField: "Authorization")
    }
    
    func findRecordID(id: String, completion: @escaping (String?) -> Void) {
        let url = URL(string: "https://api.airtable.com/v0/appWGfuE25modmD0d/Drinks?filterByFormula=({id} = '\(id)')")!
        var request: URLRequest = URLRequest(url: url)
        request.setValue("Bearer \(self.AIRTABLE_API_KEY)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // 錯誤處理
            if let error = error {
                print("錯誤: \(error)")
                completion(nil) // 回傳 nil
                return
            }
            
            // 檢查回應狀態碼
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("HTTP 狀態碼錯誤: \(String(describing: response))")
                completion(nil) // 回傳 nil
                return
            }
            
            // 確保接收到資料
            guard let data = data else {
                print("沒有收到資料")
                completion(nil) // 回傳 nil
                return
            }
            
            do {
                let cartRecords = try JSONDecoder().decode(Record.self, from: data)
                if let recordID = cartRecords.records.first?.id {
                    completion(recordID) // 回傳找到的 recordID
                } else {
                    print("沒有找到對應的記錄")
                    completion(nil) // 回傳 nil
                }
            } catch {
                print("解析錯誤: \(error)")
                completion(nil) // 回傳 nil
            }
        }.resume()
    }
    
    func fetchCart(completion: @escaping ([Cart]) -> Void) {
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
    
    func editCart(id: String, count: String, completion: @escaping () -> Void) {
        findRecordID(id: id) { recordID in
            guard let recordID = recordID else { return }
            
            let editUrl = URL(string: "https://api.airtable.com/v0/appWGfuE25modmD0d/Drinks/\(recordID)")!
            var editRequest = URLRequest(url: editUrl)
            editRequest.setValue("Bearer \(self.AIRTABLE_API_KEY)", forHTTPHeaderField: "Authorization")
            editRequest.httpMethod = "PATCH"
            editRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let editBody = [
                "fields": [
                    "count": count
                ]
            ]
            
            do {
                let bodyData = try JSONEncoder().encode(editBody)
                editRequest.httpBody = bodyData
                
                // 發送 PATCH 請求
                URLSession.shared.dataTask(with: editRequest) { data, response, error in
                    if let error = error {
                        print("更新錯誤: \(error)")
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        print("更新 HTTP 狀態碼錯誤: \(String(describing: response))")
                        return
                    }
                    
                    print("更新成功!")
                    
                    // 更新完成後呼叫 completion 回調
                    DispatchQueue.main.async {
                        completion()
                    }
                    
                }.resume()
            } catch {
                print("編碼請求主體時發生錯誤: \(error)")
            }
        }
    }
    
    func deleteCart(id: String, completion: @escaping () -> Void) {
        findRecordID(id: id, completion: { recordID in
            guard let recordID else { return }
            
            let deleteUrl = URL(string: "https://api.airtable.com/v0/appWGfuE25modmD0d/Drinks/\(recordID)")!
            var deleteRequest = URLRequest(url: deleteUrl)
            deleteRequest.httpMethod = "DELETE"
            deleteRequest.setValue("Bearer \(self.AIRTABLE_API_KEY)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: deleteRequest) { data, response, error in
                if let error = error {
                    print("更新錯誤: \(error)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("更新 HTTP 狀態碼錯誤: \(String(describing: response))")
                    return
                }
                
                print("更新成功!")
                
                // 更新完成後呼叫 completion 回調
                DispatchQueue.main.async {
                    completion()
                }
            }.resume()
        })
    }
}
