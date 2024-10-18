//
//  Cart.swift
//  Drinks
//
//  Created by Han on 2024/10/16.
//

import Foundation

struct CartRecords: Codable {
    let records: [CartRecord]
}

struct CartRecord: Codable {
    let fields: Cart
}

struct Cart: Codable {
    var id: String
    var size: String
    var sweetness: String
    var drinkName: String
    var name: String
    var ice: String
    var price: String
    var count: String
}

struct Record: Codable {
    let records: [FindRecordId]
}

struct FindRecordId: Codable {
    let id: String
}
