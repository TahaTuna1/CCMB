//
//  CCMBApp.swift
//  CCMB
//
//  Created by Taha Tuna
//

import SwiftUI

@main
struct CCMBApp: App {
    
    var viewModel = CurrencyViewModel()
    
    var body: some Scene {
        
        
        
        //Paywall
        WindowGroup {
                PaywallView()
                    .environmentObject(viewModel)
                    .frame(width: 900)
                    .fixedSize()
        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
        
        
        MenuBarExtra{
            CurrencyBarView()
                .environmentObject(viewModel)
            
        }label: {
            Image(systemName: "dollarsign.circle")
        }
        .menuBarExtraStyle(.window)
        
        // MARK: Menu Bar Style
        // 1. Menu (List Type)
        // 2. Window (View Type)
        
        
    }
}

