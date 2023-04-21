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
    
    @Published var secondCurrency: Currency = Currency(name: "USD", amount: 0.0)
    @Published var thirdCurrency: Currency = Currency(name: "TRY", amount: 0.0)
    @Published var fourthCurrency: Currency = Currency(name: "RUB", amount: 0.0)
    
    
    
    // MARK: Fetch the Currency data from the API
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
                
                print(self?.currencyData ?? "failed to print currencyData")
                
                func updateCurrencyAmount(for currency: inout Currency, with data: [String: Double], using currencyCodes: [String]) {
                    if let index = currencyCodes.firstIndex(where: { $0 == currency.name }) {
                        currency.amount = data[currencyCodes[index]]!
                    }
                }
                
                if let data = fetchedData?.data {
                    let currencyCodes = Array(data.keys)
                    print("currencyCodes")
                    
                    updateCurrencyAmount(for: &self!.secondCurrency, with: data, using: currencyCodes)
                    updateCurrencyAmount(for: &self!.thirdCurrency, with: data, using: currencyCodes)
                    updateCurrencyAmount(for: &self!.fourthCurrency, with: data, using: currencyCodes)
                    self?.objectWillChange.send()
                    print("\(self!.secondCurrency), \(self!.thirdCurrency), \(self!.fourthCurrency)")
                }
            }
            .store(in: &cancellables)
    }
}
