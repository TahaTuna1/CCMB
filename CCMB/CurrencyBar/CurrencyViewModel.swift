//
//  CurrencyViewModel.swift
//  CCMB
//
//  Created by Taha Tuna on 21.04.2023.
//

import Combine
import SwiftUI

class CurrencyViewModel: ObservableObject{
    @Published var baseCurrency: String = "EUR" // Default base currency
    @Published var currencyData: CurrencyData?
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var secondCurrency: Currency = Currency(name: "USD", amount: 0.0)
    @Published var thirdCurrency: Currency = Currency(name: "TRY", amount: 0.0)
    @Published var fourthCurrency: Currency = Currency(name: "RUB", amount: 0.0)
    
    // Last Update
    @Published var lastUpdate: Date = .distantPast
    
    
    // MARK: Fetch the Currency data from the API
    func fetchCurrencyData(currencies: [String]) {
        
        // Last update check
        let currentTime = Date()
        let timeDifference = Calendar.current.dateComponents([.hour], from: lastUpdate, to: currentTime).hour ?? 0
        
        if timeDifference < 1 {
            updateCurrencyData()
            print("No new network call. Currency Values updated.")
            return
        }
        
        let finalCurrencies = currencies.joined(separator: "%2C")
        print(finalCurrencies)
        
        guard let url = URL(string: "https://api.freecurrencyapi.com/v1/latest?apikey=\(apiKey)&currencies=\(finalCurrencies)&base_currency=\(baseCurrency)") else {
            fatalError("Invalid URL")
        }
        print(url)
        
        
        self.isLoading = true
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: CurrencyData?.self, decoder: JSONDecoder())
            .catch { error -> Just<CurrencyData?> in
                print("Error fetching data: \(error.localizedDescription)")
                return Just(nil)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] fetchedData in
                
                print("Network Call made.")
                self?.currencyData = fetchedData
                print(self?.currencyData ?? "failed to print currencyData")
                self?.lastUpdate = Date()
                self?.updateCurrencyData()
                
                
            }
            .store(in: &cancellables)
    }
    private func updateCurrencyData() {
        func updateCurrencyAmount(for currency: inout Currency, with data: [String: Double], using currencyCodes: [String]) {
            if let index = currencyCodes.firstIndex(where: { $0 == currency.name }) {
                currency.amount = data[currencyCodes[index]]!
            }
        }
        print(self.lastUpdate)
        if let data = currencyData?.data {
            let currencyCodes = Array(data.keys)
            
            updateCurrencyAmount(for: &secondCurrency, with: data, using: currencyCodes)
            updateCurrencyAmount(for: &thirdCurrency, with: data, using: currencyCodes)
            updateCurrencyAmount(for: &fourthCurrency, with: data, using: currencyCodes)
            
            print("\(secondCurrency), \(thirdCurrency), \(fourthCurrency)")
            self.isLoading = false
        }
    }
}
