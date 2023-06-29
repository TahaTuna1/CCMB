//
//  CurrencyViewModel.swift
//  CCMB
//
//  Created by Taha Tuna on 21.04.2023.
//

import Combine
import SwiftUI

class CurrencyViewModel: ObservableObject{
    @Published var currencyData: CurrencyData?
    @Published var isLoading = false
    @Published var allCurrencies: [AllCurrencies] = []
    @Published var currencyChanged: Bool = true
    
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var baseCurrency: Currency {
            didSet {
                UserDefaults.standard.set(baseCurrency.name, forKey: "baseCurrencyName")
            }
        }
    
    @Published var secondCurrency: Currency {
        didSet {
            UserDefaults.standard.set(secondCurrency.name, forKey: "secondCurrencyName")
        }
    }
    
    @Published var thirdCurrency: Currency {
        didSet {
            UserDefaults.standard.set(thirdCurrency.name, forKey: "thirdCurrencyName")
        }
    }
    
    @Published var fourthCurrency: Currency {
        didSet {
            UserDefaults.standard.set(fourthCurrency.name, forKey: "fourthCurrencyName")
        }
    }
    
    init() {
        let baseName = UserDefaults.standard.string(forKey: "baseCurrencyName") ?? "EUR"
        baseCurrency = Currency(name: baseName, amount: 0.0)
        
        let secondName = UserDefaults.standard.string(forKey: "secondCurrencyName") ?? "USD"
        secondCurrency = Currency(name: secondName, amount: 0.0)
        
        let thirdName = UserDefaults.standard.string(forKey: "thirdCurrencyName") ?? "TRY"
        thirdCurrency = Currency(name: thirdName, amount: 0.0)
        
        let fourthName = UserDefaults.standard.string(forKey: "fourthCurrencyName") ?? "RUB"
        fourthCurrency = Currency(name: fourthName, amount: 0.0)
    }
    
    // Last Update
    @Published var lastUpdate: Date = .distantPast
    
    
    // MARK: Fetch the Currency data from the API
    func fetchCurrencyData(currencies: [String]) {
        
        // Last update check
        let currentTime = Date()
        let timeDifference = Calendar.current.dateComponents([.hour], from: lastUpdate, to: currentTime).hour ?? 0
        
        if timeDifference < 1 && !currencyChanged {
            updateCurrencyData()
            print("No new network call. Currency Values updated.")
            return
        }
        
        let finalCurrencies = currencies.joined(separator: "%2C")
        print(finalCurrencies)
        
        guard let url = URL(string: "https://api.freecurrencyapi.com/v1/latest?apikey=\(apiKey)&currencies=\(finalCurrencies)&base_currency=\(baseCurrency.name)") else {
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
                self?.currencyChanged = false
                
            }
            .store(in: &cancellables)
    }
    //MARK: Updating Currency Data
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
    
    //MARK: Fetch Symbols and Codes from Local JSON
    func fetchSymbols() {
        if let url = Bundle.main.url(forResource: "CurrencyList", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let response = try JSONDecoder().decode(CurrencyList.self, from: data)
                
                
                
                DispatchQueue.main.async {
                    self.allCurrencies.removeAll()
                    for currency in response.data.values {
                        self.allCurrencies.append(currency)
                    }
                    self.allCurrencies.sort { $0.name < $1.name }
                    print("Current Currency List: \(self.allCurrencies)")
                }
            } catch {
                print("Couldn't fetch symbols. \(error.localizedDescription)")
            }
        }
    }
    
    
}
