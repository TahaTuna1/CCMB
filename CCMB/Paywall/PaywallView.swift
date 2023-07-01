//
//  PaywallView.swift
//  CCMB
//
//  Created by Taha Tuna
//

//TODO: REFACTOR THE WHOLE THING. PAINFUL TO LOOK AT

import SwiftUI

struct PaywallView: View {
    
    //Terrible. Change
    @State var isWeeklySelected = false
    @State var isMonthlySelected = false
    @State var isAnnuallySelected = false
    var body: some View {
        HStack{
            
            //What users get
            VStack{
                Text("CCMB PRO")
                    .font(.largeTitle)
                    .padding(10)
                
                
                HStack(){
                    Image(systemName: "checkmark.circle")
                    Text("Unlimited Searches")
                }
                .padding(10)
                HStack{
                    Image(systemName: "checkmark.circle")
                    Text("Hourly Updates")
                }
                .padding(10)
                HStack{
                    Image(systemName: "checkmark.circle")
                    Text("170+ Currencies")
                }
                .padding(10)
                HStack{
                    Image(systemName: "checkmark.circle")
                    Text("Different Themes")
                }
                .padding(10)
            }
            .frame(width: 300, height: 300, alignment: .center)
            .background(AppTheme.theme1.background)
            .foregroundColor(AppTheme.theme1.text)
            .fontWeight(.bold)
            
            //Subscription options
            VStack{
                Text("Chose Your Plan")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(10)
                
                HStack{
                    ZStack {
                        VStack{
                            Text("Weekly")
                                .font(.title2)
                                .padding(5)
                            HStack{
                                Image(systemName: "checkmark.circle")
                                Text("1 Day Free Trial")
                            }
                            HStack{
                                Image(systemName: "checkmark.circle")
                                Text("$2.99 / Week")
                            }
                            Text("Billed weekly")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .padding(2)
                        }
                        .frame(width: 150, height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .background(AppTheme.theme2.mainBackground)
                        .onTapGesture {
                            withAnimation {
                                isWeeklySelected = true
                                isMonthlySelected = false
                                isAnnuallySelected = false
                                
                            }
                        }
                        
                        if isWeeklySelected{
                            Image(systemName: "checkmark.circle.fill")
                                .font(.largeTitle)
                                .fontWeight(.light)
                                .offset(x: 60, y: -35)
                            
                        }
                    }
                    
                    ZStack {
                        VStack{
                            Text("Monthly")
                                .font(.title2)
                                .padding(5)
                            HStack{
                                Image(systemName: "checkmark.circle")
                                Text("3 Day Free Trial")
                            }
                            HStack{
                                Image(systemName: "checkmark.circle")
                                Text("$9.99 / Month")
                            }
                            Text("Billed monthly")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .padding(2)
                        }
                        .frame(width: 150, height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .background(AppTheme.theme2.mainBackground)
                        .onTapGesture {
                            withAnimation {
                                isWeeklySelected = false
                                isMonthlySelected = true
                                isAnnuallySelected = false
                            }
                        }
                        if isMonthlySelected{
                            Image(systemName: "checkmark.circle.fill")
                                .font(.largeTitle)
                                .fontWeight(.light)
                                .offset(x: 60, y: -35)
                            
                        }
                    }
                    ZStack {
                        VStack{
                            Text("Annually")
                                .font(.title2)
                                .padding(5)
                            HStack{
                                Image(systemName: "checkmark.circle")
                                Text("7 Day Free Trial")
                            }
                            HStack{
                                Image(systemName: "checkmark.circle")
                                Text("$7.99 / Month")
                            }
                            Text("Billed annually")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .padding(2)
                        }
                        .frame(width: 150, height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .background(AppTheme.theme2.mainBackground)
                        .onTapGesture {
                            withAnimation{
                                isWeeklySelected = false
                                isMonthlySelected = false
                                isAnnuallySelected = true
                            }
                        }
                        if isAnnuallySelected{
                            Image(systemName: "checkmark.circle.fill")
                                .font(.largeTitle)
                                .fontWeight(.light)
                                .offset(x: 60, y: -35)
                            
                        }
                    }
                    
                }
                .padding(10)
                
                HStack{
                    Image(systemName: "lock.circle")
                    Text("Secured by Apple. Cancel anytime.")
                }
                
                Text("The App provides currency conversion information for informational purposes only and does not constitute financial advice. The accuracy of exchange rates cannot be guaranteed. Any reliance on the App's information is solely at your discretion. ")
                    .font(.footnote)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(5)
                
                HStack{
                    Text("Restore Purchase")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.trailing, 20)
                    
                    Text("Skip Offer")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.trailing, 20)
                    
                    Text("Privacy Policy")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.trailing, 20)
                    
                }
            }
            .padding(.trailing, 20)
            .padding(5)
        }
        .background(AppTheme.theme2.mainBackground)
        
    }
}

struct PaywallView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallView()
    }
}
