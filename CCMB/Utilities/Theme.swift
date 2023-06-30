//
//  Theme.swift
//  CCMB
//
//  Created by Taha Tuna
//

import SwiftUI


enum ThemeKey: String {
    case theme1
    case theme2
}

struct AppTheme: Equatable {
    let mainBackground: Color
    let mainText: Color
    let background: Color
    let text: Color
    
    //Represent Current Theme
    let themeKey: ThemeKey
    
    //Available Themes
    static let theme1 = AppTheme(
        mainBackground: Color("BgMainRed"),
        mainText: Color("TextMainRed"),
        background: Color("BgRed"),
        text: Color("TextRed"),
        themeKey: .theme1)
    
    static let theme2 = AppTheme(
        mainBackground: Color("BgMainBlue"),
        mainText: Color("TextMainBlue"),
        background: Color("BgBlue"),
        text: Color("TextBlue"),
        themeKey: .theme2)
    
    //MARK: Toggle Theme Button Functionality
    func toggleTheme() -> AppTheme {
        return (self.themeKey == .theme1) ? AppTheme.theme2 : AppTheme.theme1
    }
}
