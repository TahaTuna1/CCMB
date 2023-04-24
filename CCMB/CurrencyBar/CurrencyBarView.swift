//
//  ContentView.swift
//  CCMB
//
//  Created by Taha Tuna on 21.04.2023.
//

import SwiftUI

struct CurrencyBarView: View {
    
    @State var currentTheme: AppTheme = AppTheme.theme1
    
    @ObservedObject var viewModel = CurrencyViewModel()
    @State private var enteredAmount: Double = 1.0
    @State var infoTabShowing: Bool = false
    
    @State private var selectedItem = ""
    @State var isShowingList: Bool = false
    
    @State var isShowingList2: Bool = false// Not the best solution, is it?
    @State var isShowingList3: Bool = false
    @State var isShowingList4: Bool = false
    
    @State private var selectedItem2 = "" // I hate it
    @State private var selectedItem3 = ""
    @State private var selectedItem4 = ""
    
    var body: some View {
        
        ZStack {
            if viewModel.isLoading{
                LoadingView()
            }
            // Content view
            VStack{
                
                
                HStack{  //MARK: Main
                    HStack {
                        Text(viewModel.baseCurrency)
                            .padding(.leading, 5)
                            .foregroundColor(currentTheme.mainText)
                        Image(systemName: "chevron.down")
                            .font(.caption)
                            .foregroundColor(currentTheme.mainText)
                    }
                    .onTapGesture {
                        isShowingList = true
                    }//MARK: Popover List
                    .popover(isPresented: $isShowingList, arrowEdge: .leading) {
                        
                        ListView(viewModel: viewModel, selectedItem: $selectedItem)
                        
                    }// ON CHANGE
                    .onChange(of: selectedItem) { value in
                        viewModel.baseCurrency = value
                        viewModel.currencyChanged = true
                        
                        if viewModel.currencyChanged{
                            viewModel.fetchCurrencyData(
                                currencies: [viewModel.secondCurrency.name,
                                             viewModel.thirdCurrency.name,
                                             viewModel.fourthCurrency.name])
                            isShowingList = false
                        }
                        
                    }
                    // Fetch symbols from local JSON on launch
                    .onAppear{
                        viewModel.fetchSymbols()
                    }
                    
                    
                    Spacer()
                    
                    TextField("Enter Amount", value: $enteredAmount, format: .number)
                        .foregroundColor(currentTheme.mainText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .multilineTextAlignment(.trailing)
                        .padding(5)
                    
                    
                }
                .frame(height: 50)
                .background(currentTheme.mainBackground)
                
                
                // 2nd 3rd 4th Currencies
                SecondaryCurrencyView(
                    name: $viewModel.secondCurrency.name,
                    amount: enteredAmount * viewModel.secondCurrency.amount,
                    isShowingList: $isShowingList2,
                    viewModel: viewModel,
                    selectedItem: $selectedItem2)
                .blur(radius: viewModel.isLoading ? 2 : 0)
                
                SecondaryCurrencyView(
                    name: $viewModel.thirdCurrency.name,
                    amount: enteredAmount * viewModel.thirdCurrency.amount,
                    isShowingList: $isShowingList3,
                    viewModel: viewModel,
                    selectedItem: $selectedItem3)
                .blur(radius: viewModel.isLoading ? 2 : 0)
                
                SecondaryCurrencyView(
                    name: $viewModel.fourthCurrency.name,
                    amount: enteredAmount * viewModel.fourthCurrency.amount,
                    isShowingList: $isShowingList4,
                    viewModel: viewModel,
                    selectedItem: $selectedItem4)
                .blur(radius: viewModel.isLoading ? 2 : 0)
                
                
                
                
                
                
                
                
                
                
                //MARK: Buttons
                HStack {
                    Spacer()
                    //MARK: REFRESH Button
                    Button { // Get all the current currency names and fetch the data
                        viewModel.fetchCurrencyData(
                            currencies: [viewModel.secondCurrency.name,
                                         viewModel.thirdCurrency.name,
                                         viewModel.fourthCurrency.name])
                    } label: {
                        Image(systemName: "dollarsign.arrow.circlepath")
                            .frame(width: 20)
                            .font(.title2)
                            .foregroundColor(viewModel.currencyChanged ? .green : .white)
                    }
                    
                    Spacer()
                    
                    //MARK: INFO Button
                    Button {
                        infoTabShowing.toggle()
                    } label: {
                        Image(systemName: "questionmark.circle")
                            .frame(width: 20)
                            .font(.title3)
                    }
                    
                    Spacer()
                    
                    //MARK: Theme Toggle Button
                    Image(systemName: "eye.circle")
                        .font(.title3)
                        .background(currentTheme.mainText)
                        .onTapGesture {
                            currentTheme = currentTheme.toggleTheme()
                        }
                    
                   
                    Spacer()
                    
                    
                    //MARK: QUIT Button
                    Button {
                        NSApplication.shared.terminate(nil)
                        //NSApp.terminate(nil) 2 ways of terminating. Don't know which is the best
                    } label: {
                        Image(systemName: "power.circle")
                            .frame(width: 20)
                            .font(.title2)
                            .foregroundColor(currentTheme.text)
                            
                        
                    }
                    
                   Spacer()
                    
                }
                    .frame(height: 40)
                    .buttonStyle(.borderless)
                
                
                
                
                // Last Update View
                if infoTabShowing{
                    InfoView(date: viewModel.lastUpdate)
                }
                
            }
            .frame(width: 180)
            .background(currentTheme.background.gradient)
            .foregroundColor(currentTheme.text)
        }.preferredColorScheme(.light)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyBarView()
    }
}
