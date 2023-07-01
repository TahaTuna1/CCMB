//
//  ListView.swift
//  CCMB
//
//  Created by Taha Tuna
//

import SwiftUI

struct ListView: View{
    @EnvironmentObject var viewModel: CurrencyViewModel
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


//MARK: Search functionality. Gives you an error. Doesn't crash or anything, but annoying. Decide later.
//struct ListView: View{
//    @ObservedObject var viewModel: CurrencyViewModel
//    @Binding var selectedItem: String
//    @State private var searchQuery = ""
//
//    var body: some View{
//        VStack {
//            TextField("Search...", text: $searchQuery)
//                .textFieldStyle(.roundedBorder)
//                .padding(8)
//                .frame(width: 200, alignment: .center)
//
//            List(selection: $selectedItem) {
//                ForEach(viewModel.allCurrencies.filter { searchQuery.isEmpty ? true : $0.name.lowercased().contains(searchQuery.lowercased()) }, id: \.code) { currency in
//                    HStack {
//                        Text(currency.name)
//                        Spacer()
//                        Text(currency.symbol_native)
//                    }
//                    .font(.body).tag(currency.code)
//                    .foregroundColor(.black)
//                    .fontWeight(.light)
//
//                }
//            }
//            .frame(height: 150)
//        }
//    }
//}
