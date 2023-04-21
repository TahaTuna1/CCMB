//
//  CCMBApp.swift
//  CCMB
//
//  Created by Taha Tuna on 21.04.2023.
//

import SwiftUI

@main
struct CCMBApp: App {
    var body: some Scene {
        // Can also add a window group.
        MenuBarExtra{
            CurrencyBarView()

        }label: {
            Image(systemName: "dollarsign.circle")
        }
        .menuBarExtraStyle(.window)
        
        
        // MARK: Menu Bar Style
        // 1. Menu (List Type)
        // 2. Window (View Type)
    }
}
