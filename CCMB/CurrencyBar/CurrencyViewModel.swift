//
//  CurrencyViewModel.swift
//  CCMB
//
//  Created by Taha Tuna on 21.04.2023.
//

import Combine
import SwiftUI

class CurrencyViewModel: ObservableObject{
    @Published var baseCurrency: String = "EUR"
    @Published var currencyData: CurrencyData?
    
    private var cancellables = Set<AnyCancellable>()
    
    
    let apiKey = ""
    
    func fetchCurrencyData(currencies: [String]) {
        
        let finalCurrencies = currencies.joined(separator: "%2C")
        print(finalCurrencies)
        guard let url = URL(string: "https://api.freecurrencyapi.com/v1/latest?apikey=\(apiKey)&currencies=\(finalCurrencies)&base_currency=\(baseCurrency)") else {
            fatalError("Invalid URL")
        }
        
        print(url)
        
        
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: CurrencyData?.self, decoder: JSONDecoder())
            .catch { error -> Just<CurrencyData?> in
                print("Error fetching data: \(error.localizedDescription)")
                return Just(nil)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] fetchedData in
                self?.currencyData = fetchedData
                print(fetchedData ?? "Failed")
            }
            .store(in: &cancellables)
    }
}
