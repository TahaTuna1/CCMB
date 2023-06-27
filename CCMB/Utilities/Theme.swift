//
//  Theme.swift
//  CCMB
//
//  Created by Taha Tuna on 24.04.2023.
//

import SwiftUI

struct AppTheme: Equatable {
    let mainBackground: Color
    let mainText: Color
    let background: Color
    let text: Color
    
    static let theme2 = AppTheme(
        mainBackground: Color("BgMainBlue"),
        mainText: Color("TextMainBlue"),
        background: Color("BgBlue"),
        text: Color("TextBlue"))
    
    static let theme1 = AppTheme(
        mainBackground: Color("BgMainRed"),
        mainText: Color("TextMainRed"),
        background: Color("BgRed"),
        text: Color("TextRed"))
    
    func toggleTheme() -> AppTheme {
            return (self == AppTheme.theme1) ? AppTheme.theme2 : AppTheme.theme1
        }
}
