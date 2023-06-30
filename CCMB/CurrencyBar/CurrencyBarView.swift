//
//  ContentView.swift
//  CCMB
//
//  Created by Taha Tuna
//

import SwiftUI

struct CurrencyBarView: View {
    
    @ObservedObject var viewModel = CurrencyViewModel()
    @State private var enteredAmount: Double = 1.0
    @State var infoTabShowing: Bool = false
    
    @State private var selectedItem = ""
    
    //Lists - Consider changing and adding some search method
    @State var isShowingList: Bool = false
    @State var isShowingList2: Bool = false
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
                        Text(viewModel.baseCurrency.name)
                            .padding(.leading, 5)
                            .foregroundColor(viewModel.currentTheme.mainText)
                        Image(systemName: "chevron.down")
                            .font(.caption)
                            .foregroundColor(viewModel.currentTheme.mainText)
                    }
                    .onTapGesture {
                        isShowingList = true
                    }
                    .popover(isPresented: $isShowingList, arrowEdge: .bottom) {
                        //MARK: Popover List
                        ListView(viewModel: viewModel, selectedItem: $selectedItem)
                        
                    }
                    .onChange(of: selectedItem) { value in
                        // ON CHANGE
                        viewModel.baseCurrency.name = value
                        viewModel.currencyChanged = true
                        
                        if viewModel.currencyChanged{
                            viewModel.fetchCurrencyData()
                            isShowingList = false
                        }
                    }
                    .onAppear{
                        // Fetch symbols from local JSON on launch
                        viewModel.fetchSymbols()
                    }
                    
                    Spacer()
                    
                    TextField("Enter Amount", value: $enteredAmount, format: .number)
                        .foregroundColor(viewModel.currentTheme.mainText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .multilineTextAlignment(.trailing)
                        .padding(5)
                }
                .frame(height: 50)
                .background(viewModel.currentTheme.mainBackground)
                
                
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
                HStack(alignment: .center, spacing: 25) {
                    
                    //MARK: REFRESH Button
                    Button {
                        // Get all the current currency names and fetch the data
                        viewModel.fetchCurrencyData()
                    } label: {
                        Image(systemName: "dollarsign.arrow.circlepath")
                            .frame(width: 20)
                            .font(.title2)
                            .foregroundColor(
                                viewModel.currencyChanged ?
                                    .green : viewModel.currentTheme.mainBackground
                            )
                    }
                    
                    //MARK: INFO Button
                    Button {
                        if viewModel.lastUpdate != Date.distantPast{
                            infoTabShowing.toggle()
                        }
                    } label: {
                        Image(systemName: "questionmark.circle")
                            .frame(width: 20)
                            .font(.title3)
                    }
                    .popover(isPresented: $infoTabShowing, arrowEdge: .bottom) {
                        InfoView(date: viewModel.lastUpdate)
                            .frame(width: 170, height: 50, alignment: .center)
                    }
                    
                    //MARK: Theme Toggle Button
                    Button {
                        withAnimation {
                            viewModel.currentTheme = viewModel.currentTheme.toggleTheme()
                        }
                    } label: {
                        Image(systemName: "eye.circle")
                            .font(.title3)
                    }

                    
                    //MARK: QUIT Button
                    Button {
                        NSApplication.shared.terminate(nil)
                        //NSApp.terminate(nil) 2 ways of terminating. Don't know which is the best
                    } label: {
                        Image(systemName: "power.circle")
                            .frame(width: 20)
                            .font(.title2)
                            .foregroundColor(viewModel.currentTheme.text)
                    }
                }
                .frame(height: 40)
                .buttonStyle(.borderless)
            }
            .frame(width: 180)
            .background(viewModel.currentTheme.background)
            .foregroundColor(viewModel.currentTheme.text)
        }
        .preferredColorScheme(.light)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyBarView()
    }
}
