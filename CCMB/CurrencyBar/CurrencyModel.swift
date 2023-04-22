//
//  CurrencyModel.swift
//  CCMB
//
//  Created by Taha Tuna on 21.04.2023.
//

import Foundation

struct CurrencyData: Codable {
    let data: [String: Double]
}

struct Currency {
    var name: String
    var amount: Double
}

struct AllCurrencies: Codable {
    var name: String
    var symbol_native: String
    var code: String
}

struct CurrencyList: Codable {
    var data: [String: AllCurrencies]
}
