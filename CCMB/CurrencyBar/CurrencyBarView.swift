//
//  ContentView.swift
//  CCMB
//
//  Created by Taha Tuna on 21.04.2023.
//

import SwiftUI

struct CurrencyBarView: View {
    var body: some View {
        
        
        ZStack {
            // Content view
            VStack{
                HStack{//Main
                    Text("EUR").padding(5)
                    Spacer()
                    Text("10").padding(5)
                }
                .background(.red)
                .cornerRadius(10)
                .frame(width: 120)
                
                
                HStack{
                    Text("USD")
                    Spacer()
                    Text("10")
                }
                HStack{
                    Text("TRY")
                    Spacer()
                    Text("10")
                }
                HStack{
                    Text("RUB")
                    Spacer()
                    Text("10")
                }
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
                                    .init(color: Color.white.opacity(0.05), location: 0.0),
                                    .init(color: Color.white.opacity(0.1), location: 1.0)
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
