//
//  ListView.swift
//  CCMB
//
//  Created by Taha Tuna on 24.04.2023.
//

import SwiftUI

struct ListView: View{
    @ObservedObject var viewModel: CurrencyViewModel
    @Binding var selectedItem: String
    
    
    var body: some View{
        List(selection: $selectedItem) {
            ForEach(0 ..< viewModel.allCurrencies.count, id: \.self) { index in
                HStack {
                    Text(viewModel.allCurrencies[index].name)
                    Spacer()
                    Text(viewModel.allCurrencies[index].symbol_native)
                    
                }
                .font(.body).tag(viewModel.allCurrencies[index].code)
                .foregroundColor(.black)
                .fontWeight(.light)
                
            }
        }
        .frame(height: 150)
    }
}
