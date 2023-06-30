//
//  SecondaryCurrencyView.swift
//  CCMB
//
//  Created by Taha Tuna
//

import SwiftUI

// Small Currencies - 2nd, 3rd, 4th
struct SecondaryCurrencyView: View{
    @Binding var name: String
    var amount: Double
    @Binding var isShowingList: Bool
    @ObservedObject var viewModel: CurrencyViewModel
    @Binding var selectedItem: String
    
    var body: some View{
        HStack{
            HStack {
                Text(name)
                    .padding(.leading, 5)
                Image(systemName: "chevron.down").font(.caption)
            }
            .popover(isPresented: $isShowingList, arrowEdge: .bottom) {
                ListView(viewModel: viewModel, selectedItem: $selectedItem)
            }
            .onTapGesture {
                isShowingList = true
            }
            .onChange(of: selectedItem) { value in
                
                name = value
                viewModel.currencyChanged = true
                isShowingList = false
                
            }
            
            Spacer()
            
            Text(String(format: "%.2f", amount))
                .minimumScaleFactor(0.5)
                .padding(5)
        }
        .frame(height: 35)
    }
}

