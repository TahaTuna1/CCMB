//
//  InfoView.swift
//  CCMB
//
//  Created by Taha Tuna
//

import SwiftUI

//Last Update Popover view
struct InfoView: View{
    var date: Date
    var body: some View{
        Text("Last Update \(date.formatted())")
            .font(.footnote)
            .foregroundColor(.black)
            .opacity(0.8)
    }
}
