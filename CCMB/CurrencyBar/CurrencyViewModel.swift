//
//  CurrencyViewModel.swift
//  CCMB
//
//  Created by Taha Tuna
//


//TODO: Things to work on
//
// When the Value is too low, it displays as 0. For example, 1 euro is 0.00 BTC but it should be 0.000036
//

import Combine
import SwiftUI

class CurrencyViewModel: ObservableObject{
    
    @Published var currencyData: CurrencyData?
    @Published var isLoading = false
    @Published var allCurrencies: [AllCurrencies] = []
    @Published var currencyChanged: Bool = true
    
    private var cancellable = Set<AnyCancellable>()
    
    //Currencies
    @Published var baseCurrency: Currency {
        didSet {
            UserDefaults.standard.set(baseCurrency.code, forKey: "baseCurrencyName")
        }
    }
    //MARK: Second - Third - Fourth Currencies
    @Published var secondCurrency: Currency {
        didSet {
            guard secondCurrency.code != oldValue.code else { return }
            UserDefaults.standard.set(secondCurrency.code, forKey: "secondCurrencyName")
            updateCurrencyData()
        }
    }
    @Published var thirdCurrency: Currency {
        didSet {
            guard thirdCurrency.code != oldValue.code else { return }
            UserDefaults.standard.set(thirdCurrency.code, forKey: "thirdCurrencyName")
            updateCurrencyData()
        }
    }
    @Published var fourthCurrency: Currency {
        didSet {
            guard fourthCurrency.code != oldValue.code else { return }
            UserDefaults.standard.set(fourthCurrency.code, forKey: "fourthCurrencyName")
            updateCurrencyData()
        }
    }
    
    //Theme Variable
    @Published var currentTheme: AppTheme = AppTheme.theme1 {
        didSet {
            saveCurrentTheme()
        }
    }
    
    
    //Paywall
    
    @Published var isSubscribed = true
    @Published var togglePaywall = false
    
    init() {
        let baseName = UserDefaults.standard.string(forKey: "baseCurrencyName") ?? "EUR"
        baseCurrency = Currency(code: baseName, value: 0.0)
        
        let secondName = UserDefaults.standard.string(forKey: "secondCurrencyName") ?? "USD"
        secondCurrency = Currency(code: secondName, value: 0.0)
        
        let thirdName = UserDefaults.standard.string(forKey: "thirdCurrencyName") ?? "TRY"
        thirdCurrency = Currency(code: thirdName, value: 0.0)
        
        let fourthName = UserDefaults.standard.string(forKey: "fourthCurrencyName") ?? "RUB"
        fourthCurrency = Currency(code: fourthName, value: 0.0)
        
        //Get saved theme from UserDefaults
        self.loadCurrentTheme()
    }
    
    // Last Update
    @Published var lastUpdate: Date = .distantPast
    
    //MARK: Fetch Currency Data from API
    func fetchCurrencyData() {
        // Last update check
        let currentTime = Date()
        let timeDifference = Calendar.current.dateComponents([.hour], from: lastUpdate, to: currentTime).hour ?? 0
        
        if timeDifference < 1 && !currencyChanged {
            updateCurrencyData()
            print("No new network call. Currency Values updated.")
            return
        }
        //MARK: API URL
        guard let url =
                URL(string: "https://api.currencyapi.com/v3/latest?apikey=\(apiKey)&currencies=&base_currency=\(baseCurrency.code)")
        else {
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
                self?.lastUpdate = Date()
                self?.updateCurrencyData()
                self?.currencyChanged = false
            }
            .store(in: &cancellable)
    }
    
    //MARK: Update Currency Data
    private func updateCurrencyData() {
        func updateCurrencyAmount(for currency: inout Currency) {
            if let currencyInfo = currencyData?.data[currency.code] {
                let rate = currencyInfo.value
                if rate != currency.value {
                    currency.value = rate
                }
            }
        }
        
        
        print("Updated. Last Network Call: \(self.lastUpdate.formatted())")
        
        updateCurrencyAmount(for: &secondCurrency)
        updateCurrencyAmount(for: &thirdCurrency)
        updateCurrencyAmount(for: &fourthCurrency)
        
        print("\(secondCurrency), \(thirdCurrency), \(fourthCurrency)")
        self.isLoading = false
    }
    
    //MARK: Fetch Symbols and Codes from Local JSON on launch
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
                    print("Currency List Fetched.")
                }
            } catch {
                print("Couldn't fetch symbols. \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: Save theme on change to UserDefaults
    func saveCurrentTheme() {
        UserDefaults.standard.set(currentTheme.themeKey.rawValue, forKey: "currentThemeKey")
    }
    
    //MARK: Load current theme from UserDefaults
    func loadCurrentTheme() {
        if let savedThemeKey = UserDefaults.standard.string(forKey: "currentThemeKey"), let themeKey = ThemeKey(rawValue: savedThemeKey) {
            switch themeKey {
            case .theme1:
                currentTheme = AppTheme.theme1
            case .theme2:
                currentTheme = AppTheme.theme2
            }
        }
        // else keep the default theme (AppTheme.theme1)
    }
}
