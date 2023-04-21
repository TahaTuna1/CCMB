//
//  ContentView.swift
//  CCMB
//
//  Created by Taha Tuna on 21.04.2023.
//

import SwiftUI

struct CurrencyBarView: View {
    @ObservedObject var viewModel = CurrencyViewModel()
    
    var body: some View {
        
        ZStack {
            // Content view
            VStack{
                HStack{//Main
                    Image(systemName: "eurosign").padding(5)
                    Spacer()
                    Text("10").padding(5)
                }
                .background(.red)
                .cornerRadius(10)
                .frame(width: 120)
                
                
                HStack{
                    Text(viewModel.secondCurrency.name).padding(5)
                    Spacer()
                    Text(String(format: "%.2f", viewModel.secondCurrency.amount))
                }
                HStack{
                    Text(viewModel.thirdCurrency.name).padding(5)
                    Spacer()
                    Text(String(format: "%.2f", viewModel.thirdCurrency.amount))
                }
                HStack{
                    Text(viewModel.fourthCurrency.name).padding(5)
                    Spacer()
                    Text(String(format: "%.2f", viewModel.fourthCurrency.amount))
                }
                
                //Refresh Button
                Button {
                    viewModel.fetchCurrencyData(currencies: ["USD","TRY","RUB"])
                } label: {
                    Text("Refresh").frame(width: 100).foregroundColor(.green)
                }
                
                
                //QUIT Button
                Button {
                    NSApplication.shared.terminate(nil)
                } label: {
                    Text("Quit").frame(width: 100)
                }
                
            }.frame(width: 100).padding(15)
                .background(
                    // Glass morphism background. Linear gradient from white to white
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: Color.white.opacity(0.08), location: 0.0),
                                    .init(color: Color.white.opacity(0.18), location: 1.0)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                )
        }
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyBarView()
    }
}
