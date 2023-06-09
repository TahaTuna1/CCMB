//
//  ContentView.swift
//  CCMB
//
//  Created by Taha Tuna
//

import SwiftUI

struct CurrencyBarView: View {
    
    @EnvironmentObject var viewModel: CurrencyViewModel
    
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
                        Text(viewModel.baseCurrency.code)
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
                        ListView(selectedItem: $selectedItem)
                        
                    }
                    .onChange(of: selectedItem) { value in
                        // ON CHANGE
                        viewModel.baseCurrency.code = value
                        viewModel.currencyChanged = true
                        
                        if viewModel.currencyChanged{
                            viewModel.fetchCurrencyData()
                            isShowingList = false
                        }
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
                    name: $viewModel.secondCurrency.code,
                    amount: enteredAmount * viewModel.secondCurrency.value,
                    isShowingList: $isShowingList2,
                    selectedItem: $selectedItem2)
                .blur(radius: viewModel.isLoading ? 2 : 0)
                .environmentObject(viewModel)
                
                SecondaryCurrencyView(
                    name: $viewModel.thirdCurrency.code,
                    amount: enteredAmount * viewModel.thirdCurrency.value,
                    isShowingList: $isShowingList3,
                    selectedItem: $selectedItem3)
                .blur(radius: viewModel.isLoading ? 2 : 0)
                .environmentObject(viewModel)
                
                SecondaryCurrencyView(
                    name: $viewModel.fourthCurrency.code,
                    amount: enteredAmount * viewModel.fourthCurrency.value,
                    isShowingList: $isShowingList4,
                    selectedItem: $selectedItem4)
                .blur(radius: viewModel.isLoading ? 2 : 0)
                .environmentObject(viewModel)
                
                
                //MARK: Buttons
                HStack(alignment: .center, spacing: 25) {
                    
                    //MARK: REFRESH Button
                    Button {
                        // Get all the current currency names and fetch the data
                        if !viewModel.isSubscribed{
                            viewModel.isPaywallActive.toggle()
                        }else{
                            viewModel.fetchCurrencyData()
                        }
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
