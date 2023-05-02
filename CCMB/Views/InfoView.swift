//
//  InfoView.swift
//  CCMB
//
//  Created by Taha Tuna on 24.04.2023.
//

import SwiftUI


struct InfoView: View{
    var date: Date
    var body: some View{
        Text("Last Update \(date.formatted())")
            .font(.footnote)
            .opacity(0.3)
    }
}
