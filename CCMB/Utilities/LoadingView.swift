//
//  LoadingView.swift
//  CCMB
//
//  Created by Taha Tuna
//

import SwiftUI

struct LoadingView: View{ // Show loading view until the fetching is complete. Need to add isLoading.
    var body: some View{
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .mint))
    }
}
