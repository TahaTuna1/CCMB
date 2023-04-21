//
//  ContentView.swift
//  CCMB
//
//  Created by Taha Tuna on 21.04.2023.
//

import SwiftUI

struct CurrencyBarView: View {
    @ObservedObject var viewModel = CurrencyViewModel()
    @State private var enteredAmount: Double = 1.0
    @State var infoTabShowing: Bool = false
    
    var body: some View {
        
        ZStack {
            if viewModel.isLoading{
                LoadingView()
            }
            // Content view
            VStack{
                HStack{  //Main
                    Image(systemName: "eurosign").padding(5)
                    Spacer()
                    
                    TextField("Enter Amount", value: $enteredAmount, format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .multilineTextAlignment(.trailing)
                        .padding(5)
                    
                    
                }
                .frame(width: 150, height: 40)
                .background(.red)
                .cornerRadius(10)
                
                
                // 2nd 3rd 4th Currencies
                SecondaryCurrencyView(
                    name: viewModel.secondCurrency.name,
                    amount: enteredAmount * viewModel.secondCurrency.amount)
                .blur(radius: viewModel.isLoading ? 2 : 0)
                
                SecondaryCurrencyView(
                    name: viewModel.thirdCurrency.name,
                    amount: enteredAmount * viewModel.thirdCurrency.amount)
                .blur(radius: viewModel.isLoading ? 2 : 0)
                
                SecondaryCurrencyView(
                    name: viewModel.fourthCurrency.name,
                    amount: enteredAmount * viewModel.fourthCurrency.amount)
                .blur(radius: viewModel.isLoading ? 2 : 0)
                
                
                
                
                //Refresh Button
                Button { // Get all the current currency names and fetch the data
                    viewModel.fetchCurrencyData(currencies: [viewModel.secondCurrency.name, viewModel.thirdCurrency.name, viewModel.fourthCurrency.name])
                } label: {
                    Text("Refresh").frame(width: 100)
                }
                
                
                //QUIT Button - INFO Button
                HStack {
                    Button {
                        NSApplication.shared.terminate(nil)
                        //NSApp.terminate(nil) 2 ways of terminating. Don't know which is the best
                    } label: {
                        Text("Quit").frame(width: 61)
                    }
                    
                    // Info
                    Button {
                        infoTabShowing.toggle()
                    } label: {
                        Image(systemName: "questionmark.app")
                        
                    }
                }
                // Last Update View
                if infoTabShowing{
                    InfoView(date: viewModel.lastUpdate)
                }
                
            }
            .frame(width: 150).padding(15)
        }
        
        
    }
}

// Small Currencies - 2nd, 3rd, 4th
struct SecondaryCurrencyView: View{
    var name: String
    var amount: Double
    var body: some View{
        HStack{
            Text(name)
                .padding(5)
            Spacer()
            Text(String(format: "%.2f", amount))
                .minimumScaleFactor(0.5)
                .padding(5)
        }
        .frame(height: 35)
        .background(Color(.white).opacity(0.05))
        .cornerRadius(5)
        .animation(.spring(), value: 3)
    }
}

struct InfoView: View{
    var date: Date
    var body: some View{
        Text("Last Update \(date)")
            .font(.footnote)
            .opacity(0.3)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyBarView()
    }
}
