//
//  CurrencyModel.swift
//  CCMB
//
//  Created by Taha Tuna
//

import Foundation

struct CurrencyData: Codable {
    let meta: Meta
    let data: [String: Currency]
    
    struct Meta: Codable {
        let last_updated_at: String
    }
}

struct Currency: Codable {
    var code: String
    var value: Double
}

struct AllCurrencies: Codable {
    var name: String
    var symbol_native: String
    var code: String
}

struct CurrencyList: Codable {
    var data: [String: AllCurrencies]
}
